Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8294A65CA
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbiBAUgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiBAUgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:36:54 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACC2C061714;
        Tue,  1 Feb 2022 12:36:54 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id m6so54537987ybc.9;
        Tue, 01 Feb 2022 12:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZxEgavNJow8Wx0FFzJL3BlfXa9k3Uaoz0LEpPT/Na8=;
        b=W9m3HNwIynnZZuxdZJrhkpLAffoabuD+cuHhvdadf1SwtuL77onC69MyYQy796bar0
         jU3Bv+9nxwMtNkVIr5bqLwFshq64m12LXIyrjgzeG3Zqa0QxnaUwHtOzYZkLmEpZNCzl
         0or7HwUhawHHRvrYnUf2GQrqe95a/XHnh1sApPrUAUIhVlayB7YTGxKPhoTbDvoS7OAZ
         M73YEVxYQ+KQlRZ2rUD5+vrSOfB4RUXDs9EMXi4poMoAPp3imExY+sNvD+jFlZLq62uq
         HaFbcGZ16HbzopdgYglvZXj6w9KBmFH7Q26IyNkXQD18/47o4ms1p7tCFtxmcCuPv5VZ
         z9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZxEgavNJow8Wx0FFzJL3BlfXa9k3Uaoz0LEpPT/Na8=;
        b=leT28kk34LRBLV0UyVvYw04CWKtOL2jnikPPE09DdJl36K/RHzZQO1dM4ZEBAnU2QZ
         RyUJdYER7GAZE1RFv3Q4ztl1r+HKRdVm1Vyk57Yev23ZRWP6qSA0TQhgtKpX0eDWrf2I
         eS+0Wpbw1a8Bh2a4Y/ju7Cg+FIWv8WW4mUnJrAXfgGwUvN6T/ZrE3DlvNy9nBXLRbTMC
         FzwWrM9T18SaeMPnvknLKVen8cu4GMKsYARWU8qVYmga99GmZG6x2Rcl7o3B5GiuZf+P
         BbG8Bm35/vxLNp42NdTN/F9Lqf4d9t3XApI2NKZtdxfdaHdA7R9hbLpXec2vVqn1waml
         rM6g==
X-Gm-Message-State: AOAM531lNqJBZJU2g6Hmdn8y9hxJIKMhrU9gdfTbdacRMCY5J7VSm9/o
        N3VsY3ji0aHnptXyHn8MQg1YqX5RuIBqIcr/dq8=
X-Google-Smtp-Source: ABdhPJwpJcz7TCycL5dQTokUujprw8bBkzQUm61YUsFx7YYCZYK3oX3Sr+XLfQO/W39IuT6ugFxe7azVa8JS0WET0LE=
X-Received: by 2002:a05:6902:725:: with SMTP id l5mr38545588ybt.351.1643747813529;
 Tue, 01 Feb 2022 12:36:53 -0800 (PST)
MIME-Version: 1.0
References: <20220118075033.925388-1-chi.minghao@zte.com.cn> <91565226-5134-45FC-A68F-0E98854227AC@holtmann.org>
In-Reply-To: <91565226-5134-45FC-A68F-0E98854227AC@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 1 Feb 2022 12:36:43 -0800
Message-ID: <CABBYNZJh4yx+VAhU+KpeTid+4Reojp2OfDRQYjKXsoPmnKeZLg@mail.gmail.com>
Subject: Re: [PATCH] net/bluetooth: remove unneeded err variable
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     cgel.zte@gmail.com, Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jan 19, 2022 at 11:34 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Minghao,
>
> > Return value from mgmt_cmd_complete() directly instead
> > of taking this in another redundant variable.
>
> the Bluetooth subsystem uses Bluetooth: as subject prefix.
>
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> > Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> > ---
> > net/bluetooth/mgmt.c | 5 +----
> > 1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > index 37087cf7dc5a..d0804648da32 100644
> > --- a/net/bluetooth/mgmt.c
> > +++ b/net/bluetooth/mgmt.c
> > @@ -8601,7 +8601,6 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
> >       struct mgmt_cp_get_adv_size_info *cp = data;
> >       struct mgmt_rp_get_adv_size_info rp;
> >       u32 flags, supported_flags;
> > -     int err;
> >
> >       bt_dev_dbg(hdev, "sock %p", sk);
> >
> > @@ -8628,10 +8627,8 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
> >       rp.max_adv_data_len = tlv_data_max_len(hdev, flags, true);
> >       rp.max_scan_rsp_len = tlv_data_max_len(hdev, flags, false);
> >
> > -     err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
> > +     return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
> >                               MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
> > -
> > -     return err;
> > }
>
> You also have a coding style error here in your indentation.
>
> Regards
>
> Marcel

Applied, after fixing the coding style and commit message, thanks.

-- 
Luiz Augusto von Dentz
