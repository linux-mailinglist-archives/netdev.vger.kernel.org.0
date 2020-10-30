Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7CD29FF58
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgJ3IEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3IEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 04:04:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F4DC0613CF;
        Fri, 30 Oct 2020 01:04:39 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e15so4583071pfh.6;
        Fri, 30 Oct 2020 01:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8X8qg7nc5GD8btPcN8Lyz97U5dX6BYQStrO+17wQrj8=;
        b=k94nhFzyMtzIBTMsw4imsP6Y6u6eF/kbnbIHvlcLCqWEhP3Vvnnzet4NlgTGZA3YVC
         Bx1Ri1DP0ymZtcuWueEtB8joFVSmDajmNPgEU0Cp7ysmDusIr2GiaNgqDgB8uaRijdCE
         6oELnjpQiy/0MrvRuhf88kqApkYbcCHK166r7Ju0UJCZh4l3Uv8MLziw8FgjzM1TXyNl
         wDqyqB3ZodghgI2MiFp6erPdzDAJaI58H826GIWwf05Eketvp4LpdHJfPXXlvZujPib8
         jV23Mfi2+qIeoyASeoYw7xjtbm4ib1gyJUd5GFsOGQjGMHxPF5T5Y7blJXqVEHlU06wl
         hTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8X8qg7nc5GD8btPcN8Lyz97U5dX6BYQStrO+17wQrj8=;
        b=aaVhbJhm7zD5zw9Yjx9qaBCl7JwZLVWpmQgSB7v+e8Oi75KA/WisRMWcZjPwREb/Zf
         rtQTO9KMK/AZgl97onG4Gl7MkpYkqAAEH4r7yQtLU39tLRt6MzqZd4L3guFM9vA9A+sD
         rdme5X3NdCcCdmtc4uZKyrEfU5YwtPp/aRt/lWJCizx8JfJm2s+oZPNY2aUJrz0fFW0h
         0F8raQOiOdtwmbE4HEanDLb9h518tE7WCR+pp9YyzTB6R+0o1MGQ5W/426Mm0ciLctjS
         7SBOXNlopfTeAGv203u/vCD7JWxCMSvBr3zFsIuI/TY67AUxxBzZQcysZebABsQHeh6F
         +qmQ==
X-Gm-Message-State: AOAM532VDiLho2uDHdH12+QRAExXINheZRUaz+wYyX8/xUfTyE6P64oo
        iqqiEA9MUT+Tsite5rVNGdqWN0Fsl49VrTN5
X-Google-Smtp-Source: ABdhPJxX56haCKQS22i7gSyTnmYRIF6fmeX+qp7XRxCvH+G4tWwWzzNhjVLDPdZEsn+Uyhc5+hNOeQ==
X-Received: by 2002:a63:dc41:: with SMTP id f1mr1153882pgj.342.1604045079294;
        Fri, 30 Oct 2020 01:04:39 -0700 (PDT)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id x123sm5224486pfb.212.2020.10.30.01.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:04:38 -0700 (PDT)
Message-ID: <8fa12bfff1cc30b655934e303cad78ae75b0fcde.camel@gmail.com>
Subject: Re: [PATCH 1/3] mwifiex: disable ps_mode explicitly by default
 instead
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
Date:   Fri, 30 Oct 2020 17:04:34 +0900
In-Reply-To: <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
         <20201028142433.18501-2-kitakar@gmail.com>
         <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-29 at 11:25 -0700, Brian Norris wrote:
> On Wed, Oct 28, 2020 at 7:04 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> > 
> > On Microsoft Surface devices (PCIe-88W8897), the ps_mode causes
> > connection unstable, especially with 5GHz APs. Then, it eventually causes
> > fw crash.
> > 
> > This commit disables ps_mode by default instead of enabling it.
> > 
> > Required code is extracted from mwifiex_drv_set_power().
> > 
> > Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> 
> You should read up on WIPHY_FLAG_PS_ON_BY_DEFAULT and
> CONFIG_CFG80211_DEFAULT_PS, and set/respect those appropriately (hint:
> mwifiex sets WIPHY_FLAG_PS_ON_BY_DEFAULT, and your patch makes this a
> lie). Also, this seems like a quirk that you haven't properly worked
> out -- if you're working on a quirk framework in your other series,
> you should just key into that.

Thanks for the review! I didn't know about the flag, much appreciated.
By setting the flag to false explicitly, indeed userspace doesn't try
to enable power_save now at least for this short amount of time. I wonder
if I can drop the second patch (adding module parameter) now. But I still
want to make sure that power_save won't be enabled by userspace tools by
default.

Regarding quirks, I also don't want to break existing users. So, of course
I can try to use the quirk framework if we really can't fix the firmware.

> For the record, Chrome OS supports plenty of mwifiex systems with 8897
> (SDIO only) and 8997 (PCIe), with PS enabled, and you're hurting
> those. Your problem sounds to be exclusively a problem with the PCIe
> 8897 firmware.

Actually, I already know that some Chromebooks use these mwifiex cards
(but not out PCIe-88W8897) because I personally like chromiumos. I'm
always wondering what is the difference. If the difference is firmware,
our PCIe-88W8897 firmware should really be fixed instead of this stupid
series.

Yes, I'm sorry that I know this series is just a stupid one but I have to
send this anyway because this stability issue has not been fixed for a
long time. I should have added this buglink to every commit as well:

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681

If the firmware can't be fixed, I'm afraid I have to go this way. It makes
no sense to keep enabling power_save for the affected devices if we know
it's broken.

> As-is, NAK.
> 
> Brian


