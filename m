Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE72EB170
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbhAERbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbhAERbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:31:16 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FECEC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 09:30:35 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id d9so86173iob.6
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 09:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FYIw4XaVrMnNYnuWT2V48WKkS1cbclhUSVDXgKQjqs=;
        b=bjUaVhdYDBkbZ4rY+848ML4GBtmcBk3jlB8S3QLdDUOna6RgRbIAu0JMlHo7TA8iaX
         8FVWhXv28jDqMQuX6Sxqc5rum4iGg4ZPJb34zbKwiVHLshjJ3yMDPj3prfsfO62pbn5I
         nL79taitxI+/DaKWE+iFXSBbIiR45e83C+crrvQeFVZJ/sWaa3fAWChC3W9Tr/j/MMpu
         GiKvHDQoZxyDrw0vKsxFFVOWUPjPz6T08Q4FZCIWgbZ1Is05zJZ317FpBLDXA7OCasBd
         dgkXaW/kdntmTahxITFOnyJJNQMBUUuvi9vyMly8/gpQhQRhREa9tAC4ik0PpUY2IAoZ
         Bz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FYIw4XaVrMnNYnuWT2V48WKkS1cbclhUSVDXgKQjqs=;
        b=oIFRoWUzFEpHCwc+1b1himbpPZFlsABI648M20FJ07gfJm2paPP4tQsmpTfDEkXjdD
         bYVQePxuLygWsVp7lUS7eSVyS2AxZK+IR4URC9nlmrovfdTMrxvgm6Hns96PIjGkENWK
         WA/EiW8G6Lfvt5fGBQLhMINE8RHUa17stVDRyDqn13xs4eVWIHH65MNDkxp4x2tZoufn
         5Od/EjVtcs03FkvmnQMbzyx8e7kKUNxgAh5hFTb49BlKMnmFMzXEM1E6f38qV6foytsp
         nP/NyIwCDvf8R1mYJip6192D94/azI+EoQ1FP3gPmUZwDTztX95pHICkH6vHaDN5op2R
         MioA==
X-Gm-Message-State: AOAM533xekhXuPkd3sUHcPKyV1p+zmUzpGeEFZtnWeqMN4cJjy96VoeR
        zO2EleZJqKNLdXMxfFK72K+WxyNhTYYGSdmbGEJAsOE5HURWHg==
X-Google-Smtp-Source: ABdhPJyFAA9+fVBi86iedke9b3ErQgLRWq+Y3Yv81VcBP63C0zOq7S7pJhWe7/oGEr98tzUYvEgID3IDgEYhxVZaGh8=
X-Received: by 2002:a5d:9a82:: with SMTP id c2mr179506iom.38.1609867834783;
 Tue, 05 Jan 2021 09:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20210105165749.16920-1-rohitm@chelsio.com>
In-Reply-To: <20210105165749.16920-1-rohitm@chelsio.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 5 Jan 2021 09:30:23 -0800
Message-ID: <CAKgT0UcP4noG_=puoi=zsfMi33RUSTMTL6RGLCPSR=nsVtXiag@mail.gmail.com>
Subject: Re: [net] cxgb4: advertise NETIF_F_HW_CSUM
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, secdev@chelsio.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 9:01 AM Rohit Maheshwari <rohitm@chelsio.com> wrote:
>
> advertise NETIF_F_HW_CSUM instead of protocol specific values of
> NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. This change is added long
> back in other drivers. This issue is seen recently when TLS offload
> made it mandatory to enable NETIF_F_HW_CSUM.
>
> Fixes: 2ed28baa7076 ("net: cxgb4{,vf}: convert to hw_features")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index 7fd264a6d085..f99f43570d41 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -6831,14 +6831,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 netdev->irq = pdev->irq;
>
>                 netdev->hw_features = NETIF_F_SG | TSO_FLAGS |
> -                       NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
> +                       NETIF_F_HW_CSUM |
>                         NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
>                         NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
>                         NETIF_F_HW_TC | NETIF_F_NTUPLE;
>
>                 if (chip_ver > CHELSIO_T5) {
> -                       netdev->hw_enc_features |= NETIF_F_IP_CSUM |
> -                                                  NETIF_F_IPV6_CSUM |
> +                       netdev->hw_enc_features |= NETIF_F_HW_CSUM |
>                                                    NETIF_F_RXCSUM |
>                                                    NETIF_F_GSO_UDP_TUNNEL |
>                                                    NETIF_F_GSO_UDP_TUNNEL_CSUM |

If you are going to enable the feature you should fully enable the
feature. My concern is the "nocsum:" label in hwcsum(). If you are
going to say you support the feature you should at least look at
dealing with the exception case and process a software checksum via
skb_checksum_help() rather than just not bothering and "hope a bad
packet is detected".

- Alex
