Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E85313A73
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhBHRHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhBHRG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:06:57 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAB6C061788;
        Mon,  8 Feb 2021 09:06:16 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id q9so13452474ilo.1;
        Mon, 08 Feb 2021 09:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4jrETnSXtGQg1YS20D/UOJH1Djy0fDCxFsm14yPjjKM=;
        b=nncDQVkefkBVlpb7YoXElX7wYW1uS5LinPYmEMKugpJCR0D2+0exI6ogml2d5wIM9M
         wUy0OwKTwZ8Pxduvmheg/ZPWPc9kjPtunIa/+zCMzFxRfnSRRMWu2n4K14g+2qw43xmB
         89o9sYsB5twD3irxS8WXtySQBz6IlVzvBCX2JtY0gRp1wqEGw4Pb088ESUqR/bcL6y71
         MaCfkLbLB0PYYOgkSpikxp8oJxnEOjgKb96xUq60tLoWHd3BCzTT1+WG03MEH20/0XZ9
         xIL1k+loj4JhIDKLazNdlzZYWKbrDlzywsaGvuCtWLysWkojxHcwLPEPk0W01+TJrGup
         7f7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jrETnSXtGQg1YS20D/UOJH1Djy0fDCxFsm14yPjjKM=;
        b=TKlv4Rr02FaXQdW5hszQ3TVJxa+xVVqTATzPq8rgEHCdgMW9HjJLRStilVMTMN3PQq
         4oMU96JoBHPwfVM+eEdQLp7LRA3qX+9IZh2kHhNLa0DO4oeHFOhRSpGLQlMBaChi9m1R
         qkB+HhugKfBjfQePyQVsNvZNYyE0/sgE7LxOLa+gq5RF4Lghc+xuJrb1BDl26Eevx/e2
         qrd9EbIBVLlZAJI+8SB1Ks9Hp05vmCkhaouLZRdd0MPIy7Nr58vj4H1ShtH68tS99iP0
         VtQJ3fKPQ+6eDgEHg6cD5PVk2WY0XOyyVKHJFrspbmFrO3IxjUwPcIZLMGVXqRm291r0
         dbbQ==
X-Gm-Message-State: AOAM530R1tMIpcbvuEVqEV86JQiTcOkNEN79Rye5C+oK5z9zSillw2ft
        XCEymR1/538664itGP8BaL7SPMyiNvg72AAmbK4/ekgwb9I=
X-Google-Smtp-Source: ABdhPJz/Uk3jjNeqKZUOwLeCeyi3+pE05Bh4DgRPA9OhCpKRcFJF2L84l4R1tUn6af5tXHuIoz7/sAS8vf/OSw1ESVQ=
X-Received: by 2002:a05:6e02:2196:: with SMTP id j22mr16413103ila.64.1612803976188;
 Mon, 08 Feb 2021 09:06:16 -0800 (PST)
MIME-Version: 1.0
References: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com> <e3eed002-7a86-1336-4530-c1b6ab5261bd@gmail.com>
In-Reply-To: <e3eed002-7a86-1336-4530-c1b6ab5261bd@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 09:06:05 -0800
Message-ID: <CAKgT0Udc3e1fJG4wGWrQUj+YmO=ntR7-7snp7vVBfpO-GaCHvQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] cxgb4: remove unused vpd_cap_addr
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:29 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Supposedly this is a leftover from T3 driver heritage. cxgb4 uses the
> PCI core VPD access code that handles detection of VPD capabilities.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Instead of starting with the "Supposedly this is" it might be better
to word it along the lines of "This is likely". The "Supposedly" makes
it sound like you heard this as a rumor from somebody else.

Other than that nit about the description the change looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 1 -
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 --
>  2 files changed, 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
> index 8e681ce72..314f8d806 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
> @@ -414,7 +414,6 @@ struct pf_resources {
>  };
>
>  struct pci_params {
> -       unsigned int vpd_cap_addr;
>         unsigned char speed;
>         unsigned char width;
>  };
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index 9f1965c80..6264bc66a 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -3201,8 +3201,6 @@ static void cxgb4_mgmt_fill_vf_station_mac_addr(struct adapter *adap)
>         int err;
>         u8 *na;
>
> -       adap->params.pci.vpd_cap_addr = pci_find_capability(adap->pdev,
> -                                                           PCI_CAP_ID_VPD);
>         err = t4_get_raw_vpd_params(adap, &adap->params.vpd);
>         if (err)
>                 return;
> --
> 2.30.0
>
>
