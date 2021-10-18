Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E46432642
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhJRSYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhJRSYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:24:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEC2C06161C;
        Mon, 18 Oct 2021 11:22:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso636432pjw.2;
        Mon, 18 Oct 2021 11:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=O3JTsJ//+aRHmKyBmq+YMFG4wtH7aD4MaEaRfkM2pfA=;
        b=QjqcxT3HbF+90hPV9T7yihmLJb87KM6gkBPtXzTS7ttTlpzzTqGJ1S5IBUI/MQqY8D
         X1zIxgbhagtvTqcQXAeN4tNyUWpcN/vqs0VdzAVq/NZKPkonH/3jcVaAZBDwZW1svz02
         Jo35NqFLw06rWP469JtVUZtYmULUjxrx0G9uo4NebStJQF7MYO3VZbMUzQeEY8fz2Nh1
         eXZYh70GC58YAOO/Ua+TZqupDBPFnpcNODN7tGX0byFImrYZpXt99sN3f9DJHamxX6qQ
         yjO47dzVI0HHPDW3ZGR6sf6Yrf8EKFs2N0CHfUa5PxT5CjYLWJak+h5BQu+o3mGAhNT8
         Mplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=O3JTsJ//+aRHmKyBmq+YMFG4wtH7aD4MaEaRfkM2pfA=;
        b=1J5gt+2VIpOhPfOS/nGNnmDZjJi3UxCkewm6VslEF99A3mTggXduPIalV8+ideCwQT
         EhUclFR6piWD9dUeey9L8jh4uVieDEJUTAPsZLa/AjqnUz8iYzb5dgsfThWvJozuF5HA
         cpHGU+lOhsMG1NXwDx8Mbp5Ml81kj3aK/CcHUf3u5gF5bQ3VUH/n8zSN/pCV3V4S2/zA
         /+ilpxz/EHEBCjUfPY2AQqv2LKXOSF3jVbVuHgzBFwcXxFw9rGzsWbsYHoIqBPgDll2x
         76nuiQKQ7M84QYee+CZKAZgE20jLyNY/442+vhC7dZ0+wmO3UgAUjhMihglUKA5npS46
         Hqnw==
X-Gm-Message-State: AOAM533AzXxdNr6mEtC/9462XktWuvAxOf37JnIf9fmJELOepq33hfHf
        qMlTN49aOGJV1LNKdqcc1XOZvWJUe4Gvjb61
X-Google-Smtp-Source: ABdhPJz/pqHLPI6TAN0ZTeY47crCygjKDltqRe8CtbzoQNMBQDb+r5AGhA1R8XoOzYofwE2BbebpXA==
X-Received: by 2002:a17:90a:a609:: with SMTP id c9mr592265pjq.134.1634581343846;
        Mon, 18 Oct 2021 11:22:23 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id c12sm13694481pfc.161.2021.10.18.11.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:22:23 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 12/17] net: ipa: Add support for IPA v2.x memory map
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Date:   Mon, 18 Oct 2021 23:49:27 +0530
Message-Id: <CF2QNY03DL92.2L28UE4T4GU9H@skynet-linux>
In-Reply-To: <566b43c9-2893-09ac-1f27-513f0a6d767e@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 4:00 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > IPA v2.6L has an extra region to handle compression/decompression
> > acceleration. This region is used by some modems during modem init.
>
> So it has to be initialized? (I guess so.)

This is how downstream handles it, I haven't tested not initializing it.

>
> The memory size register apparently doesn't express things in
> units of 8 bytes either.
>

Indeed, with the hardware being 32 bits, it expresses things in values
of 4 bytes instead.

Regards,
Sireesh
> -Alex
>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >   drivers/net/ipa/ipa_mem.c | 36 ++++++++++++++++++++++++++++++------
> >   drivers/net/ipa/ipa_mem.h |  5 ++++-
> >   2 files changed, 34 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
> > index 8acc88070a6f..bfcdc7e08de2 100644
> > --- a/drivers/net/ipa/ipa_mem.c
> > +++ b/drivers/net/ipa/ipa_mem.c
> > @@ -84,7 +84,7 @@ int ipa_mem_setup(struct ipa *ipa)
> >   	/* Get a transaction to define the header memory region and to zero
> >   	 * the processing context and modem memory regions.
> >   	 */
> > -	trans =3D ipa_cmd_trans_alloc(ipa, 4);
> > +	trans =3D ipa_cmd_trans_alloc(ipa, 5);
> >   	if (!trans) {
> >   		dev_err(&ipa->pdev->dev, "no transaction for memory setup\n");
> >   		return -EBUSY;
> > @@ -107,8 +107,14 @@ int ipa_mem_setup(struct ipa *ipa)
> >   	ipa_mem_zero_region_add(trans, IPA_MEM_AP_PROC_CTX);
> >   	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM);
> >  =20
> > +	ipa_mem_zero_region_add(trans, IPA_MEM_ZIP);
> > +
> >   	ipa_trans_commit_wait(trans);
> >  =20
> > +	/* On IPA version <=3D2.6L (except 2.5) there is no PROC_CTX.  */
> > +	if (ipa->version !=3D IPA_VERSION_2_5 && ipa->version <=3D IPA_VERSIO=
N_2_6L)
> > +		return 0;
> > +
> >   	/* Tell the hardware where the processing context area is located */
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
> >   	offset =3D ipa->mem_offset + mem->offset;
> > @@ -147,6 +153,11 @@ static bool ipa_mem_id_valid(struct ipa *ipa, enum=
 ipa_mem_id mem_id)
