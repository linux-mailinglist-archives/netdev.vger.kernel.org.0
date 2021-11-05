Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706DF446AF6
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhKEWnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhKEWnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 18:43:51 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D239C061570;
        Fri,  5 Nov 2021 15:41:11 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id e2so19773975uax.7;
        Fri, 05 Nov 2021 15:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0a7dg35XHrmtUCRAi7lClbJsNY/QJq6psLAhwwdYnw4=;
        b=RhcIIgGEFmRvzvZO8EvD6sauO1oLg0ms5wxRkQFN77XnA6f3hPrNJiRG4BawelCAkG
         N+3kuD8SAEK34INv0sy/I5ZLoX2O5wX5fYcejD2XsOWodRtefCitLcBrSafcPKUT4/vb
         6lQtM3H4WwDu4UPKAlTG2lTcvnqelTjIRwCs2vWKv4yVy4Q5b5tAzWrydMoqU7uLuu94
         md9PbthnFJ46qB9mHh/V7MyAJDH8vOtpbyFgEC+DIQlDnehh6DLUk8fMio2X7qKF8QII
         RCPUTpQzOuovChWUSvhCx2kj6iZt7fbUDtwIOrkfLySa0fKz8mlsZcmum6VmV2MSpIek
         yJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0a7dg35XHrmtUCRAi7lClbJsNY/QJq6psLAhwwdYnw4=;
        b=eajPezpim0qR/dY711DnN+xR668R56m7f5D5FXh0etNmO0OClyosfWd4z4K3ZJiFpC
         doY7a46Y3X3DcJjtBL6Ic9N+R6um/7UZokT6mk7AW6hQuapmpVhC77A+bhgn8tyrjUG6
         Uy+B110oazEjve+YIbQmP8v0adCj/rc2DoAQ4Fay7fproK3bIMxxRPqvqlsQlFo6B5Hn
         ePI34XlmLM+lG2CZKuPLDaBTbhtK9Tftnsoc3J+GDOv/1ZrY3HXRyTjBq5lpII+58Kqz
         270+9gOlOi2AMzVsZELV1P/ioakxjGdcLTa4RxgqE4PUzbS8Yorg7YrpN3gUeqB8o1wD
         e+vg==
X-Gm-Message-State: AOAM531knMs6+l+Frrj2rAEdtFPsAtN4QN1LxgE6gMh/owjppaMyr/2q
        JSZPoLOG627prPMaVxW/+iPUIFHgLNZ6u41Ua7Q=
X-Google-Smtp-Source: ABdhPJwJQScm3YSfpsT05NMISjzJ/+d1IlETosN0E8dq4Zvv/4iKfmfC3nhbKwQng4OXIMY1Mf/lfWHpVgqYhNN0vVY=
X-Received: by 2002:a05:6102:3589:: with SMTP id h9mr61620425vsu.39.1636152069984;
 Fri, 05 Nov 2021 15:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211105222820.1.I2a8b2f2e52d05ae9ead3f3dcc1dd90ef47a7acd7@changeid>
In-Reply-To: <20211105222820.1.I2a8b2f2e52d05ae9ead3f3dcc1dd90ef47a7acd7@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 5 Nov 2021 15:40:59 -0700
Message-ID: <CABBYNZJiXpuyZhtDgqo+YuA5DJpZfc6UaM4G8t0Vh-3xbKk-hg@mail.gmail.com>
Subject: Re: [PATCH] bluetooth: Don't initialize msft/aosp when using user channel
To:     Jesse Melhuish <melhuishj@chromium.org>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse,

On Fri, Nov 5, 2021 at 3:29 PM Jesse Melhuish <melhuishj@chromium.org> wrote:
>
> A race condition is triggered when usermode control is given to
> userspace before the kernel's MSFT query responds, resulting in an
> unexpected response to userspace's reset command.
>
> Issue can be observed in btmon:
> < HCI Command: Vendor (0x3f|0x001e) plen 2                    #3 [hci0]
>         05 01                                            ..
> @ USER Open: bt_stack_manage (privileged) version 2.22  {0x0002} [hci0]
> < HCI Command: Reset (0x03|0x0003) plen 0                     #4 [hci0]
> > HCI Event: Command Complete (0x0e) plen 5                   #5 [hci0]
>       Vendor (0x3f|0x001e) ncmd 1
>         Status: Command Disallowed (0x0c)
>         05                                               .
> > HCI Event: Command Complete (0x0e) plen 4                   #6 [hci0]
>       Reset (0x03|0x0003) ncmd 2
>         Status: Success (0x00)
>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> Signed-off-by: Jesse Melhuish <melhuishj@chromium.org>
> ---
>
>  net/bluetooth/hci_core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index c07b2d2a44b0..2b5df597e7ed 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1595,8 +1595,10 @@ static int hci_dev_do_open(struct hci_dev *hdev)
>             hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
>                 ret = hdev->set_diag(hdev, true);
>
> -       msft_do_open(hdev);
> -       aosp_do_open(hdev);
> +       if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> +               msft_do_open(hdev);
> +               aosp_do_open(hdev);
> +       }

This probably needs rebasing since we had moved this code to
hci_sync.c:hci_dev_open_sync.

>
>         clear_bit(HCI_INIT, &hdev->flags);
>
> --
> 2.31.0
>


-- 
Luiz Augusto von Dentz
