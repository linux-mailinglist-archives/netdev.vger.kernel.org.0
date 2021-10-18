Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345EF4324FF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhJRR37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhJRR35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:29:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25907C06161C;
        Mon, 18 Oct 2021 10:27:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d5so2429396pfu.1;
        Mon, 18 Oct 2021 10:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=qG/HAfnmlyIfdV1qVFJQLDS30sGdSuati2gHDL8p1wA=;
        b=I9Ec1TOFAnbbhwmQjFuSj5ORSYnp5JV9daStRm+9pENbV1Oiga75CDgEq0qypSyHJk
         eSvF5PiSaahePuEMys7KRObDjUVStBsSi8G3v5R4nqWde5e5hT/9ZYtZZ/2qGDkbk9rk
         rgJ7qmwyuf9HOCUfuvN4SmLU4Grt6l7R0prOnB0WAJHx/qIdg3QdoHgmo/6resyBreIS
         tyCUA6F5+NqqKq8BcGXu6Xh9qaoZeAmNCTwUEwplZGZ4/nk9qd4plPJAQyYUGFhI5QrI
         rpfzINCErgYjXB5I2NT4gMBooJ+wm6JPQZWh0HS1xPux3/sXFcK+P/PVX7cxdJe5yJb6
         +hgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=qG/HAfnmlyIfdV1qVFJQLDS30sGdSuati2gHDL8p1wA=;
        b=hIFgrD5mScdtjjmMxh0l7Z2tQsl5blHx5gq/GJlJXJJHGdUyV4GKf6xhBO8MPtEO9i
         lQoEGyr9djWnUrXeyfXopmn6KsjRIRzvguCZWyBGk8ZM9kPYpFHFgYoDmuXh3Of6elKe
         HUAZnTlkj2TkGhGTD7p3RR81qTxVo7DV+BOqUJkjSOhyGrzgKpOKVEYOmtOtuDp8S8cW
         zQiOMr+BSl3tM4uo5Mpo+FJaNqpK3MElLshoBuiM8f4sDLG2vmkS0Q+w8vfwhDT9nkId
         bORFhHOk+oO7dDHn4lT29fV5l7hz/BBWr8sVC/zLkkuTMWMkuHvV79Mk4G4pKAQMdpMK
         7dLA==
X-Gm-Message-State: AOAM532pmcORmyZ9Q2zd8TP6hznp5BjOXVFVMP3LDI/NstiGS/FMMWRs
        KUa6XXqXLhanljfSt/3IkD0=
X-Google-Smtp-Source: ABdhPJwAyMGyZY1nFx6twjijIVZdVDkb34HVWfCd+aAm0mXxLPOthTlWRMAyrjv3Qoewzi3NV1EbSA==
X-Received: by 2002:a65:6158:: with SMTP id o24mr24851428pgv.141.1634578065431;
        Mon, 18 Oct 2021 10:27:45 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id y203sm14142595pfc.0.2021.10.18.10.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:27:45 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 07/17] net: ipa: Add IPA v2.x register definitions
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Date:   Mon, 18 Oct 2021 22:55:11 +0530
Message-Id: <CF2PIE5JO4NR.PDG8H4F4BKJ9@skynet-linux>
In-Reply-To: <c7370126-e26e-bd6d-3502-0e35bdb4dd63@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 3:59 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > IPA v2.x is an older version the IPA hardware, and is 32 bit.
> >=20
> > Most of the registers were just shifted in newer IPA versions, but
> > the register fields have remained the same across IPA versions. This
> > means that only the register addresses needed to be added to the driver=
.
> >=20
> > To handle the different IPA register addresses, static inline functions
> > have been defined that return the correct register address.
>
> Thank you for following the existing convention in implementing these.
> Even if it isn't perfect, it's good to remain consistent.
>
> You use:
> if (version <=3D IPA_VERSION_2_6L)
> but then also define and use
> if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> And the only new IPA versions are 2_0, 2_5, and 2_6L.
>
> I would stick with the former and don't define IPA_VERSION_RANGE().
> Nothing less than IPA v2.0 (or 3.0 currently) is supported, so
> "there is no version less than that."

Makes sense, thanks!
>
> Oh, and I noticed some local variables defined without the
> "reverse Christmas tree order" which, like it or not, is the
> convention used consistently throughout this driver.
>

