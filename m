Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC08F29FF41
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 08:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgJ3H6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 03:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3H6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 03:58:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFFDC0613CF;
        Fri, 30 Oct 2020 00:58:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 10so4574432pfp.5;
        Fri, 30 Oct 2020 00:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=xZQ2THIAPp3CeaUayQZop8mnVehMh5jmfzwWnkd39wI=;
        b=OpjLRrWqL/AAXkAysic/cBVIDF0sWhjg1pOIrdCRMe6vMCoGa+otctItlGATrUXv4v
         DF4U7Me/ok6tLghjnaJNG/S4srUR25jQycOERJLoIP2t9a4KuaZMJdO+v1jH9cDr2Dgm
         428XoMvz45hJS8hRrj+iCqjCJO4U0Y9KkBQN0yqz2WBk5wUQ1+TFZz1Z/X9/vPrQ3UM3
         3A8wK6bvRIXajXr9h+oELPq6cC+wfqdyv4OeUBV2pQp+Al/q+ONKUychaxR7014snUnn
         UaeGAZ/0lloVp6Zr1tH0HQ/1Uxdm9hGxWrXgqa7pHP2zEzCwi+odZdqvqTKAaBtwBmr4
         uEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xZQ2THIAPp3CeaUayQZop8mnVehMh5jmfzwWnkd39wI=;
        b=hOCNBkrCYzfU5bV5P72D05bYo61uHELEVGS8bsZxuwkzJsdLIi1iFhRdphnrceHkbq
         mWA8iil363X9TnhQ7T8qQEZmhcPrjoZLrb40MV2KuKprNbZq8/erRq5MYYZPJesR3k/l
         NLf1Ynh58+WTv8GKrpCZtCPGyBA+CMNYjyANN/gA9osXU30SsSm+kNEB/lz26ucrfX4Y
         9PPJqxmerEp8ir59DPUVJ1Vyn4wIBBukMfPHCm5mKwngoIkK4w3y16KMmXbL9wrs5VSu
         VI6Qb3fAUZS6EBuyKAsN/E8pnVhXVRAt0ZuqqH7bPFS+AHJLG5EBWiM9QfblVEa/H/DR
         LPhg==
X-Gm-Message-State: AOAM530j6GMKHsHsEf7In8iCbSeNmDHcs6CHXqn2O8osEpLimN4hsjIH
        ZLCwNCoJrH/+59YFs1/v/v4=
X-Google-Smtp-Source: ABdhPJx0vnWOecHcNLdC/+nRjUYBCw1iG5v5iX/Kb4GE6JO6zSebkN3aolnq+qtv3bT7ty2UbnvDnQ==
X-Received: by 2002:a17:90a:ce13:: with SMTP id f19mr1396016pju.122.1604044718182;
        Fri, 30 Oct 2020 00:58:38 -0700 (PDT)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id bo16sm2359198pjb.41.2020.10.30.00.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 00:58:37 -0700 (PDT)
Message-ID: <837d7ecd6f8a810153d219ec0b4995856abbe458.camel@gmail.com>
Subject: Re: [PATCH 2/3] mwifiex: add allow_ps_mode module parameter
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
Date:   Fri, 30 Oct 2020 16:58:33 +0900
In-Reply-To: <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
         <20201028142433.18501-3-kitakar@gmail.com>
         <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-28 at 15:04 -0700, Brian Norris wrote:
> On Wed, Oct 28, 2020 at 2:56 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> > 
> > To make the ps_mode (power_save) control easier, this commit adds a new
> > module parameter allow_ps_mode and set it false (disallowed) by default.
> 
> This sounds like a bad idea, as it breaks all the existing users who
> expect this feature to be allowed. Seems like you should flip the
> defaults. Without some better justification, NACK.

Thanks for the review! I wanted to open a discussion widely and wanted
to ask from the upstream developers the direction of how this stability
issue should be resolved.

I added the link to the Bugzilla in the cover-letter (that should have
arrived on the mailing list now), but I should have added this to every
commit as well:

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681

This stability issue exists for a long time. I also submitted there the
required kernel log and device_dump more than three months ago. However,
unfortunately, it's not fixed yet. So, I have to send a series like this.

If we know that the power_save feature is broken (on some devices), I
think it should be fixed in either firmware or driver for the affected
devices. It makes no sense to keep enabling the broken features by
default.

Because userspace tools sometimes try to enable power_save anyway
regardless of default driver settings (expecting it's not broken, but
in fact it's broken), the module parameter like this is required in
addition to the first patch of this series. The commit 8298383c2cd5
("ath9k: Do not support PowerSave by default") also does the same thing
for this purpose.

On the other hand, I agree that I don't want to break the existing users.
As you mentioned in the reply to the first patch, I can set the default
value of this parameter depending on the chip id (88W8897) or DMI matching.

> Also, I can't find the other 2 patches in this alleged series. Maybe
> they're still making it through the mailing lists and archives.

Yes, there seems to be a problem with the mailing list at the time.
All the other patches I sent have arrived by now.

> Brian
> 
> > When this parameter is set to false, changing the power_save mode will
> > be disallowed like the following:
> > 
> >     $ sudo iw dev mlan0 set power_save on
> >     command failed: Operation not permitted (-1)
> > 
> > Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>


