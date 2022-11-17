Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B097562D175
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiKQDMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbiKQDMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:12:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF9E4D5D7
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:12:35 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E1953221A1;
        Thu, 17 Nov 2022 03:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668654753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijJB+zXaasBYI6d/1MhwZHRuHqKCRbiRln8oS1MOC2g=;
        b=c9AceLoEvZfeG3kVSYY96D0IEcGojfT0VlN4/wTCz8RzPEozdMjrBMStto2+yuWMTngg9i
        QmPnfRAs4o+DJsI9d8PyAIIXWealkVocheAb5MxPru1smSeWM0KDgmFLeuo2Kmzi7Tstzq
        YqbN+tHpAuYNXmHfkazrfS1cCVpbltw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668654753;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijJB+zXaasBYI6d/1MhwZHRuHqKCRbiRln8oS1MOC2g=;
        b=Tux/3ISeWrNTrDJz0H+Ec6mt/DX0YCb+fLKvWJPxFUdkykZIY1r1Eam0gMQwxFVFNnA9uO
        wnfXMELmVIDD6xBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A41B72C141;
        Thu, 17 Nov 2022 03:12:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5311A608F4; Thu, 17 Nov 2022 04:12:30 +0100 (CET)
Date:   Thu, 17 Nov 2022 04:12:30 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss support
Message-ID: <20221117031230.daicjtkix6kjuhsz@lion.mk-sys.cz>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vfw4qlkc5ohuxaip"
Content-Disposition: inline
In-Reply-To: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vfw4qlkc5ohuxaip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2022 at 03:25:54PM -0800, Sudheer Mogilappagari wrote:
> Add netlink based support for "ethtool -x <dev> [context x]"
> command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> This is equivalent to functionality provided via ETHTOOL_GRSSH
> in ioctl path. It fetches RSS table, hash key and hash function
> of an interface to user space.
>=20
> This patch implements existing functionality available
> in ioctl path and enables addition of new RSS context
> based parameters in future.
>=20
> Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> ---
> v3:
> -Define parse_request and make use of ethnl_default_parse.
> -Have indir table and hask hey as seprate attributes.
> -Remove dumpit op for RSS_GET.
> -Use RSS instead of RXFH.
>=20
> v2: Fix cleanup in error path instead of returning.
> ---
[...]
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/et=
htool_netlink.h
> index aaf7c6963d61..ad837f034ac3 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -51,6 +51,7 @@ enum {
>  	ETHTOOL_MSG_MODULE_SET,
>  	ETHTOOL_MSG_PSE_GET,
>  	ETHTOOL_MSG_PSE_SET,
> +	ETHTOOL_MSG_RSS_GET,
> =20
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_USER_CNT,
> @@ -97,6 +98,7 @@ enum {
>  	ETHTOOL_MSG_MODULE_GET_REPLY,
>  	ETHTOOL_MSG_MODULE_NTF,
>  	ETHTOOL_MSG_PSE_GET_REPLY,
> +	ETHTOOL_MSG_RSS_GET_REPLY,
> =20
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -880,6 +882,18 @@ enum {
>  	ETHTOOL_A_PSE_MAX =3D (__ETHTOOL_A_PSE_CNT - 1)
>  };
> =20
> +enum {
> +	ETHTOOL_A_RSS_UNSPEC,
> +	ETHTOOL_A_RSS_HEADER,
> +	ETHTOOL_A_RSS_CONTEXT,		/* u32 */
> +	ETHTOOL_A_RSS_HFUNC,		/* u32 */
> +	ETHTOOL_A_RSS_INDIR,		/* array */
> +	ETHTOOL_A_RSS_HKEY,		/* array */

These two are binaries, not arrays.

> +
> +	__ETHTOOL_A_RSS_CNT,
> +	ETHTOOL_A_RSS_MAX =3D (__ETHTOOL_A_RSS_CNT - 1),
> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
[...]
> diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
> new file mode 100644
> index 000000000000..f4a700db3e9b
> --- /dev/null
> +++ b/net/ethtool/rss.c
[...]
> +static int
> +rss_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
> +		  struct netlink_ext_ack *extack)
> +{
> +	struct rss_req_info *request =3D RSS_REQINFO(req_info);
> +
> +	if (!tb[ETHTOOL_A_RSS_CONTEXT])
> +		return -EINVAL;

Unlike with ioctl, we do not need to represent "no context" with
a special value of zero. It would be IMHO cleaner to represent request
and reply without context (which should be the most frequent case,
AFAICS) by absence of the ETHTOOL_A_RSS_CONTEXT attribute.

> +
> +	request->rss_context =3D nla_get_u32(tb[ETHTOOL_A_RSS_CONTEXT]);
> +	return 0;
> +}
[...]
> +static int
> +rss_reply_size(const struct ethnl_req_info *req_base,
> +	       const struct ethnl_reply_data *reply_base)
> +{
> +	const struct rss_reply_data *data =3D RSS_REPDATA(reply_base);
> +	int len;
> +
> +	len =3D  nla_total_size(sizeof(u32)) +	/* _RSS_CONTEXT */
> +	       nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
> +	       nla_total_size(sizeof(u32)) * data->indir_size + /* _RSS_INDIR */

A nitpick: you pad the whole attribute, not each u32 separately, so that
it would make more sense to write this as

	 nla_total_size(sizeof(u32) * data->indir_size)

(The result will be the same, of course.)

Michal

> +	       data->hkey_size;			/* _RSS_HKEY */
> +
> +	return len;
> +}

--vfw4qlkc5ohuxaip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmN1ppcACgkQ538sG/LR
dpU5/wf/aGPTN0vAEJWi2MtCMEnnup20KfukoOn6BN0BhqDYnF2QTxXOyOHm5uxG
zvA7fJjez1JxWnrc+xaQE3rBXGbvkISGmBccliwf/ce1etsWkppIyilJPGCFKWS+
0lZsHl0fP3kUgx4yJeNh/yxUyb0X5m98jRaZ1ZZFcxWvM8TOI/PFsDaaJH2ktpFi
Iw6IGH7b02egv/PZyqsqMcgSnqFoO6AjEWqtheYemfp+BuP3nW/Wg0oMVnFnClfL
pgOlSs4LPx2Yi5xihBLOTmYWLEG4YPjGcRskC6v+hS+q9+kFBYC/AWvclyo6FSMw
75EG2asqUguBpo/ijxpimAW5cAj6PA==
=QcKi
-----END PGP SIGNATURE-----

--vfw4qlkc5ohuxaip--
