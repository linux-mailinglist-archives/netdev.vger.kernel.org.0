Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4344263200
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbgIIQdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731052AbgIIQcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:32:39 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032C4C06134B
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 06:56:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x23so2370300wmi.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 06:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zLNjrf+RPSwU1achccfvQ6mA3Vt8oX8oHZ1Kj6a2hGk=;
        b=usexzns/FdygjeeyD2H7JASXGevgz8/+lKR+qdtsI192xsGYNdFvZgHJ/PKpcExCik
         xIIauuaYdSnaT8/O47RLMXqHOXyxod/RlGP5LYh5aC4lcx3udWZOSt0cpu001jTOSHYn
         g/ZHFKsxFHk9Cx+VesNHspeu3vNqgK+oeqWjkJalLFHaQFjQmLyloimQ9pvW8rf0SJ5G
         tCT3VC9A4Oj90pL1q8Qz3qZrWC8Tfee3teWzs72M8ovMo2/bouCqlrVhc19yTN4FJcjn
         b9RBCUCMyyughrDnElSyHPBIV9Osn2+mxwXWozbTlWAa1slI2qJSMQB+/OBmgmU4d8+Q
         7eQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zLNjrf+RPSwU1achccfvQ6mA3Vt8oX8oHZ1Kj6a2hGk=;
        b=IihfYWcAR9ST/MHVqmOaRtGx2DkgNrhss7AeuoszoCVfG+aYTrggUD7Qm7lzhGbmZr
         R4Kg00g3/cFDBObcAN88AAHBJxboaMkhenr5M9JaY3ZeSuRCiRGDwXvI2zujsvcbagK1
         YJyMOpbcUxMXqFLSM6BXaSAj2VU2cfQC13wlZrxpq4LkrRXVLajMy+ZZhW5Aajj7GWC9
         8muGO4zUQs3NJHDjKEGzeTFhkakyrBNRhXN0Ttv0uCiybnFI1KhsJ+4mdDmhBsReyvAh
         WlQf+ez/cAaKvNvwvBsIh3bzTHEYx9bwwbkKE6bWxHN6Qeeq2+2LnWaKYdEFQ1tqGOmV
         V/Yg==
X-Gm-Message-State: AOAM533L93zA4qGhVzpoSFe9y8ZnYjJ39aazZdGbMkkhDqK086fKBOVN
        F1ZL/z12kolACP0q0tz6N5vNJaVoOSEFHUEyi7o=
X-Google-Smtp-Source: ABdhPJzGzvvUUCMWwLzes7DVwhtv0V5dcoTY8yggjcHhhYxt9rhX0EcFoZnLr3Ldx9+/ykRGBGbFh8wwxAZk0dKRATw=
X-Received: by 2002:a7b:c4d3:: with SMTP id g19mr3826168wmk.165.1599659778699;
 Wed, 09 Sep 2020 06:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200908123440.11278-1-marekx.majtyka@intel.com>
In-Reply-To: <20200908123440.11278-1-marekx.majtyka@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 9 Sep 2020 15:56:07 +0200
Message-ID: <CAJ+HfNgysVCeBhkq+joCkMVrwnaOLaWZeo+fSo-S7w9U_ozNdQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next] i40e: remove redundant assigment
To:     Marek Majtyka <alardam@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Marek Majtyka <marekx.majtyka@intel.com>,
        maciejromanfijalkowski@gmain.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 at 15:53, Marek Majtyka <alardam@gmail.com> wrote:
>
> Remove a redundant assigment of the software ring pointer in the i40e
> driver. The variable is assigned twice with no use in between, so just
> get rid of the first occurrence.
>
> Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
> Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>

Nice!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Hmm, this could actually go to the net tree.


Bj=C3=B6rn

> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index 2a1153d8957b..8661f461f620 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -306,7 +306,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, i=
nt budget)
>                         continue;
>                 }
>
> -               bi =3D i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
>                 size =3D (qword & I40E_RXD_QW1_LENGTH_PBUF_MASK) >>
>                        I40E_RXD_QW1_LENGTH_PBUF_SHIFT;
>                 if (!size)
> --
> 2.20.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
