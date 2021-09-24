Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4853416EC2
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbhIXJVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:21:55 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:49321 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244460AbhIXJVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:21:51 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N7xml-1myivx0Xxb-014yY9; Fri, 24 Sep 2021 11:20:10 +0200
Received: by mail-wr1-f48.google.com with SMTP id u18so25373704wrg.5;
        Fri, 24 Sep 2021 02:20:10 -0700 (PDT)
X-Gm-Message-State: AOAM531ZRidaFLxqjNvq8+5WzrW2DGyhvsdhV+Gt6CfEeVn3/rT2Tg7M
        x9FA+F6Al1cZDkZLbqo5UDJk4GhhurJXCkjzKhs=
X-Google-Smtp-Source: ABdhPJw/DaP5MFHWrAmrBawPKujxvaEy1saNan1Sv6h0Z1PGsCq9rfbxkvoJYM9RN7S6vpATkMqaPUC+Jg7uZduun2c=
X-Received: by 2002:a1c:23cb:: with SMTP id j194mr956579wmj.1.1632475209761;
 Fri, 24 Sep 2021 02:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XOvGQrRTaTkaJ0p3zR7y7nrAWD79r48=L_BbOyrK9X-vA@mail.gmail.com>
In-Reply-To: <CAFcO6XOvGQrRTaTkaJ0p3zR7y7nrAWD79r48=L_BbOyrK9X-vA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 24 Sep 2021 11:19:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0kG_gdpaOoLb5H2qeq-T7orQ+2n19NNWQaRKgVNotDkw@mail.gmail.com>
Message-ID: <CAK8P3a0kG_gdpaOoLb5H2qeq-T7orQ+2n19NNWQaRKgVNotDkw@mail.gmail.com>
Subject: Re: There is an array-index-out-bounds bug in detach_capi_ctr in drivers/isdn/capi/kcapi.c
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:rnFoH1whtbLGVQn+3VN4wntYNHUQOXRXk7zPH9bvqtgXohY11vo
 C8KTKSYUKDh0phjnjkHGaDp3bYqZwFi5F+NFKCl0lr5vwD0h8GENPyqLvWY7/wjAs1QDDcG
 pCGGyggcEhaSCsMJNJwvGRBEyZmh0AepN6pd4wkEmja7dfN49d+zbS9+utqBHTa1nNKBx16
 A1P1YpVScUt/T9rkbEGnw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nvRV0zLpxWY=:yZFM86dTtJo1FCIewACwn9
 Uwi0pwnOcovaVLfodk8KOnQoZ4f9Iti8kxWQaTMcawizc93f2HHXX7XkiOyVxdJkSsPEZbudB
 +jD+KXcah4mW6Er0/ycH+FsBDwjwqib2g8ViLSHOenV95iKFx6qVFeZYujzv9mE3kp82TpKgr
 aJffI2GIoOjMktFKcvja4wd1+MTYwLSLdomffWaefgpKWhezWx2z6Wo8x3HOdSdpCEvJQvXLs
 eNdO+C6p0ffyoCicarMGG0kOwKe3PergOn2YhQX/YSiI/0fOrqgwIe3dWLw7uWsNaT/X5HVEp
 PkvbbwIz7HAqq0ewYgGXaxofNr2qiz++3XcYTJzNSErnbaUXIAQYxcAGgNRKaHj5V0vX4KFA7
 yEzO6D/W9dhwxeG2OqWZ2fvFlPxi+TrQ4R3MkqmdX4/x0r3dOfqz5ZWkOTurAOhWrEI4Y45ZD
 TBGdj2Hx2rmpkot+Hu8BPf989/ebbTn+rIOREsWtjx/b5L7KsivdA7aMfCfYi+18GhyEXnI/2
 xl4vh1xIlm9f2kSU3JvHhxVRsQaCw4ZwPpLXaQ1GnbKzIHuDEj+JqBYt28VSAfcnlX8z+0A+c
 j5xVq+d0esx8b/yQ1s+aMb+YnX6fevnovQfBj/RfsNlCNCcEQTyO8wOE4saUXcrSnmr+p7NJP
 IUtKXSIOvnHOLWGLLFb0izMrMKD8PNw/AjhOhgtg5lb+UA4FKlzxDLaaO4D1KwWQZ334+4I9r
 EUz+46CAA6cH2EzrDuNHZLwiR3pkiRus7qIoUVHif6iKbhKlwNwTS1F5gIrCI66RKl6CmQE58
 rYTjGfHo/P5MtY5lNrVR9R25NLV3sOq3zB/fPBDNw3AC8STLzLzNVzd+8Tsw/fW+BrSaoj2xz
 qnY7lsajBFliz1oAa81Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 10:44 AM butt3rflyh4ck
<butterflyhuangxx@gmail.com> wrote:
>
> Hi, there is an array-index-out-bounds bug in detach_capi_ctr in
> drivers/isdn/capi/kcapi.c and I reproduce it on 5.15.0-rc2+.

Thank you for the detailed report!

> ###Analyze
>  we can call CMTPCONNADD ioctl and it would invoke
> do_cmtp_sock_ioctl(), it would call cmtp_add_connection().
> the chain of call is as follows.
> ioctl(CMTPCONNADD)
>    ->cmtp_sock_ioctl()
>          -->do_cmtp_sock_ioctl()
>             --->cmtp_add_connection()
>                 ---->kthread_run()
>                 ---->cmtp_attach_device()
> the function would add a cmtp session to a controller. Let us see the code.

When I last touched the capi code, I tried to remove it all, but we then
left it in the kernel because the bluetooth cmtp code can still theoretically
use it.

May I ask how you managed to run into this? Did you find the bug through
inspection first and then produce it using cmtp, or did you actually use
cmtp?

If the only purpose of cmtp is now to be a target for exploits, then I
would suggest we consider removing both cmtp and capi for
good after backporting your fix to stable kernels. Obviously
if it turns out that someone actually uses cmtp and/or capi, we
should not remove it.

> If the cmtp_add_connection() call cmtp_attach_device() not yet, the
> cmtp_session->capi_ctr->cnr just is an ZERO.
>
> The capi_controller[-1] make no sense. so should check that the
> cmtp_session->capi_ctr->cnr is not an ZERO

I would consider that a problem in cmtp, not in capi, though making
capi more robust as in your patch does address the immediate issue.

> diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
> index cb0afe897162..38502a955f13 100644
> --- a/drivers/isdn/capi/kcapi.c
> +++ b/drivers/isdn/capi/kcapi.c
> @@ -480,7 +480,7 @@ int detach_capi_ctr(struct capi_ctr *ctr)
>
>         ctr_down(ctr, CAPI_CTR_DETACHED);
>
> -       if (capi_controller[ctr->cnr - 1] != ctr) {
> +       if (!ctr->cnr || capi_controller[ctr->cnr - 1] != ctr) {
>                 err = -EINVAL;
>                 goto unlock_out;
>         }

I think the API that is meant to be used here is
get_capi_ctr_by_nr(), which has that check.

        Arnd
