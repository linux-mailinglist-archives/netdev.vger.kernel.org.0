Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E153513DD4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352394AbiD1VvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiD1VvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:51:16 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60680BB0A7
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651182467;
        bh=MFzx+iTQ1YFM9KV5h6tH8q0bl9eJIeLqcOHeAa6/TDU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=G9e2wJ9UlF3jtXQ5hZAiQzm1OJ3lusnfsP45NipzZKU9usKdLU2Oe7WlPDpFnfTKV
         fImJYUuMtXUEYqxpQwyAREk/JZO1eJlcJVEtWFW8WWoOL5og+MXcnnD8qpkEFPFrdq
         Lg5wP9WFmOH59lXU4TbhyDbPvlYbGR5r/oQkBhro=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [46.223.3.70] ([46.223.3.70]) by web-mail.gmx.net
 (3c-app-gmx-bap57.server.lan [172.19.172.127]) (via HTTP); Thu, 28 Apr 2022
 23:47:47 +0200
MIME-Version: 1.0
Message-ID: <trinity-b3b6d48a-1d62-4280-b52e-5511074f79c9-1651182467378@3c-app-gmx-bap57>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Aw: [PATCH net-next v2 07/15] slic: remove a copy of the
 NAPI_POLL_WEIGHT define
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 28 Apr 2022 23:47:47 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20220428212323.104417-8-kuba@kernel.org>
References: <20220428212323.104417-1-kuba@kernel.org>
 <20220428212323.104417-8-kuba@kernel.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:NHZGPhQ00Ly7ycLcyU/K3HMfUvPZvr9EOsgl828APJl/eIav41f0ySReb8esR4b/M+3f3
 5K2a7bOAkUgqf//6FDuVED7kn5Gk3IsZgNB7KOl9DxXFgLsZjqr97igk37ld9EgjgUOgDBWnV2oh
 FuXd5Z1OITunnTZiHkTFES2Hy0nGNAlOq/eaymLzaq9NLZdAmdprFpYWiTLT6zp85qbj/CXLZvbk
 QYoit3PlXVaf9R1fdURL6fNpq61FsDuvPEorljekkvOPTKWHvab+vRUTOG43KOORkEaA12xa03Bw
 gU=
X-UI-Out-Filterresults: notjunk:1;V03:K0:g5fp/3B5bRo=:s1sZVO1qUxvaicOEmzbX5S
 rkUgJyPWQdlQYYeQtf1Q8xtVt32jQryN4MvwhoWiQyNvBXqCzp9hvGbMyLX7dCRPdvyC1tA1K
 KWvmX0WvAfrjtzc9jN08jL9mw+5/SpB4DE1l/FdzBpaMKRjDxdG80k44aA20ePfn8yf+/pN7O
 ZQMi6Rj+D9ru4MGUyCSXyF2k5QVzKTYZoDLvgvhdGIprQr7GyaX/YVzkWTe09CuYLp9G1V4uO
 tgzKbGp6SEN4hGlQZqLKs1L/bbt6OEXB3QkVFnK7Kq0xJ4uaOouic5Et/eg6Yz2IECrPy05fT
 iz+rARbqXoa1mO7yw+6GZqiNYUXRH43FAuUfofOtNECaoEcyZRD5U89/LEijA7EtCcUfCto7G
 I13Qd1M/JD5zHPntDvaz2rao2VGMjI0Sx5og0qmqQlmgcOzZ16m6rzgFQujCorRCZPhHBhfRx
 7YfAMGSsE3pF3lffJjjjHdcO3mNhgnQcQJU9Mjtvwof7SEGonpogU7/XBfTPR9z0BMcZ/5Tqq
 WN2rdNNPp/z0KlItIOu3ks+YmBC0ckOlE8gxzR3vUdRZyPqSG9Te44vPYCwlvBWP9rfjf9D+G
 vq48BL3YF9arYjtpMEqfrOkxoX1h6frCkhGTAwH2mFjY2ThZe4eT138TuzRiOCHt4e42K+PXc
 DG7aAIqainTo9BRfOepqEE1lBgJYFhNG1WsjehNuEuthIDStxg4PQcEG+N0xS1bguD+CVqEXW
 xkkbWEVXBF8dZZXsiQg1TYovmoKUZuGMk+yoYwy3P0gjEP4yp9I2P7Fjn42+aVr/nS7i8zHQ8
 qDGYkcB
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Gesendet: Donnerstag, 28. April 2022 um 23:23 Uhr
> Von: "Jakub Kicinski" <kuba@kernel.org>
> An: davem@davemloft.net, pabeni@redhat.com
> Cc: edumazet@google.com, netdev@vger.kernel.org, "Jakub Kicinski" <kuba@=
kernel.org>, LinoSanfilippo@gmx.de
> Betreff: [PATCH net-next v2 07/15] slic: remove a copy of the NAPI_POLL_=
WEIGHT define
>
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
>

Agreed, FWIW:
Acked-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>


> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: LinoSanfilippo@gmx.de
> ---
>  drivers/net/ethernet/alacritech/slic.h    | 2 --
>  drivers/net/ethernet/alacritech/slicoss.c | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/alacritech/slic.h b/drivers/net/ethern=
et/alacritech/slic.h
> index 3add305d34b4..4eecbdfff3ff 100644
> --- a/drivers/net/ethernet/alacritech/slic.h
> +++ b/drivers/net/ethernet/alacritech/slic.h
> @@ -265,8 +265,6 @@
>  #define SLIC_NUM_STAT_DESC_ARRAYS	4
>  #define SLIC_INVALID_STAT_DESC_IDX	0xffffffff
>
> -#define SLIC_NAPI_WEIGHT		64
> -
>  #define SLIC_UPR_LSTAT			0
>  #define SLIC_UPR_CONFIG			1
>
> diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/eth=
ernet/alacritech/slicoss.c
> index 1fc9a1cd3ef8..ce353b0c02a3 100644
> --- a/drivers/net/ethernet/alacritech/slicoss.c
> +++ b/drivers/net/ethernet/alacritech/slicoss.c
> @@ -1803,7 +1803,7 @@ static int slic_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
>  		goto unmap;
>  	}
>
> -	netif_napi_add(dev, &sdev->napi, slic_poll, SLIC_NAPI_WEIGHT);
> +	netif_napi_add(dev, &sdev->napi, slic_poll, NAPI_POLL_WEIGHT);
>  	netif_carrier_off(dev);
>
>  	err =3D register_netdev(dev);
> --
> 2.34.1

Best regards,
Lino
