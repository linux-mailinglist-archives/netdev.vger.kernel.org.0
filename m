Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E450F1641
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 13:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfKFMqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 07:46:52 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34388 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728716AbfKFMqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 07:46:52 -0500
Received: by mail-io1-f66.google.com with SMTP id q83so5608675iod.1;
        Wed, 06 Nov 2019 04:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCWYOfZFN/44tRSynwvPgk+ZFvjc1PN3JD152ApZLIs=;
        b=YO1PIviEFXcvMwOzcLr7W9j3tkNWjWmZVRmmbBwCVWdf4njxh8ZgcFR8HeDSF+hOLD
         YNda4feo1wZI/GqtqfQb3wE+rpy8GQRkrY9Y7BeO5xWzJX9jW873TJ9JkPePEEdwqLAB
         V6T6PjfnVIvHA2aI7PIq7vYu8t4/Hty1mcdF+1AbShBcG5RiDs225rDnEHQ/yEDhOXxF
         lZJqMKWm609urv9jHt9sBXR/GrG9gJAy3E3TutUJ1lg9xQ6+H2oxXw2jKuX+JTULwy2U
         xnQkZITICo0fohIxCUF4sREbMqKmbflNDM6gDys8ppM3sM5/RA45IMd0mxWkQvcRhe1j
         cOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCWYOfZFN/44tRSynwvPgk+ZFvjc1PN3JD152ApZLIs=;
        b=XKHEsiKN4dSjhv9I4x3sAZi5Dv5F35REpKU/5KFtS5WIJpqUZYQuTq+1OoDULopRw8
         UBPPWyHKbk7dg8ZvY3NjiOReOTrHi0ViRPfK2Ycss9C1kLZBGK1pphiySfGEoFzCh2zm
         tGOoXVGd5JlHeg0vEc8jirmxLb8+4Xxb62SsrzkwjbBKGYROGifbPDkLx0LPAOqUnpiZ
         vIJshB8xWuaMbdPIzQq6BAv2QMSneGR15U6p8NRi3OZRSF+aIMqT9j4hpOE48RMasrwn
         BSEFp7tqS+uAq/jGtlxuxHfQ2yjTfq39lOP54jIxkSzfDGjWdxON/oTc703nUYzVVBfP
         BbYA==
X-Gm-Message-State: APjAAAWc7i1OxlG1jTXvj6UnBw1AmyUQ3NnwyprjLk8X2CruRyVWA6U/
        pu87lmemlbs8O7mSnJC7Sf8W1UnIavGpU++UHVZJHA==
X-Google-Smtp-Source: APXvYqzFI1dHLVepv5uRK9hk93VcmoCXY+rvxbx+FnKtn7+KcUv21OtpZlFMta24GD0VFks496XYtMzzGKx3DX7/Ao4=
X-Received: by 2002:a6b:6f16:: with SMTP id k22mr3436671ioc.205.1573044411187;
 Wed, 06 Nov 2019 04:46:51 -0800 (PST)
MIME-Version: 1.0
References: <CAHCN7xJiJKBgkiRm-MF9NpgQqfV4=zSVRShc5Sb5Lya2TAxU0g@mail.gmail.com>
 <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com>
 <87sgn1z467.fsf@codeaurora.org> <7BC95BF7-0E1D-4863-AB71-37BB6E8E297E@goldelico.com>
In-Reply-To: <7BC95BF7-0E1D-4863-AB71-37BB6E8E297E@goldelico.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Wed, 6 Nov 2019 06:46:39 -0600
Message-ID: <CAHCN7x+0KEQGztgn0+75kNNU87__zbatzCtuSX0_EMLxjTnvRg@mail.gmail.com>
Subject: Re: Long Delay on startup of wl18xx Wireless chip
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 4:38 AM H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
>
> > Am 06.11.2019 um 11:32 schrieb Kalle Valo <kvalo@codeaurora.org>:
> >
> > Adam Ford <aford173@gmail.com> writes:
> >
> >> On Tue, Nov 5, 2019 at 12:25 PM Adam Ford <aford173@gmail.com> wrote:
> >>>
> >>> I am seeing a really long delay at startup of the wl18xx using the 5.4 kernel.
> >>>
> >>
> >> Sorry I had to resend.  I forgot to do plaintext.  Google switched
> >> settings on me and neglected to inform me.
> >>
> >>
> >>> [ 7.895551] wl18xx_driver wl18xx.2.auto: Direct firmware load for
> >>> ti-connectivity/wl18xx-conf.bin failed with error -2
> >>> [ 7.906416] wl18xx_driver wl18xx.2.auto: Falling back to sysfs
> >>> fallback for: ti-connectivity/wl18xx-conf.bin
> >>>
> >>> At this point in the sequence, I can login to Linux, but the WL18xx is unavailable.
> >>>
> >>> [   35.032382] vwl1837: disabling
> >>> [ 69.594874] wlcore: ERROR could not get configuration binary
> >>> ti-connectivity/wl18xx-conf.bin: -11
> >>> [   69.604013] wlcore: WARNING falling back to default config
> >>> [   70.174821] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
> >>> [ 70.189003] wlcore: WARNING Detected unconfigured mac address in
> >>> nvs, derive from fuse instead.
> >>> [   70.197851] wlcore: WARNING This default nvs file can be removed from the file system
> >>> [   70.218816] wlcore: loaded
> >>>
> >>> It is now at this point when the wl18xx is available.
> >>>
> >>> I have the wl18xx and wlcore setup as a module so it should load
> >>> after the filesystem is mounted. I am not using a wl18xx-conf.bin,
> >>> but I never needed to use this before.
> >>>
> >>> It seems to me unreasonable to wait 60+ seconds after everything is
> >>> mounted for the wireless chip to become available. Before I attempt
> >>> to bisect this, I was hoping someone might have seen this. I am also
> >>> trying to avoid duplicating someone else's efforts.
> >>>
> >>> I know the 4.19 doesn't behave like this.
> >
> > Try disabling CONFIG_FW_LOADER_USER_HELPER, that usually causes a 60
> > second delay if the user space is not setup to handle the request. (Or
> > something like that.)

Thank you for the pointer on that.  It addressed my issue.

adam
>
> I can confirm that I have it disabled in our config which seems to work.
>
> BR,
> Nikolaus
>
