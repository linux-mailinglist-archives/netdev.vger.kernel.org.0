Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA534DA331
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiCOTTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiCOTTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:19:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F839B88
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:18:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A69A11F38A;
        Tue, 15 Mar 2022 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647371904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qGjOA5LQfF89fDV9xL1qn20aGHpn8f4t3zA9ygUdYCg=;
        b=Ml1bw7y9c5LT1ndXKcz3xEPVQA60XLB7kO4fJBkIQPppxqlqEEPtNdqzgLHBp/HVHBzmm6
        YfI9RHXD0xDPso292PQACJwF5wVeznVRsuI1vg1kfplmS2cx0KH9OXrjruo3i7e6h0WsXM
        90v0C6q+lRUYm3JNCW84zDZ5rXPOth0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647371904;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qGjOA5LQfF89fDV9xL1qn20aGHpn8f4t3zA9ygUdYCg=;
        b=NYijTsUSYm0wGKkjzCNLzZaUlSPkb3g3x5wBxDPFSvdN/PsVCNLUOw2435j5DHHicVNgIm
        CsnnG3aA1Y7kkCAA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2B84CA3B81;
        Tue, 15 Mar 2022 19:18:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E0A28602FD; Tue, 15 Mar 2022 20:18:23 +0100 (CET)
Date:   Tue, 15 Mar 2022 20:18:23 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, moyufeng@huawei.com, linyunsheng@huawei.com,
        tanhuazhong@huawei.com, salil.mehta@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Message-ID: <20220315191823.h3edooqrfevkxfuz@lion.mk-sys.cz>
References: <20220315032108.57228-1-wangjie125@huawei.com>
 <20220315032108.57228-2-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wx6nuj6t22kmrrql"
Content-Disposition: inline
In-Reply-To: <20220315032108.57228-2-wangjie125@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wx6nuj6t22kmrrql
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 15, 2022 at 11:21:07AM +0800, Jie Wang wrote:
> As tx push is a standard feature for NICs, but netdev_feature which is
> controlled by ethtool -K has reached the maximum specification.
>=20
> so this patch adds a pair of new ethtool messages=EF=BC=9A'ETHTOOL_GDEVFE=
AT' and
> 'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely to
> drivers. The message processing functions and function hooks in struct
> ethtool_ops are also added.
>=20
> set-devfeatures/show-devfeatures option(s) are designed to provide set
> and get function.
> set cmd:
> root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
> get cmd:
> root@wj: ethtool --show-devfeatures eth4
>=20
> Signed-off-by: Jie Wang <wangjie125@huawei.com>

The consensus is that no new commands should be added to the ioctl
interface. Please implement this via netlink.

Michal

