Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD5432638
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhJRSUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhJRSUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:20:39 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C89C06161C;
        Mon, 18 Oct 2021 11:18:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y7so15363915pfg.8;
        Mon, 18 Oct 2021 11:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=I8eEPb2FqiwPQ4HYeCCY1YPZcmyJICcVlQjpfk8OOEE=;
        b=iZMjYXFe6xK5J7aOqt8QhrCA8velLxHk98RCtfJKWl2nNvP8/UDCNC4AP8kkWgpDUG
         FbUPGA0Ut4PNHbFSGAH/vTdUXOg04AovOpYc3MiHL81PyzhxpcjT7S/+iqz2olx4QmUa
         5TGP5tq/y+dq3g9bY4YD4R0hcjWFWVVgmEPDSolSQ0AfgwK9g2Ca7j1+nRqbBi2uUXHA
         3arLaHJb+5ktWpf2lP9I6e7MnDIhwsgAZW6WLC6X76p6ajRIBgQO+oc7AEP18oI319H2
         3h7nFIYwmVl3R5CZCY5D0o69hS/J5KjYWQGJrLHky6ZEk2hU9VKId8sdp1zxAVdiX+eP
         497g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=I8eEPb2FqiwPQ4HYeCCY1YPZcmyJICcVlQjpfk8OOEE=;
        b=aGCFNO96/dD+RKG2MxF4RYogmzhTn3dCrEp5h2v/fV7zg4a4Vf8uIqzSXsZlqVNjY3
         5HqdixUz3QC9/+mRDoyqdueErKKL5ZKWBMfy26MUz0Qh17kw4bFcgv/9XVhJycOnndxb
         /raQbBNw2gz28WECXqmhmfgfJT4gl6IAXgFvqVlNnFUG9gSFv65qYD9sddOnc+FvMY4c
         jJvuKVzs+ItFTLiXX2tbfAS0uPwvXqwlyGpasvsn6iIhO/nhwfHZOpk74LYu733o2xb3
         xBY7WmtGlhaZM7Nn8PKaIihWteskVdiIdnymKE8JNuj/KxQ+K8ZqFE7AcWP6IvegXSBT
         p98Q==
X-Gm-Message-State: AOAM531OntbYPyScea+hjLbJm/g5g0hN2b7HQzBV37hEAeOiG+VQxFBL
        /70GlEDOJx6UQMP7qVAD0Rk=
X-Google-Smtp-Source: ABdhPJz9dFYeFFI4Ac2Ycbc/w57bwzAHNLAf6rhG59m4qh/469KWWUgu5rntGT6E8cQNmJ41Z7+LqQ==
X-Received: by 2002:a05:6a00:17a9:b0:44c:b95f:50a4 with SMTP id s41-20020a056a0017a900b0044cb95f50a4mr30116644pfg.6.1634581107246;
        Mon, 18 Oct 2021 11:18:27 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id e9sm122350pjl.41.2021.10.18.11.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:18:26 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 11/17] net: ipa: Add support for IPA v2.x endpoints
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Date:   Mon, 18 Oct 2021 23:47:58 +0530
Message-Id: <CF2QMSR815VC.5M3RMZULGVEV@skynet-linux>
In-Reply-To: <3f6c17a8-b901-c64f-2fbb-48faabccd255@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 4:00 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > IPA v2.x endpoints are the same as the endpoints on later versions. The
> > only big change was the addition of the "skip_config" flag. The only
> > other change is the backlog limit, which is a fixed number for IPA v2.6=
L
>
> Not much to say here. Your patches are reasonably small, which
> makes them easier to review (thank you).
>
> -Alex

I'm glad splitting them up paid off!

Regards,
Sireesh
>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >   drivers/net/ipa/ipa_endpoint.c | 65 ++++++++++++++++++++++-----------=
-
> >   1 file changed, 43 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpo=
int.c
> > index 7d3ab61cd890..024cf3a0ded0 100644
> > --- a/drivers/net/ipa/ipa_endpoint.c
> > +++ b/drivers/net/ipa/ipa_endpoint.c
> > @@ -360,8 +360,10 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa,=
 bool enable)