I wasn't aware of this, it should be easy enough to fix.

> I might quibble with a few other minor things in these definitions
> but overall this looks fine.
>

Thanks,
Sireesh
> -Alex
>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >   drivers/net/ipa/ipa_cmd.c      |   3 +-
> >   drivers/net/ipa/ipa_endpoint.c |  33 +++---
> >   drivers/net/ipa/ipa_main.c     |   8 +-
> >   drivers/net/ipa/ipa_mem.c      |   5 +-
> >   drivers/net/ipa/ipa_reg.h      | 184 +++++++++++++++++++++++++++-----=
-
> >   drivers/net/ipa/ipa_version.h  |  12 +++
> >   6 files changed, 195 insertions(+), 50 deletions(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
> > index 0bdbc331fa78..7a104540dc26 100644
> > --- a/drivers/net/ipa/ipa_cmd.c
> > +++ b/drivers/net/ipa/ipa_cmd.c
> > @@ -326,7 +326,8 @@ static bool ipa_cmd_register_write_valid(struct ipa=
 *ipa)
> >   	 * worst case (highest endpoint number) offset of that endpoint
> >   	 * fits in the register write command field(s) that must hold it.
> >   	 */
> > -	offset =3D IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT - 1);
> > +	offset =3D ipa_reg_endp_status_n_offset(ipa->version,
> > +			IPA_ENDPOINT_COUNT - 1);
> >   	name =3D "maximal endpoint status";
> >   	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
> >   		return false;
> > diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpo=
int.c
> > index dbef549c4537..7d3ab61cd890 100644
> > --- a/drivers/net/ipa/ipa_endpoint.c
> > +++ b/drivers/net/ipa/ipa_endpoint.c
> > @@ -242,8 +242,8 @@ static struct ipa_trans *ipa_endpoint_trans_alloc(s=
truct ipa_endpoint *endpoint,
> >   static bool
> >   ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_de=
lay)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_CTRL_N_OFFSET(endpoint->endpoint_id)=
;
> >   	struct ipa *ipa =3D endpoint->ipa;
> > +	u32 offset =3D ipa_reg_endp_init_ctrl_n_offset(ipa->version, endpoint=
->endpoint_id);
> >   	bool state;
> >   	u32 mask;
> >   	u32 val;
> > @@ -410,7 +410,7 @@ int ipa_endpoint_modem_exception_reset_all(struct i=
pa *ipa)
> >   		if (!(endpoint->ee_id =3D=3D GSI_EE_MODEM && endpoint->toward_ipa))
> >   			continue;
> >  =20
> > -		offset =3D IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
> > +		offset =3D ipa_reg_endp_status_n_offset(ipa->version, endpoint_id);
> >  =20
> >   		/* Value written is 0, and all bits are updated.  That
> >   		 * means status is disabled on the endpoint, and as a
> > @@ -431,7 +431,8 @@ int ipa_endpoint_modem_exception_reset_all(struct i=
pa *ipa)
> >  =20
> >   static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_CFG_N_OFFSET(endpoint->endpoint_id);
> > +	struct ipa *ipa =3D endpoint->ipa;
> > +	u32 offset =3D ipa_reg_endp_init_cfg_n_offset(ipa->version, endpoint-=
>endpoint_id);
> >   	enum ipa_cs_offload_en enabled;
> >   	u32 val =3D 0;
> >  =20
> > @@ -523,8 +524,8 @@ ipa_qmap_header_size(enum ipa_version version, stru=
ct ipa_endpoint *endpoint)
> >    */
> >   static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
> >   	struct ipa *ipa =3D endpoint->ipa;
> > +	u32 offset =3D ipa_reg_endp_init_hdr_n_offset(ipa->version, endpoint-=
>endpoint_id);
> >   	u32 val =3D 0;
> >  =20
> >   	if (endpoint->data->qmap) {
> > @@ -565,9 +566,9 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoi=
nt *endpoint)
> >  =20
> >   static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_=
id);
> > -	u32 pad_align =3D endpoint->data->rx.pad_align;
> >   	struct ipa *ipa =3D endpoint->ipa;
> > +	u32 offset =3D ipa_reg_endp_init_hdr_ext_n_offset(ipa->version, endpo=
int->endpoint_id);
> > +	u32 pad_align =3D endpoint->data->rx.pad_align;
> >   	u32 val =3D 0;
> >  =20
> >   	val |=3D HDR_ENDIANNESS_FMASK;		/* big endian */
> > @@ -609,6 +610,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_en=
dpoint *endpoint)
> >  =20
> >   static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *=
endpoint)
> >   {
> > +	enum ipa_version version =3D endpoint->ipa->version;
> >   	u32 endpoint_id =3D endpoint->endpoint_id;
> >   	u32 val =3D 0;
> >   	u32 offset;
> > @@ -616,7 +618,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(str=
uct ipa_endpoint *endpoint)
> >   	if (endpoint->toward_ipa)
> >   		return;		/* Register not valid for TX endpoints */
> >  =20
> > -	offset =3D IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
> > +	offset =3D ipa_reg_endp_init_hdr_metadata_mask_n_offset(version, endp=
oint_id);
> >  =20
> >   	/* Note that HDR_ENDIANNESS indicates big endian header fields */
> >   	if (endpoint->data->qmap)
> > @@ -627,7 +629,8 @@ static void ipa_endpoint_init_hdr_metadata_mask(str=
uct ipa_endpoint *endpoint)
> >  =20
> >   static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id)=
;
> > +	enum ipa_version version =3D endpoint->ipa->version;
> > +	u32 offset =3D ipa_reg_endp_init_mode_n_offset(version, endpoint->end=
point_id);
> >   	u32 val;
> >  =20
> >   	if (!endpoint->toward_ipa)
> > @@ -716,8 +719,8 @@ static u32 aggr_sw_eof_active_encoded(enum ipa_vers=
ion version, bool enabled)
> >  =20
> >   static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_AGGR_N_OFFSET(endpoint->endpoint_id)=
;
> >   	enum ipa_version version =3D endpoint->ipa->version;
> > +	u32 offset =3D ipa_reg_endp_init_aggr_n_offset(version, endpoint->end=
point_id);
> >   	u32 val =3D 0;
> >  =20
> >   	if (endpoint->data->aggregation) {
> > @@ -853,7 +856,7 @@ static void ipa_endpoint_init_hol_block_timer(struc=
t ipa_endpoint *endpoint,
> >   	u32 offset;
> >   	u32 val;
> >  =20
> > -	offset =3D IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
> > +	offset =3D ipa_reg_endp_init_hol_block_timer_n_offset(ipa->version, e=
ndpoint_id);
> >   	val =3D hol_block_timer_val(ipa, microseconds);
> >   	iowrite32(val, ipa->reg_virt + offset);
> >   }
> > @@ -861,12 +864,13 @@ static void ipa_endpoint_init_hol_block_timer(str=
uct ipa_endpoint *endpoint,
> >   static void
> >   ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, boo=
l enable)
> >   {
> > +	enum ipa_version version =3D endpoint->ipa->version;
> >   	u32 endpoint_id =3D endpoint->endpoint_id;
> >   	u32 offset;
> >   	u32 val;
> >  =20
> >   	val =3D enable ? HOL_BLOCK_EN_FMASK : 0;
> > -	offset =3D IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
> > +	offset =3D ipa_reg_endp_init_hol_block_en_n_offset(version, endpoint_=
id);
> >   	iowrite32(val, endpoint->ipa->reg_virt + offset);
> >   }
> >  =20
> > @@ -887,7 +891,8 @@ void ipa_endpoint_modem_hol_block_clear_all(struct =
ipa *ipa)
> >  =20
> >   static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
> >   {
> > -	u32 offset =3D IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(endpoint->endpoint_i=
d);
> > +	enum ipa_version version =3D endpoint->ipa->version;
> > +	u32 offset =3D ipa_reg_endp_init_deaggr_n_offset(version, endpoint->e=
ndpoint_id);
> >   	u32 val =3D 0;
> >  =20
> >   	if (!endpoint->toward_ipa)
> > @@ -979,7 +984,7 @@ static void ipa_endpoint_status(struct ipa_endpoint=
 *endpoint)
> >   	u32 val =3D 0;
> >   	u32 offset;
> >  =20
> > -	offset =3D IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
> > +	offset =3D ipa_reg_endp_status_n_offset(ipa->version, endpoint_id);
> >  =20
> >   	if (endpoint->data->status_enable) {
> >   		val |=3D STATUS_EN_FMASK;
> > @@ -1384,7 +1389,7 @@ void ipa_endpoint_default_route_set(struct ipa *i=
pa, u32 endpoint_id)
> >   	val |=3D u32_encode_bits(endpoint_id, ROUTE_FRAG_DEF_PIPE_FMASK);
> >   	val |=3D ROUTE_DEF_RETAIN_HDR_FMASK;
> >  =20
> > -	iowrite32(val, ipa->reg_virt + IPA_REG_ROUTE_OFFSET);
> > +	iowrite32(val, ipa->reg_virt + ipa_reg_route_offset(ipa->version));
> >   }
> >  =20
> >   void ipa_endpoint_default_route_clear(struct ipa *ipa)
> > diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> > index 6ab691ff1faf..ba06e3ad554c 100644
> > --- a/drivers/net/ipa/ipa_main.c
> > +++ b/drivers/net/ipa/ipa_main.c
> > @@ -191,7 +191,7 @@ static void ipa_hardware_config_comp(struct ipa *ip=
a)
> >   	if (ipa->version < IPA_VERSION_4_0)
> >   		return;
> >  =20
> > -	val =3D ioread32(ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
> > +	val =3D ioread32(ipa->reg_virt + ipa_reg_comp_cfg_offset(ipa->version=
));
> >  =20
> >   	if (ipa->version =3D=3D IPA_VERSION_4_0) {
> >   		val &=3D ~IPA_QMB_SELECT_CONS_EN_FMASK;
> > @@ -206,7 +206,7 @@ static void ipa_hardware_config_comp(struct ipa *ip=
a)
> >   	val |=3D GSI_MULTI_INORDER_RD_DIS_FMASK;
> >   	val |=3D GSI_MULTI_INORDER_WR_DIS_FMASK;
> >  =20
> > -	iowrite32(val, ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
> > +	iowrite32(val, ipa->reg_virt + ipa_reg_comp_cfg_offset(ipa->version))=
;
> >   }
> >  =20
> >   /* Configure DDR and (possibly) PCIe max read/write QSB values */
> > @@ -355,7 +355,7 @@ static void ipa_hardware_config(struct ipa *ipa, co=
nst struct ipa_data *data)
> >   	/* IPA v4.5+ has no backward compatibility register */
> >   	if (version < IPA_VERSION_4_5) {
> >   		val =3D data->backward_compat;
> > -		iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
> > +		iowrite32(val, ipa->reg_virt + ipa_reg_bcr_offset(ipa->version));
> >   	}
> >  =20
> >   	/* Implement some hardware workarounds */
> > @@ -384,7 +384,7 @@ static void ipa_hardware_config(struct ipa *ipa, co=
nst struct ipa_data *data)
> >   		/* Configure aggregation timer granularity */
> >   		granularity =3D ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
> >   		val =3D u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
> > -		iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
> > +		iowrite32(val, ipa->reg_virt + ipa_reg_counter_cfg_offset(ipa->versi=
on));
> >   	} else {
> >   		ipa_qtime_config(ipa);
> >   	}
> > diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
> > index 16e5fdd5bd73..8acc88070a6f 100644
> > --- a/drivers/net/ipa/ipa_mem.c
> > +++ b/drivers/net/ipa/ipa_mem.c
> > @@ -113,7 +113,8 @@ int ipa_mem_setup(struct ipa *ipa)
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
> >   	offset =3D ipa->mem_offset + mem->offset;
> >   	val =3D proc_cntxt_base_addr_encoded(ipa->version, offset);
> > -	iowrite32(val, ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET);
> > +	iowrite32(val, ipa->reg_virt +
> > +		  ipa_reg_local_pkt_proc_cntxt_base_offset(ipa->version));
> >  =20
> >   	return 0;
> >   }
> > @@ -316,7 +317,7 @@ int ipa_mem_config(struct ipa *ipa)
> >   	u32 i;
> >  =20
> >   	/* Check the advertised location and size of the shared memory area =
*/
> > -	val =3D ioread32(ipa->reg_virt + IPA_REG_SHARED_MEM_SIZE_OFFSET);
> > +	val =3D ioread32(ipa->reg_virt + ipa_reg_shared_mem_size_offset(ipa->=
version));
> >  =20
> >   	/* The fields in the register are in 8 byte units */
> >   	ipa->mem_offset =3D 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
> > diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
> > index a5b355384d4a..fcae0296cfa4 100644
> > --- a/drivers/net/ipa/ipa_reg.h
> > +++ b/drivers/net/ipa/ipa_reg.h
> > @@ -65,7 +65,17 @@ struct ipa;
> >    * of valid bits for the register.
> >    */
> >  =20
> > -#define IPA_REG_COMP_CFG_OFFSET				0x0000003c
> > +#define IPA_REG_COMP_SW_RESET_OFFSET		0x0000003c
> > +
> > +#define IPA_REG_V2_ENABLED_PIPES_OFFSET		0x000005dc
> > +
> > +static inline u32 ipa_reg_comp_cfg_offset(enum ipa_version version)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x38;
> > +
> > +	return 0x3c;
> > +}
> >   /* The next field is not supported for IPA v4.0+, not present for IPA=
 v4.5+ */
> >   #define ENABLE_FMASK				GENMASK(0, 0)
> >   /* The next field is present for IPA v4.7+ */
> > @@ -124,6 +134,7 @@ static inline u32 full_flush_rsc_closure_en_encoded=
(enum ipa_version version,
> >   	return u32_encode_bits(val, GENMASK(17, 17));
> >   }
> >  =20
> > +/* This register is only present on IPA v3.0 and above */
> >   #define IPA_REG_CLKON_CFG_OFFSET			0x00000044
> >   #define RX_FMASK				GENMASK(0, 0)
> >   #define PROC_FMASK				GENMASK(1, 1)
> > @@ -164,7 +175,14 @@ static inline u32 full_flush_rsc_closure_en_encode=
d(enum ipa_version version,
> >   /* The next field is present for IPA v4.7+ */
> >   #define DRBIP_FMASK				GENMASK(31, 31)
> >  =20
> > -#define IPA_REG_ROUTE_OFFSET				0x00000048
> > +static inline u32 ipa_reg_route_offset(enum ipa_version version)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x44;
> > +
> > +	return 0x48;
> > +}
> > +
> >   #define ROUTE_DIS_FMASK				GENMASK(0, 0)
> >   #define ROUTE_DEF_PIPE_FMASK			GENMASK(5, 1)
> >   #define ROUTE_DEF_HDR_TABLE_FMASK		GENMASK(6, 6)
> > @@ -172,7 +190,14 @@ static inline u32 full_flush_rsc_closure_en_encode=
d(enum ipa_version version,
> >   #define ROUTE_FRAG_DEF_PIPE_FMASK		GENMASK(21, 17)
> >   #define ROUTE_DEF_RETAIN_HDR_FMASK		GENMASK(24, 24)
> >  =20
> > -#define IPA_REG_SHARED_MEM_SIZE_OFFSET			0x00000054
> > +static inline u32 ipa_reg_shared_mem_size_offset(enum ipa_version vers=
ion)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x50;
> > +
> > +	return 0x54;
> > +}
> > +
> >   #define SHARED_MEM_SIZE_FMASK			GENMASK(15, 0)
> >   #define SHARED_MEM_BADDR_FMASK			GENMASK(31, 16)
> >  =20
> > @@ -219,7 +244,13 @@ static inline u32 ipa_reg_state_aggr_active_offset=
(enum ipa_version version)
> >   }
> >  =20
> >   /* The next register is not present for IPA v4.5+ */
> > -#define IPA_REG_BCR_OFFSET				0x000001d0
> > +static inline u32 ipa_reg_bcr_offset(enum ipa_version version)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_5, 2_6L))
> > +		return 0x5b0;
> > +
> > +	return 0x1d0;
> > +}
> >   /* The next two fields are not present for IPA v4.2+ */
> >   #define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
> >   #define BCR_TX_NOT_USING_BRESP_FMASK		GENMASK(1, 1)
> > @@ -236,7 +267,14 @@ static inline u32 ipa_reg_state_aggr_active_offset=
(enum ipa_version version)
> >   #define BCR_ROUTER_PREFETCH_EN_FMASK		GENMASK(9, 9)
> >  =20
> >   /* The value of the next register must be a multiple of 8 (bottom 3 b=
its 0) */
> > -#define IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET		0x000001e8
> > +static inline u32 ipa_reg_local_pkt_proc_cntxt_base_offset(enum ipa_ve=
rsion version)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x5e0;
> > +
> > +	return 0x1e8;
> > +}
> > +
> >  =20
> >   /* Encoded value for LOCAL_PKT_PROC_CNTXT register BASE_ADDR field */
> >   static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version versi=
on,
> > @@ -252,7 +290,14 @@ static inline u32 proc_cntxt_base_addr_encoded(enu=
m ipa_version version,
> >   #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
> >  =20
> >   /* The next register is not present for IPA v4.5+ */
> > -#define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
> > +static inline u32 ipa_reg_counter_cfg_offset(enum ipa_version version)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_5, 2_6L))
> > +		return 0x5e8;
> > +
> > +	return 0x1f0;
> > +}
> > +
> >   /* The next field is not present for IPA v3.5+ */
> >   #define EOT_COAL_GRANULARITY			GENMASK(3, 0)
> >   #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
> > @@ -349,15 +394,27 @@ enum ipa_pulse_gran {
> >   #define Y_MIN_LIM_FMASK				GENMASK(21, 16)
> >   #define Y_MAX_LIM_FMASK				GENMASK(29, 24)
> >  =20
> > -#define IPA_REG_ENDP_INIT_CTRL_N_OFFSET(ep) \
> > -					(0x00000800 + 0x0070 * (ep))
> > +static inline u32 ipa_reg_endp_init_ctrl_n_offset(enum ipa_version ver=
sion, u16 ep)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x70 + 0x4 * ep;
> > +
> > +	return 0x800 + 0x70 * ep;
> > +}
> > +
> >   /* Valid only for RX (IPA producer) endpoints (do not use for IPA v4.=
0+) */
> >   #define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
> >   /* Valid only for TX (IPA consumer) endpoints */
> >   #define ENDP_DELAY_FMASK			GENMASK(1, 1)
> >  =20
> > -#define IPA_REG_ENDP_INIT_CFG_N_OFFSET(ep) \
> > -					(0x00000808 + 0x0070 * (ep))
> > +static inline u32 ipa_reg_endp_init_cfg_n_offset(enum ipa_version vers=
ion, u16 ep)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0xc0 + 0x4 * ep;
> > +
> > +	return 0x808 + 0x70 * ep;
> > +}
> > +
> >   #define FRAG_OFFLOAD_EN_FMASK			GENMASK(0, 0)
> >   #define CS_OFFLOAD_EN_FMASK			GENMASK(2, 1)
> >   #define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
> > @@ -383,8 +440,14 @@ enum ipa_nat_en {
> >   	IPA_NAT_DST			=3D 0x2,
> >   };
> >  =20
> > -#define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
> > -					(0x00000810 + 0x0070 * (ep))
> > +static inline u32 ipa_reg_endp_init_hdr_n_offset(enum ipa_version vers=
ion, u16 ep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x170 + 0x4 * ep;
> > +
> > +	return 0x810 + 0x70 * ep;
> > +}
> > +
> >   #define HDR_LEN_FMASK				GENMASK(5, 0)
> >   #define HDR_OFST_METADATA_VALID_FMASK		GENMASK(6, 6)
> >   #define HDR_OFST_METADATA_FMASK			GENMASK(12, 7)
> > @@ -440,8 +503,14 @@ static inline u32 ipa_metadata_offset_encoded(enum=
 ipa_version version,
> >   	return val;
> >   }
> >  =20
> > -#define IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(ep) \
> > -					(0x00000814 + 0x0070 * (ep))
> > +static inline u32 ipa_reg_endp_init_hdr_ext_n_offset(enum ipa_version =
version, u16 ep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x1c0 + 0x4 * ep;
> > +
> > +	return 0x814 + 0x70 * ep;
> > +}
> > +
> >   #define HDR_ENDIANNESS_FMASK			GENMASK(0, 0)
> >   #define HDR_TOTAL_LEN_OR_PAD_VALID_FMASK	GENMASK(1, 1)
> >   #define HDR_TOTAL_LEN_OR_PAD_FMASK		GENMASK(2, 2)
> > @@ -454,12 +523,23 @@ static inline u32 ipa_metadata_offset_encoded(enu=
m ipa_version version,
> >   #define HDR_ADDITIONAL_CONST_LEN_MSB_FMASK	GENMASK(21, 20)
> >  =20
> >   /* Valid only for RX (IPA producer) endpoints */
> > -#define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(rxep) \
> > -					(0x00000818 + 0x0070 * (rxep))
> > +static inline u32 ipa_reg_endp_init_hdr_metadata_mask_n_offset(enum ip=
a_version version, u16 rxep)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x220 + 0x4 * rxep;
> > +
> > +	return 0x818 + 0x70 * rxep;
> > +}
> >  =20
> >   /* Valid only for TX (IPA consumer) endpoints */
> > -#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(txep) \
> > -					(0x00000820 + 0x0070 * (txep))
> > +static inline u32 ipa_reg_endp_init_mode_n_offset(enum ipa_version ver=
sion, u16 txep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x2c0 + 0x4 * txep;
> > +
> > +	return 0x820 + 0x70 * txep;
> > +}
> > +
> >   #define MODE_FMASK				GENMASK(2, 0)
> >   /* The next field is present for IPA v4.5+ */
> >   #define DCPH_ENABLE_FMASK			GENMASK(3, 3)
> > @@ -480,8 +560,14 @@ enum ipa_mode {
> >   	IPA_DMA				=3D 0x3,
> >   };
> >  =20
> > -#define IPA_REG_ENDP_INIT_AGGR_N_OFFSET(ep) \
> > -					(0x00000824 +  0x0070 * (ep))
> > +static inline u32 ipa_reg_endp_init_aggr_n_offset(enum ipa_version ver=
sion,
> > +						  u16 ep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x320 + 0x4 * ep;
> > +	return 0x824 + 0x70 * ep;
> > +}
> > +
> >   #define AGGR_EN_FMASK				GENMASK(1, 0)
> >   #define AGGR_TYPE_FMASK				GENMASK(4, 2)
> >  =20
> > @@ -543,14 +629,27 @@ enum ipa_aggr_type {
> >   };
> >  =20
> >   /* Valid only for RX (IPA producer) endpoints */
> > -#define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(rxep) \
> > -					(0x0000082c +  0x0070 * (rxep))
> > +static inline u32 ipa_reg_endp_init_hol_block_en_n_offset(enum ipa_ver=
sion version,
> > +							  u16 rxep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x3c0 + 0x4 * rxep;
> > +
> > +	return 0x82c + 0x70 * rxep;
> > +}
> > +
> >   #define HOL_BLOCK_EN_FMASK			GENMASK(0, 0)
> >  =20
> >   /* Valid only for RX (IPA producer) endpoints */
> > -#define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(rxep) \
> > -					(0x00000830 +  0x0070 * (rxep))
> > -/* The next two fields are present for IPA v4.2 only */
> > +static inline u32 ipa_reg_endp_init_hol_block_timer_n_offset(enum ipa_=
version version, u16 rxep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x420 + 0x4 * rxep;
> > +
> > +	return 0x830 + 0x70 * rxep;
> > +}
> > +
> > +/* The next fields are present for IPA v4.2 only */
> >   #define BASE_VALUE_FMASK			GENMASK(4, 0)
> >   #define SCALE_FMASK				GENMASK(12, 8)
> >   /* The next two fields are present for IPA v4.5 */
> > @@ -558,8 +657,14 @@ enum ipa_aggr_type {
> >   #define GRAN_SEL_FMASK				GENMASK(8, 8)
> >  =20
> >   /* Valid only for TX (IPA consumer) endpoints */
> > -#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(txep) \
> > -					(0x00000834 + 0x0070 * (txep))
> > +static inline u32 ipa_reg_endp_init_deaggr_n_offset(enum ipa_version v=
ersion, u16 txep)
> > +{
> > +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> > +		return 0x470 + 0x4 * txep;
> > +
> > +	return 0x834 + 0x70 * txep;
> > +}
> > +
> >   #define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
> >   #define SYSPIPE_ERR_DETECTION_FMASK		GENMASK(6, 6)
> >   #define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
> > @@ -629,8 +734,14 @@ enum ipa_seq_rep_type {
> >   	IPA_SEQ_REP_DMA_PARSER			=3D 0x08,
> >   };
> >  =20
> > -#define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
> > -					(0x00000840 + 0x0070 * (ep))
> > +static inline u32 ipa_reg_endp_status_n_offset(enum ipa_version versio=
n, u16 ep)
> > +{
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x4c0 + 0x4 * ep;
> > +
> > +	return 0x840 + 0x70 * ep;
> > +}
> > +
> >   #define STATUS_EN_FMASK				GENMASK(0, 0)
> >   #define STATUS_ENDP_FMASK			GENMASK(5, 1)
> >   /* The next field is not present for IPA v4.5+ */
> > @@ -662,6 +773,9 @@ enum ipa_seq_rep_type {
> >   static inline u32 ipa_reg_irq_stts_ee_n_offset(enum ipa_version versi=
on,
> >   					       u32 ee)
> >   {
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x00001008 + 0x1000 * ee;
> > +
> >   	if (version < IPA_VERSION_4_9)
> >   		return 0x00003008 + 0x1000 * ee;
> >  =20
> > @@ -675,6 +789,9 @@ static inline u32 ipa_reg_irq_stts_offset(enum ipa_=
version version)
> >  =20
> >   static inline u32 ipa_reg_irq_en_ee_n_offset(enum ipa_version version=
, u32 ee)
> >   {
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x0000100c + 0x1000 * ee;
> > +
> >   	if (version < IPA_VERSION_4_9)
> >   		return 0x0000300c + 0x1000 * ee;
> >  =20
> > @@ -688,6 +805,9 @@ static inline u32 ipa_reg_irq_en_offset(enum ipa_ve=
rsion version)
> >  =20
> >   static inline u32 ipa_reg_irq_clr_ee_n_offset(enum ipa_version versio=
n, u32 ee)
> >   {
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x00001010 + 0x1000 * ee;
> > +
> >   	if (version < IPA_VERSION_4_9)
> >   		return 0x00003010 + 0x1000 * ee;
> >  =20
> > @@ -776,6 +896,9 @@ enum ipa_irq_id {
> >  =20
> >   static inline u32 ipa_reg_irq_uc_ee_n_offset(enum ipa_version version=
, u32 ee)
> >   {
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x101c + 1000 * ee;
> > +
> >   	if (version < IPA_VERSION_4_9)
> >   		return 0x0000301c + 0x1000 * ee;
> >  =20
> > @@ -793,6 +916,9 @@ static inline u32 ipa_reg_irq_uc_offset(enum ipa_ve=
rsion version)
> >   static inline u32
> >   ipa_reg_irq_suspend_info_ee_n_offset(enum ipa_version version, u32 ee=
)
> >   {
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		return 0x00001098 + 0x1000 * ee;
> > +
> >   	if (version =3D=3D IPA_VERSION_3_0)
> >   		return 0x00003098 + 0x1000 * ee;
> >  =20
> > diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_versio=
n.h
> > index 6c16c895d842..0d816de586ba 100644
> > --- a/drivers/net/ipa/ipa_version.h
> > +++ b/drivers/net/ipa/ipa_version.h
> > @@ -8,6 +8,9 @@
> >  =20
> >   /**
> >    * enum ipa_version
> > + * @IPA_VERSION_2_0:	IPA version 2.0
> > + * @IPA_VERSION_2_5:	IPA version 2.5/2.6
> > + * @IPA_VERSION_2_6:	IPA version 2.6L
> >    * @IPA_VERSION_3_0:	IPA version 3.0/GSI version 1.0
> >    * @IPA_VERSION_3_1:	IPA version 3.1/GSI version 1.1
> >    * @IPA_VERSION_3_5:	IPA version 3.5/GSI version 1.2
> > @@ -25,6 +28,9 @@
> >    * new version is added.
> >    */
> >   enum ipa_version {
> > +	IPA_VERSION_2_0,
> > +	IPA_VERSION_2_5,
> > +	IPA_VERSION_2_6L,
> >   	IPA_VERSION_3_0,
> >   	IPA_VERSION_3_1,
> >   	IPA_VERSION_3_5,
> > @@ -38,4 +44,10 @@ enum ipa_version {
> >   	IPA_VERSION_4_11,
> >   };
> >  =20
> > +#define IPA_HAS_GSI(version) ((version) > IPA_VERSION_2_6L)
> > +#define IPA_IS_64BIT(version) ((version) > IPA_VERSION_2_6L)
> > +#define IPA_VERSION_RANGE(_version, _from, _to) \
> > +	((_version) >=3D (IPA_VERSION_##_from) &&  \
> > +	 (_version) <=3D (IPA_VERSION_##_to))
> > +
> >   #endif /* _IPA_VERSION_H_ */
> >=20

