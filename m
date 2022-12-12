Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E125B64A9DA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiLLV4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLLV4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:56:51 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03361DF3;
        Mon, 12 Dec 2022 13:56:50 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id f20so1411890lja.4;
        Mon, 12 Dec 2022 13:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ONvWVsTXgcQGQxqYReYDCDgwMkH4rdX0rn2zZJpZl1o=;
        b=cCqZ6Id7gIwRoo6xdAl4DcHZMS4nxDoO2ogIdXTS2+JyiPd3lc+MWHvB9iMgBjcZWs
         +SndWPx6BUJg6IoKySiuj0up3S+uHAwpqzFc55zq1kgf5SFECypMUCWGFBcyhtHAeOYC
         ap/MAXiwZM195oxqwNL2Zt1tH8GBpH0tyirbwzY3QMgywmgWZ1T2Q5URozedoKmfuQki
         nJAh3yYFO4WMJjm+hlro7XbJsogUTNw05fiaP6BNmlmxd9La0X3bZPXir8A8e8SHSbgX
         0XXDiSwLqkcbSqqbynwF+7/R+fRKoe9BbKTchCNLz18gtL75eKRlukeF4Yeu3GO//o9L
         2j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONvWVsTXgcQGQxqYReYDCDgwMkH4rdX0rn2zZJpZl1o=;
        b=2QrmHwlq9IO93/ufevCDClH3f6s9311fb+gw+PG6ozazcoor5QkEONDHgyH2Agijxl
         k8M/4fV/L+DuXH3M74J3V9UgdqhHOGS9Kvaf6FGcEVFq2aoZrRToiwAlueXszYJnDcku
         rfKQ2fKTeWffZQU4JHlkLF3/QviycS9+/RclUHFrnP+65yud0g16TnL809HR9Q8smdTe
         srn+v2jVIv6NxsPEd1Dcr8yiRKoPkWVqtezSvTwQ1ejiHxq4MOwqGzDBxz7J3gwnKc1V
         XcDjkl11hRe2sbufKTyIC16O3Afpc+UXt2x6YvsOQ++pU7bLa6cw5UJmpOpeX8xiWY/f
         ABuQ==
X-Gm-Message-State: ANoB5plrAO5xkcKB+GjFIaI5adYbW61l0Zyu5NIp2xdnl8Do2EZb2427
        /axP65oK215Fs/Hus0XDBqg2XhFWCOPZmZLH1z0=
X-Google-Smtp-Source: AA0mqf5wMuw0NZFJ8wD4hdKEL46gYVw1QCQ0mk9/jt1JQMplAcQpPMzNdRDacTg3nAQPIDXgIAR5zHZVrHkIaMPDQQE=
X-Received: by 2002:a05:651c:c8b:b0:277:f8b:bb4f with SMTP id
 bz11-20020a05651c0c8b00b002770f8bbb4fmr27176266ljb.161.1670882207986; Mon, 12
 Dec 2022 13:56:47 -0800 (PST)
MIME-Version: 1.0
References: <20221210013456.1085082-1-luiz.dentz@gmail.com> <20221212123624.6c797838@kernel.org>
In-Reply-To: <20221212123624.6c797838@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 12 Dec 2022 13:56:36 -0800
Message-ID: <CABBYNZKnCoP1LBUeprS6MVxQBHZQafAT9hBNZQTBQjY+HHDjkg@mail.gmail.com>
Subject: Re: pull request: bluetooth-next 2022-12-09
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Dec 12, 2022 at 12:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  9 Dec 2022 17:34:56 -0800 Luiz Augusto von Dentz wrote:
> > bluetooth-next pull request for net-next:
> >
> >  - Add a new VID/PID 0489/e0f2 for MT7922
> >  - Add Realtek RTL8852BE support ID 0x0cb8:0xc559
> >  - Add a new PID/VID 13d3/3549 for RTL8822CU
> >  - Add support for broadcom BCM43430A0 & BCM43430A1
> >  - Add CONFIG_BT_HCIBTUSB_POLL_SYNC
> >  - Add CONFIG_BT_LE_L2CAP_ECRED
> >  - Add support for CYW4373A0
> >  - Add support for RTL8723DS
> >  - Add more device IDs for WCN6855
> >  - Add Broadcom BCM4377 family PCIe Bluetooth
>
> Hm, it's pulling in the commits we merged into net and which
> are already present in net-next but with a different hash/id.
>
> With a small overlap which git can't figure out:
>
> diff --cc drivers/bluetooth/btusb.c
> index f05018988a17,2ad4efdd9e40..24a8ed3f0458
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@@ -2052,17 -2206,17 +2206,22 @@@ static int btusb_setup_csr(struct hci_d
>                 bt_dev_err(hdev, "CSR: Local version length mismatch");
>                 kfree_skb(skb);
>                 return -EIO;
>         }
>
> -       rp = (struct hci_rp_read_local_version *)skb->data;
> +       bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x",
> +                   rp->hci_ver, le16_to_cpu(rp->hci_rev));
> +
> +       bt_dev_info(hdev, "LMP ver=%u subver=%04x; manufacturer=%u",
> +                   rp->lmp_ver, le16_to_cpu(rp->lmp_subver),
> +                   le16_to_cpu(rp->manufacturer));
>
>  +      bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
>  +              le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
>  +              le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
>  +              le16_to_cpu(rp->manufacturer));
>  +
>
> Could you rebase on top of net-next and resend so that the commits
> which are already applied disappear?

Sure, I will resend it shortly.

-- 
Luiz Augusto von Dentz
