Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFB94323B7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhJRQYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhJRQYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:24:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA5EC06161C;
        Mon, 18 Oct 2021 09:22:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so355856pjb.5;
        Mon, 18 Oct 2021 09:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:from:to:cc:subject:date
         :message-id:in-reply-to;
        bh=hQ7oJwWBHI9sePRbXX111ZS7PJgfs/mMN4nixRjFXlI=;
        b=VT0qx4Czq6wvk366O6lmcP5Qun5PhKwuHK4bbFoSsBA1mqTcA4LppdImcug25oPUQz
         x7FEfdv26sDw9yOgV77N2DQwKjCJGxTdXYETm3qZbmvbcfI6Z89gWRJCbv5dflePCg3Z
         q0xyaJ2loGwu4r/Sy8L+jYaSkV/nPUJzMNhRBmFoBRJiy1EkeHWnEIIm46at7F5diuVg
         vfS/3tXRIFLiU7T9GekLwhQvzK1Xt/0YYjxM9JFWx69OhGynRUHYw7UcgRw4OY7ZT4Rf
         2rzY2yVKDiDEP67b+WNnoN99hnjouaPFSdhRThOZTTILe/0VNDJ7iEq0mPFdxIHhFWwr
         TCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:from:to
         :cc:subject:date:message-id:in-reply-to;
        bh=hQ7oJwWBHI9sePRbXX111ZS7PJgfs/mMN4nixRjFXlI=;
        b=A2TyzpcMjJkoUxQMRA9jCdRj6LXwWG+VFBM1AK/lOorfG6oXR0sWw2N88M6l83MTqD
         jh8erobauav5O3RtcS7nPicrNa+t3e4gsZBYMFw465Z9cVMhpdh50fodJX5wh2R4IcvA
         nyj3IHLHXuD3KpG+cmhyoMltrlD+77P6NJkyCNE7GGaUh78q2DJZ9a5ndVr4hHS/PEJf
         E4U7sZI6Rfgah2bW/aJLk0Gou4U5m0msc5wPDQywooocEKShmCGURTUeDpT4srw6PNRW
         OjTNciICsjI9FaNyVMr1WUdYdY5dVf7yQ7nWrdUUsht+IC2mHSN0lWOzTdCooM/c0fM2
         tx2w==
X-Gm-Message-State: AOAM530AS6ynUBkFP9NHlHvZJxRd5AGo7o3Aud2Bq6jEJQ0k5maRFDpO
        3itP+XTtl54PQvmXsTDHNYg=
X-Google-Smtp-Source: ABdhPJxXPLUYo1Pt9uC9DZ/Sks2OJnJeEu6yFQhX0y0OESWiv7aYBjgW9qN/HoHICucYXs1RADRfeQ==
X-Received: by 2002:a17:902:b18b:b0:13a:354a:3e9d with SMTP id s11-20020a170902b18b00b0013a354a3e9dmr28252982plr.36.1634574138922;
        Mon, 18 Oct 2021 09:22:18 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id y8sm13487968pfe.217.2021.10.18.09.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 09:22:18 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Cc:     "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 02/17] net: ipa: revert to IPA_TABLE_ENTRY_SIZE for
 32-bit IPA support
Date:   Mon, 18 Oct 2021 21:46:45 +0530
Message-Id: <CF2O1ZMOGK98.RQ3P9X0BFKNH@skynet-linux>
In-Reply-To: <3d0d6d98-201f-496f-a479-9aeaf8b2e837@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 3:58 AM IST, Alex Elder wrote:
> On 9/19/21 10:07 PM, Sireesh Kodali wrote:
> > From: Vladimir Lypak <vladimir.lypak@gmail.com>
> >=20
> > IPA v2.x is 32 bit. Having an IPA_TABLE_ENTRY size makes it easier to
> > deal with supporting both 32 bit and 64 bit IPA versions
>
> This looks reasonable. At this point filter/route tables aren't
> really used, so this is a simple fix. You use IPA_IS_64BIT()
> here, but it isn't defined until patch 7, which I expect is a
> build problem.