> >   	case IPA_MEM_END_MARKER:	/* pseudo region */
> >   		break;
> >  =20
> > +	case IPA_MEM_ZIP:
> > +		if (version =3D=3D IPA_VERSION_2_6L)
> > +			return true;
> > +		break;
> > +
> >   	case IPA_MEM_STATS_TETHERING:
> >   	case IPA_MEM_STATS_DROP:
> >   		if (version < IPA_VERSION_4_0)
> > @@ -319,10 +330,15 @@ int ipa_mem_config(struct ipa *ipa)
> >   	/* Check the advertised location and size of the shared memory area =
*/
> >   	val =3D ioread32(ipa->reg_virt + ipa_reg_shared_mem_size_offset(ipa-=
>version));
> >  =20
> > -	/* The fields in the register are in 8 byte units */
> > -	ipa->mem_offset =3D 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
> > -	/* Make sure the end is within the region's mapped space */
> > -	mem_size =3D 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
> > +	if (IPA_VERSION_RANGE(ipa->version, 2_0, 2_6L)) {
> > +		/* The fields in the register are in 8 byte units */
> > +		ipa->mem_offset =3D 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
> > +		/* Make sure the end is within the region's mapped space */
> > +		mem_size =3D 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
> > +	} else {
> > +		ipa->mem_offset =3D u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
> > +		mem_size =3D u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
> > +	}
> >  =20
> >   	/* If the sizes don't match, issue a warning */
> >   	if (ipa->mem_offset + mem_size < ipa->mem_size) {
> > @@ -564,6 +580,10 @@ static int ipa_smem_init(struct ipa *ipa, u32 item=
, size_t size)
> >   		return -EINVAL;
> >   	}
> >  =20
> > +	/* IPA v2.6L does not use IOMMU */
> > +	if (ipa->version <=3D IPA_VERSION_2_6L)
> > +		return 0;
> > +
> >   	domain =3D iommu_get_domain_for_dev(dev);
> >   	if (!domain) {
> >   		dev_err(dev, "no IOMMU domain found for SMEM\n");
> > @@ -591,6 +611,9 @@ static void ipa_smem_exit(struct ipa *ipa)
> >   	struct device *dev =3D &ipa->pdev->dev;
> >   	struct iommu_domain *domain;
> >  =20
> > +	if (ipa->version <=3D IPA_VERSION_2_6L)
> > +		return;
> > +
> >   	domain =3D iommu_get_domain_for_dev(dev);
> >   	if (domain) {
> >   		size_t size;
> > @@ -622,7 +645,8 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_=
mem_data *mem_data)
> >   	ipa->mem_count =3D mem_data->local_count;
> >   	ipa->mem =3D mem_data->local;
> >  =20
> > -	ret =3D dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
> > +	ret =3D dma_set_mask_and_coherent(&ipa->pdev->dev, IPA_IS_64BIT(ipa->=
version) ?
> > +					DMA_BIT_MASK(64) : DMA_BIT_MASK(32));
> >   	if (ret) {
> >   		dev_err(dev, "error %d setting DMA mask\n", ret);
> >   		return ret;
> > diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
> > index 570bfdd99bff..be91cb38b6a8 100644
> > --- a/drivers/net/ipa/ipa_mem.h
> > +++ b/drivers/net/ipa/ipa_mem.h
> > @@ -47,8 +47,10 @@ enum ipa_mem_id {
> >   	IPA_MEM_UC_INFO,		/* 0 canaries */
> >   	IPA_MEM_V4_FILTER_HASHED,	/* 2 canaries */
> >   	IPA_MEM_V4_FILTER,		/* 2 canaries */
> > +	IPA_MEM_V4_FILTER_AP,		/* 2 canaries (IPA v2.0) */
> >   	IPA_MEM_V6_FILTER_HASHED,	/* 2 canaries */
> >   	IPA_MEM_V6_FILTER,		/* 2 canaries */
> > +	IPA_MEM_V6_FILTER_AP,		/* 0 canaries (IPA v2.0) */
> >   	IPA_MEM_V4_ROUTE_HASHED,	/* 2 canaries */
> >   	IPA_MEM_V4_ROUTE,		/* 2 canaries */
> >   	IPA_MEM_V6_ROUTE_HASHED,	/* 2 canaries */
> > @@ -57,7 +59,8 @@ enum ipa_mem_id {
> >   	IPA_MEM_AP_HEADER,		/* 0 canaries, optional */
> >   	IPA_MEM_MODEM_PROC_CTX,		/* 2 canaries */
> >   	IPA_MEM_AP_PROC_CTX,		/* 0 canaries */
> > -	IPA_MEM_MODEM,			/* 0/2 canaries */
> > +	IPA_MEM_ZIP,			/* 1 canary (IPA v2.6L) */
> > +	IPA_MEM_MODEM,			/* 0-2 canaries */
> >   	IPA_MEM_UC_EVENT_RING,		/* 1 canary, optional */
> >   	IPA_MEM_PDN_CONFIG,		/* 0/2 canaries (IPA v4.0+) */
> >   	IPA_MEM_STATS_QUOTA_MODEM,	/* 2/4 canaries (IPA v4.0+) */
> >=20

