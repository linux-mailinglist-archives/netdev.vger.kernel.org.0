Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A7173E33
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390477AbfGXTnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:43:04 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34091 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390462AbfGXTnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:43:03 -0400
Received: by mail-ot1-f66.google.com with SMTP id n5so49149379otk.1;
        Wed, 24 Jul 2019 12:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjSdWDTJogyq8S7mZs7e3CcybE/Qyo4+rR9MEOHtmug=;
        b=o6HuK98LM2PourpLrfOXA9tnYn/CKdQI2hdLQrkUfzkb1jy6E00k50kTtogJtwlvv2
         57+lXOamDe30b8BogWXuiJtzUKWcGaJV6sEulXuVmyujuwypbLlkUWQeztRy/gZ05fri
         rpYo12797NrIwUuayvg+Z4ES91GZ8cBBa8IbQ1jTT3Bg7RFxYzNSIl7vwRhqeYbhq+0M
         H9F6O+Ekj4pVyD82SnQrijpG1v/GYtQkU3UidTzWXAJFkpesh8y/WJ2Jqfnu2rgDzLum
         E4VD/T+1+B1OLCrWBhROAXd8QBVFbq5XAdTD6CPrapWuSOZSBBM9dWVUdOTJhNGQozY8
         mffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjSdWDTJogyq8S7mZs7e3CcybE/Qyo4+rR9MEOHtmug=;
        b=PAePG3mA3YcwPyRksNB4gvjWUw7dxPbUukvPp2v3A9EUO3mKaIXCfzchVPXSzEqWRO
         Ge8McQGvO8KuznCnJsh6+6STswtAE8/zkvwUkboeq6o0VOcLf35qTXIgNH2jenpXhMXg
         PlcUFu5P6oRZThiZJCzDCb0cx210KG7gPFCGoti0Du3Dx/eC5JnuyRca+RInp/t31ERi
         Iao3KxojsuGZZ2gyBhOxCuoaRPuI0++lQFODSwQYDTXYCopIRL/vfWfGISqxVW3Kprl/
         Is0r41BgZgBQpFFSq0ZEqihEaRDzJO8roa/uKGudaAE5Lp8HLqcXNnIToa2iwllOVDeE
         UC/w==
X-Gm-Message-State: APjAAAWXgW/e7Vdig8dLRt4jJUZBMCX7+RoRX/My5L+LFluThzbS8lAd
        mNR7FQv/ZMt+Eci5M9QgS2h9o86M0+kJHsPYjmw=
X-Google-Smtp-Source: APXvYqwGZraz9ZuMPAHtLv4av8XeMxMtRcV2ny/mkglBe9Iigbt3FbbIW4gbqH1rL+ysvtoWDs7Yddme7mzuJsK+3f4=
X-Received: by 2002:a9d:590d:: with SMTP id t13mr2409952oth.281.1563997381856;
 Wed, 24 Jul 2019 12:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190724015411.66525-1-yuehaibing@huawei.com>
In-Reply-To: <20190724015411.66525-1-yuehaibing@huawei.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Wed, 24 Jul 2019 21:42:48 +0200
Message-ID: <CAAd0S9BvTfRyUVkQzcczyNkU_oeU5hNdK3KVQzLsU21b4JGNTQ@mail.gmail.com>
Subject: Re: [PATCH] carl9170: remove set but not used variable 'udev'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 3:48 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/ath/carl9170/usb.c: In function 'carl9170_usb_disconnect':
> drivers/net/wireless/ath/carl9170/usb.c:1110:21: warning:
>  variable 'udev' set but not used [-Wunused-but-set-variable]
>
> It is not used, so can be removed.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
Isn't this the same patch you sent earlier:

https://patchwork.kernel.org/patch/11027909/

From what I can tell, it's the same but with an extra [-next], I
remember that I've acked that one
but your patch now does not have it? Is this an oversight, because I'm
the maintainer for this
driver. So, in my opinion at least the "ack" should have some value
and shouldn't be "ignored".

Look, from what I know, Kalle is not ignoring you, It's just that
carl9170 is no longer top priority.
So please be patient. As long as its queued in the patchwork it will
get considered.

Cheers,
Christian

>  drivers/net/wireless/ath/carl9170/usb.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
> index 99f1897a775d..486957a04bd1 100644
> --- a/drivers/net/wireless/ath/carl9170/usb.c
> +++ b/drivers/net/wireless/ath/carl9170/usb.c
> @@ -1107,12 +1107,10 @@ static int carl9170_usb_probe(struct usb_interface *intf,
>  static void carl9170_usb_disconnect(struct usb_interface *intf)
>  {
>         struct ar9170 *ar = usb_get_intfdata(intf);
> -       struct usb_device *udev;
>
>         if (WARN_ON(!ar))
>                 return;
>
> -       udev = ar->udev;
>         wait_for_completion(&ar->fw_load_wait);
>
>         if (IS_INITIALIZED(ar)) {
>
>
>
