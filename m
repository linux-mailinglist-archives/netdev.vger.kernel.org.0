Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2FF2A02E4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 11:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgJ3KaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 06:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgJ3KaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 06:30:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B064AC0613CF;
        Fri, 30 Oct 2020 03:30:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b12so2750858plr.4;
        Fri, 30 Oct 2020 03:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vmR0xRpwru0r8RqR6Di+jbvSyh5RJTUS+Ibwo4lVDH0=;
        b=c+dyB/nIrgNfcpQA+7ogNajQ0rdUF4Pl5UCnqY/3R2iAW88tjSeRb+Ezx+u0PLKCMw
         g9VH2/KDzTFeSmXE+A2fezdsa8mU5/799uy4Gq9/xOXI6JEUSEvhdxjd5RRTCmIWQA1m
         yownctA+sPFBtbtjfxnR0nMvWqN83pcgyRaxmmO5Uyy+wi27ej80Esh4YU1Ph6fkhYaY
         LHN+E7oeoMRsVO9iV80IBFk57Yt3wptBwtVTWukJeefhAQ6ZU+aT8JJMF0WLK68zJ9kX
         bzsCLglJhk6CkTmnfQy3I/gXgVv7iib4iCu20cemDvYq6FdhqU0KvJdYgHeHMbX2g4iq
         W2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vmR0xRpwru0r8RqR6Di+jbvSyh5RJTUS+Ibwo4lVDH0=;
        b=HS+RKFdRG+xOidVv1g0N6gVoybXpWHgCdFf5fK6F4Xn1rmXDhOTa/dEwy57I868aEf
         k9QJTOgowYDn5potwWX5hPtA1RWtIb2AWSrDVubBl7LhWnAX2lZF2QnVfJj5na8t9Koc
         JBw61OgfHYn4725fN+rRu5fwQb9KnilewuafMEq8fJfGtEdNKTXYPba58gP2XaE0UtvS
         8hqZN0AUiZyznjAevYEyIcjTMdfJUV0XunlXxmy5yozudjlKnYKKFlxobAitGJBDfJL4
         qd8+fQv7Bb9+DbxYzW1dD8OZUGOygd8Vdz/iZkMMRWh+Dx59eWhZB7dLGovKOA+V0KsD
         wkvA==
X-Gm-Message-State: AOAM532u1cpv5U6shpoGt7bya6p+LF8BAT0WnxvW5F4R46nlSDRGlA6w
        bHBxlR/U8bQUDTgmGy+Ss2M=
X-Google-Smtp-Source: ABdhPJwz8r9gsVVt86pXumYGcxNlb/aUgHxXvbAauAxb1OzNcDaEIw3RpdsRz89Pan7QJlUpwKW5sg==
X-Received: by 2002:a17:902:bb86:b029:d5:28ac:8800 with SMTP id m6-20020a170902bb86b02900d528ac8800mr8258339pls.27.1604053820134;
        Fri, 30 Oct 2020 03:30:20 -0700 (PDT)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id g22sm5705468pfh.147.2020.10.30.03.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:30:19 -0700 (PDT)
Message-ID: <7db5b6cba1548308a63855ec1dda836b6d6d9757.camel@gmail.com>
Subject: Re: [PATCH] mwifiex: pcie: add enable_device_dump module parameter
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Fri, 30 Oct 2020 19:30:15 +0900
In-Reply-To: <CA+ASDXPX+fadTKLnxNVZQ0CehsHNwvWHXEdLqZVDoQ6hf6Wp8Q@mail.gmail.com>
References: <20201028142625.18642-1-kitakar@gmail.com>
         <CA+ASDXPX+fadTKLnxNVZQ0CehsHNwvWHXEdLqZVDoQ6hf6Wp8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-28 at 17:12 -0700, Brian Norris wrote:
> On Wed, Oct 28, 2020 at 3:58 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> > 
> > The devicve_dump may take a little bit long time and users may want to
> > disable the dump for daily usage.
> > 
> > This commit adds a new module parameter enable_device_dump and disables
> > the device_dump by default.
> 
> As with one of your other patches, please don't change the defaults
> and hide them under a module parameter. If you're adding a module
> parameter, leave the default behavior alone.

Thanks for the review!

I mentioned about power_save stability on the other patches. But I should
have added this fact into the commit message of this patch that even if
we disable that power_save, the firmware crashes a lot on some specific
devices. Really a lot.

For example, as far as I know Surface Pro 5 needs ASPM L1.2 substate
disabled to avoid the firmware crash. Disabling it is still acceptable.
On the other hand, Surface 3 needs L1 ASPM state disabled. This is not
acceptable because this breaks S0ix. Anyway, handling ASPM should be done
in firmware I think.

So, the context of why I sent this patch is the next. We can't fix the
fw crash itself, so, we decided to just let it crash and reset by itself
(with the other fw reset quirks I sent). In this way, the time it does
device_dump is really annoying if fw crashes so often.

Let me know if splitting this patch like this works. 1) The first patch
is to add this module parameter but don't change the default behavior.
2) The second patch is to change the parameter value depending on the
DMI matching or something so that it doesn't break the existing users.

But what I want to say here as well is that, if the firmware can be fixed,
we don't need a patch like this.

> This also seems like something that might be nicer as a user-space
> knob in generic form (similar to "/sys/class/devcoredump/disabled",
> except on a per-device basis, and fed back to the driver so it doesn't
> waste time generating such dumps), but I suppose I can see why a
> module parameter (so you can just stick your configuration in
> /etc/modprobe.d/) might be easier to deal with in some cases.

Agreed.

> Brian