Oof, I probably messed this up while re-ordering the commits... will fix

Regards,
Sireesh
>
> -Alex
>
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >   drivers/net/ipa/ipa_qmi.c   | 10 ++++++----
> >   drivers/net/ipa/ipa_table.c | 29 +++++++++++++----------------
> >   drivers/net/ipa/ipa_table.h |  4 ++++
> >   3 files changed, 23 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
> > index 90f3aec55b36..7e2fe701cc4d 100644
> > --- a/drivers/net/ipa/ipa_qmi.c
> > +++ b/drivers/net/ipa/ipa_qmi.c
> > @@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
> >   	req.v4_route_tbl_info_valid =3D 1;
> >   	req.v4_route_tbl_info.start =3D ipa->mem_offset + mem->offset;
> > -	req.v4_route_tbl_info.count =3D mem->size / sizeof(__le64);
> > +	req.v4_route_tbl_info.count =3D mem->size / IPA_TABLE_ENTRY_SIZE(ipa-=
>version);
> >  =20
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
> >   	req.v6_route_tbl_info_valid =3D 1;
> >   	req.v6_route_tbl_info.start =3D ipa->mem_offset + mem->offset;
> > -	req.v6_route_tbl_info.count =3D mem->size / sizeof(__le64);
> > +	req.v6_route_tbl_info.count =3D mem->size / IPA_TABLE_ENTRY_SIZE(ipa-=
>version);
> >  =20
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
> >   	req.v4_filter_tbl_start_valid =3D 1;
> > @@ -352,7 +352,8 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
> >   		req.v4_hash_route_tbl_info_valid =3D 1;
> >   		req.v4_hash_route_tbl_info.start =3D
> >   				ipa->mem_offset + mem->offset;
> > -		req.v4_hash_route_tbl_info.count =3D mem->size / sizeof(__le64);
> > +		req.v4_hash_route_tbl_info.count =3D
> > +				mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
> >   	}
> >  =20
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
> > @@ -360,7 +361,8 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
> >   		req.v6_hash_route_tbl_info_valid =3D 1;
> >   		req.v6_hash_route_tbl_info.start =3D
> >   			ipa->mem_offset + mem->offset;
> > -		req.v6_hash_route_tbl_info.count =3D mem->size / sizeof(__le64);
> > +		req.v6_hash_route_tbl_info.count =3D
> > +				mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
> >   	}
> >  =20
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
> > diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> > index 1da334f54944..96c467c80a2e 100644
> > --- a/drivers/net/ipa/ipa_table.c
> > +++ b/drivers/net/ipa/ipa_table.c
> > @@ -118,7 +118,8 @@
> >    * 32-bit all-zero rule list terminator.  The "zero rule" is simply a=
n
> >    * all-zero rule followed by the list terminator.
> >    */
> > -#define IPA_ZERO_RULE_SIZE		(2 * sizeof(__le32))
> > +#define IPA_ZERO_RULE_SIZE(version) \
> > +	 (IPA_IS_64BIT(version) ? 2 * sizeof(__le32) : sizeof(__le32))
> >  =20
> >   /* Check things that can be validated at build time. */
> >   static void ipa_table_validate_build(void)
> > @@ -132,12 +133,6 @@ static void ipa_table_validate_build(void)
> >   	 */
> >   	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(__le64));
> >  =20
> > -	/* A "zero rule" is used to represent no filtering or no routing.
> > -	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
> > -	 * assumes that it can be written using a pointer to __le64.
> > -	 */
> > -	BUILD_BUG_ON(IPA_ZERO_RULE_SIZE !=3D sizeof(__le64));
> > -
> >   	/* Impose a practical limit on the number of routes */
> >   	BUILD_BUG_ON(IPA_ROUTE_COUNT_MAX > 32);
> >   	/* The modem must be allotted at least one route table entry */
> > @@ -236,7 +231,7 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, b=
ool filter_mask, u16 count)
> >   	/* Skip over the zero rule and possibly the filter mask */
> >   	skip =3D filter_mask ? 1 : 2;
> >  =20
> > -	return ipa->table_addr + skip * sizeof(*ipa->table_virt);
> > +	return ipa->table_addr + skip * IPA_TABLE_ENTRY_SIZE(ipa->version);
> >   }
> >  =20
> >   static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
> > @@ -255,8 +250,8 @@ static void ipa_table_reset_add(struct gsi_trans *t=
rans, bool filter,
> >   	if (filter)
> >   		first++;	/* skip over bitmap */
> >  =20
> > -	offset =3D mem->offset + first * sizeof(__le64);
> > -	size =3D count * sizeof(__le64);
> > +	offset =3D mem->offset + first * IPA_TABLE_ENTRY_SIZE(ipa->version);
> > +	size =3D count * IPA_TABLE_ENTRY_SIZE(ipa->version);
> >   	addr =3D ipa_table_addr(ipa, false, count);
> >  =20
> >   	ipa_cmd_dma_shared_mem_add(trans, offset, size, addr, true);
> > @@ -434,11 +429,11 @@ static void ipa_table_init_add(struct gsi_trans *=
trans, bool filter,
> >   		count =3D 1 + hweight32(ipa->filter_map);
> >   		hash_count =3D hash_mem->size ? count : 0;
> >   	} else {
> > -		count =3D mem->size / sizeof(__le64);
> > -		hash_count =3D hash_mem->size / sizeof(__le64);
> > +		count =3D mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
> > +		hash_count =3D hash_mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
> >   	}
> > -	size =3D count * sizeof(__le64);
> > -	hash_size =3D hash_count * sizeof(__le64);
> > +	size =3D count * IPA_TABLE_ENTRY_SIZE(ipa->version);
> > +	hash_size =3D hash_count * IPA_TABLE_ENTRY_SIZE(ipa->version);
> >  =20
> >   	addr =3D ipa_table_addr(ipa, filter, count);
> >   	hash_addr =3D ipa_table_addr(ipa, filter, hash_count);
> > @@ -621,7 +616,8 @@ int ipa_table_init(struct ipa *ipa)
> >   	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
> >   	 * of pages, which satisfies the rule alignment requirement.
> >   	 */
> > -	size =3D IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
> > +	size =3D IPA_ZERO_RULE_SIZE(ipa->version) +
> > +	       (1 + count) * IPA_TABLE_ENTRY_SIZE(ipa->version);
> >   	virt =3D dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
> >   	if (!virt)
> >   		return -ENOMEM;
> > @@ -653,7 +649,8 @@ void ipa_table_exit(struct ipa *ipa)
> >   	struct device *dev =3D &ipa->pdev->dev;
> >   	size_t size;
> >  =20
> > -	size =3D IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
> > +	size =3D IPA_ZERO_RULE_SIZE(ipa->version) +
> > +	       (1 + count) * IPA_TABLE_ENTRY_SIZE(ipa->version);
> >  =20
> >   	dma_free_coherent(dev, size, ipa->table_virt, ipa->table_addr);
> >   	ipa->table_addr =3D 0;
> > diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
> > index b6a9a0d79d68..78a168ce6558 100644
> > --- a/drivers/net/ipa/ipa_table.h
> > +++ b/drivers/net/ipa/ipa_table.h
> > @@ -10,6 +10,10 @@
> >  =20
> >   struct ipa;
> >  =20
> > +/* The size of a filter or route table entry */
> > +#define IPA_TABLE_ENTRY_SIZE(version)	\
> > +	(IPA_IS_64BIT(version) ? sizeof(__le64) : sizeof(__le32))
> > +
> >   /* The maximum number of filter table entries (IPv4, IPv6; hashed or =
not) */
> >   #define IPA_FILTER_COUNT_MAX	14
> >  =20
> >=20