> >   {
> >   	u32 endpoint_id;
> >  =20
> > -	/* DELAY mode doesn't work correctly on IPA v4.2 */
> > -	if (ipa->version =3D=3D IPA_VERSION_4_2)
> > +	/* DELAY mode doesn't work correctly on IPA v4.2
> > +	 * Pausing is not supported on IPA v2.6L
> > +	 */
> > +	if (ipa->version =3D=3D IPA_VERSION_4_2 || ipa->version <=3D IPA_VERS=
ION_2_6L)
> >   		return;
> >  =20
> >   	for (endpoint_id =3D 0; endpoint_id < IPA_ENDPOINT_MAX; endpoint_id+=
+) {
> > @@ -383,6 +385,7 @@ int ipa_endpoint_modem_exception_reset_all(struct i=
pa *ipa)
> >   {
> >   	u32 initialized =3D ipa->initialized;
> >   	struct ipa_trans *trans;
> > +	u32 value =3D 0, value_mask =3D ~0;
> >   	u32 count;
> >  =20
> >   	/* We need one command per modem TX endpoint.  We can get an upper
> > @@ -398,6 +401,11 @@ int ipa_endpoint_modem_exception_reset_all(struct =
ipa *ipa)
> >   		return -EBUSY;
> >   	}
> >  =20
> > +	if (ipa->version <=3D IPA_VERSION_2_6L) {
> > +		value =3D aggr_force_close_fmask(true);
> > +		value_mask =3D aggr_force_close_fmask(true);
> > +	}
> > +
> >   	while (initialized) {
> >   		u32 endpoint_id =3D __ffs(initialized);
> >   		struct ipa_endpoint *endpoint;
> > @@ -416,7 +424,7 @@ int ipa_endpoint_modem_exception_reset_all(struct i=
pa *ipa)
> >   		 * means status is disabled on the endpoint, and as a
> >   		 * result all other fields in the register are ignored.
> >   		 */
> > -		ipa_cmd_register_write_add(trans, offset, 0, ~0, false);
> > +		ipa_cmd_register_write_add(trans, offset, value, value_mask, false);
> >   	}
> >  =20
> >   	ipa_cmd_pipeline_clear_add(trans);
> > @@ -1531,8 +1539,10 @@ static void ipa_endpoint_program(struct ipa_endp=
oint *endpoint)
> >   	ipa_endpoint_init_mode(endpoint);
> >   	ipa_endpoint_init_aggr(endpoint);
> >   	ipa_endpoint_init_deaggr(endpoint);
> > -	ipa_endpoint_init_rsrc_grp(endpoint);
> > -	ipa_endpoint_init_seq(endpoint);
> > +	if (endpoint->ipa->version > IPA_VERSION_2_6L) {
> > +		ipa_endpoint_init_rsrc_grp(endpoint);
> > +		ipa_endpoint_init_seq(endpoint);
> > +	}
> >   	ipa_endpoint_status(endpoint);
> >   }
> >  =20
> > @@ -1592,7 +1602,6 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint=
 *endpoint)
> >   {
> >   	struct device *dev =3D &endpoint->ipa->pdev->dev;
> >   	struct ipa_dma *gsi =3D &endpoint->ipa->dma_subsys;
> > -	bool stop_channel;
> >   	int ret;
> >  =20
> >   	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
> > @@ -1613,7 +1622,6 @@ void ipa_endpoint_resume_one(struct ipa_endpoint =
*endpoint)
> >   {
> >   	struct device *dev =3D &endpoint->ipa->pdev->dev;
> >   	struct ipa_dma *gsi =3D &endpoint->ipa->dma_subsys;
> > -	bool start_channel;
> >   	int ret;
> >  =20
> >   	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
> > @@ -1750,23 +1758,33 @@ int ipa_endpoint_config(struct ipa *ipa)
> >   	/* Find out about the endpoints supplied by the hardware, and ensure
> >   	 * the highest one doesn't exceed the number we support.
> >   	 */
> > -	val =3D ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
> > -
> > -	/* Our RX is an IPA producer */
> > -	rx_base =3D u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
> > -	max =3D rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
> > -	if (max > IPA_ENDPOINT_MAX) {
> > -		dev_err(dev, "too many endpoints (%u > %u)\n",
> > -			max, IPA_ENDPOINT_MAX);
> > -		return -EINVAL;
> > -	}
> > -	rx_mask =3D GENMASK(max - 1, rx_base);
> > +	if (ipa->version <=3D IPA_VERSION_2_6L) {
> > +		// FIXME Not used anywhere?
> > +		if (ipa->version =3D=3D IPA_VERSION_2_6L)
> > +			val =3D ioread32(ipa->reg_virt +
> > +					IPA_REG_V2_ENABLED_PIPES_OFFSET);
> > +		/* IPA v2.6L supports 20 pipes */
> > +		ipa->available =3D ipa->filter_map;
> > +		return 0;
> > +	} else {
> > +		val =3D ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
> > +
> > +		/* Our RX is an IPA producer */
> > +		rx_base =3D u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
> > +		max =3D rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
> > +		if (max > IPA_ENDPOINT_MAX) {
> > +			dev_err(dev, "too many endpoints (%u > %u)\n",
> > +					max, IPA_ENDPOINT_MAX);
> > +			return -EINVAL;
> > +		}
> > +		rx_mask =3D GENMASK(max - 1, rx_base);
> >  =20
> > -	/* Our TX is an IPA consumer */
> > -	max =3D u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
> > -	tx_mask =3D GENMASK(max - 1, 0);
> > +		/* Our TX is an IPA consumer */
> > +		max =3D u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
> > +		tx_mask =3D GENMASK(max - 1, 0);
> >  =20
> > -	ipa->available =3D rx_mask | tx_mask;
> > +		ipa->available =3D rx_mask | tx_mask;
> > +	}
> >  =20
> >   	/* Check for initialized endpoints not supported by the hardware */
> >   	if (ipa->initialized & ~ipa->available) {
> > @@ -1865,6 +1883,9 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
> >   			filter_map |=3D BIT(data->endpoint_id);
> >   	}
> >  =20
> > +	if (ipa->version <=3D IPA_VERSION_2_6L)
> > +		filter_map =3D 0x1fffff;
> > +
> >   	if (!ipa_filter_map_valid(ipa, filter_map))
> >   		goto err_endpoint_exit;
> >  =20
> >=20