> ---
>  include/linux/ethtool.h      |  4 ++++
>  include/uapi/linux/ethtool.h | 27 ++++++++++++++++++++++
>  net/ethtool/ioctl.c          | 43 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 74 insertions(+)
>=20
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 11efc45de66a..1a34bb074720 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -750,6 +750,10 @@ struct ethtool_ops {
>  	int	(*set_module_power_mode)(struct net_device *dev,
>  					 const struct ethtool_module_power_mode_params *params,
>  					 struct netlink_ext_ack *extack);
> +	int	(*get_devfeatures)(struct net_device *dev,
> +				   struct ethtool_dev_features *dev_feat);
> +	int	(*set_devfeatures)(struct net_device *dev,
> +				   struct ethtool_dev_features *dev_feat);
>  };
> =20
>  int ethtool_check_ops(const struct ethtool_ops *ops);
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 7bc4b8def12c..319d7b2c6acb 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1490,6 +1490,31 @@ enum ethtool_fec_config_bits {
>  #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
>  #define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
> =20
> +/**
> + * struct ethtool_dev_features - device feature configurations
> + * @cmd: Command number =3D %ETHTOOL_GDEVFEAT or %ETHTOOL_SDEVFEAT
> + * @type: feature configuration type.
> + * @data: feature configuration value.
> + */
> +struct ethtool_dev_features {
> +	__u32 cmd;
> +	__u32 type;
> +	__u32 data;
> +};
> +
> +/**
> + * enum ethtool_dev_features_type - flags definition of ethtool_dev_feat=
ures
> + * @ETHTOOL_DEV_TX_PUSH: nic tx push mode set bit.
> + */
> +enum ethtool_dev_features_type {
> +	ETHTOOL_DEV_TX_PUSH,
> +	/*
> +	 * Add your fresh feature type above and remember to update
> +	 * feat_line[] in ethtool.c
> +	 */
> +	ETHTOOL_DEV_FEATURE_COUNT,
> +};
> +
>  /* CMDs currently supported */
>  #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
>  					    * Please use ETHTOOL_GLINKSETTINGS
> @@ -1584,6 +1609,8 @@ enum ethtool_fec_config_bits {
>  #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration=
 */
>  #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
>  #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
> +#define ETHTOOL_GDEVFEAT	0x00000052 /* Get device features */
> +#define ETHTOOL_SDEVFEAT	0x00000053 /* Set device features */
> =20
>  /* compatibility with older code */
>  #define SPARC_ETH_GSET		ETHTOOL_GSET
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 326e14ee05db..efac23352eb9 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2722,6 +2722,42 @@ static int ethtool_set_fecparam(struct net_device =
*dev, void __user *useraddr)
>  	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
>  }
> =20
> +static int ethtool_get_devfeatures(struct net_device *dev,
> +				   void __user *useraddr)
> +{
> +	struct ethtool_dev_features dev_feat;
> +	int ret;
> +
> +	if (!dev->ethtool_ops->get_devfeatures)
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&dev_feat, useraddr, sizeof(dev_feat)))
> +		return -EFAULT;
> +
> +	ret =3D dev->ethtool_ops->get_devfeatures(dev, &dev_feat);
> +	if (ret)
> +		return ret;
> +
> +	if (copy_to_user(useraddr, &dev_feat, sizeof(dev_feat)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int ethtool_set_devfeatures(struct net_device *dev,
> +				   void __user *useraddr)
> +{
> +	struct ethtool_dev_features dev_feat;
> +
> +	if (!dev->ethtool_ops->set_devfeatures)
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&dev_feat, useraddr, sizeof(dev_feat)))
> +		return -EFAULT;
> +
> +	return dev->ethtool_ops->set_devfeatures(dev, &dev_feat);
> +}
> +
>  /* The main entry point in this file.  Called from net/core/dev_ioctl.c =
*/
> =20
>  static int
> @@ -2781,6 +2817,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, v=
oid __user *useraddr,
>  	case ETHTOOL_PHY_GTUNABLE:
>  	case ETHTOOL_GLINKSETTINGS:
>  	case ETHTOOL_GFECPARAM:
> +	case ETHTOOL_GDEVFEAT:
>  		break;
>  	default:
>  		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> @@ -3008,6 +3045,12 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, =
void __user *useraddr,
>  	case ETHTOOL_SFECPARAM:
>  		rc =3D ethtool_set_fecparam(dev, useraddr);
>  		break;
> +	case ETHTOOL_GDEVFEAT:
> +		rc =3D ethtool_get_devfeatures(dev, useraddr);
> +		break;
> +	case ETHTOOL_SDEVFEAT:
> +		rc =3D ethtool_set_devfeatures(dev, useraddr);
> +		break;
>  	default:
>  		rc =3D -EOPNOTSUPP;
>  	}
> --=20
> 2.33.0
>=20

--wx6nuj6t22kmrrql
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmIw5nkACgkQ538sG/LR
dpUZDwgAlSJPpxozyBMoEvx5tHtkHpDSeRcH32Q6ejFJYbOqiCrl7zzj4KpPujcE
zinQPk5VI9Ab0QmcdnKRrTLX/K7zDLXNPDUws+PUe3VVSQGF1o0PP9GGP+FglDNf
RWOeezsd1m8VzJP1wO0oTa/eF7n1QYo0JDpfawyCYEOtvlyTr+2ph4mbs8eFrKlX
dNDVfLgwkEzizWqpinOCCNMTAiCRK8AnQAF6Ko+VHk948EGuQUHMovyBjhvjDpS+
jrGQFEwT4Z9bZ4dUIcdtH1Lu6Svq50FDIglZK6+raTYzvGk+uD3GpXMXKBucQOOB
O/ZyJMDibLSZv1ypthZc86c6Q+xsdQ==
=VFrb
-----END PGP SIGNATURE-----

--wx6nuj6t22kmrrql--
