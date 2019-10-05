Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945DECC6EC
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfJEAcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:32:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33903 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJEAcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 20:32:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id 3so11086353qta.1
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 17:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Y6lPexw+6scp2vAGrF2Qx4Ll3/PnzrLh8vVrsPnDkm4=;
        b=eBCwHRhUmvKjWpyrzVdysONTnjVMa67endAd2e1EkhoUwFcGvQhUSWwFfwR6HcD4g9
         xetnWKXD1j1klheek2pPlnRL+ntpcitJq7f3AetD4nDhLDxZMjF3+PCLHMeQSmkpOllH
         woxmekXRLyU5482OfFES9md6eaD7iqp8x+jlZG/qaMNbooKmH3nzwrSpQ6HXi3vv/SWZ
         59mimNfa3j5Z2nzrNEAiynPxI9ioQ2qJebZsH/4j7PXVdfR8CiznVhbVF8bhfrErJ1Z3
         UHFUOS/QlZTmTCYpiMPlXe4mZHucodb6hZeB6vlr6zUMrRiW932BxXLdjOYfHiTCq9Aj
         TfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Y6lPexw+6scp2vAGrF2Qx4Ll3/PnzrLh8vVrsPnDkm4=;
        b=SPdRlnatiiNBJqm/gS94N6fVMZk1o113Vme+l9bnwlS3XJSdEghyx12Hym2zt/3WTc
         m2ox/+G4zcw+/qp/VP5sXJSDfv3+Pf90KaYjIQPZO7Xts0nZDzthMEfn/3Iwx4lNOtVD
         C0asM+WsExkx96jxR0iLSRDIs+xAW/NDlJGIWz1I2CL7kHNfv4486dyPHbLUSHU3VSHV
         8zCAwfzBuuIYxqj3P+2wayWlyvWg2+3cWDmqu1h9tqjXnvHvWC3LdJQJ1Kt6ImsezwFP
         0+uiGesXVIzdc70cJf2GQGPe1gzBHhQccAK4spW4UaTNABOZ4xQI61gk+XdUFRwSK6HP
         3K6w==
X-Gm-Message-State: APjAAAXDqdQK/QfdMHflA6c5V2J/PvdTXUH5awIbpM0XcBPPHAB6FZRX
        PV8877YxjFiMR6VPVjsnVQk=
X-Google-Smtp-Source: APXvYqygpYLfR6ORN6AnuB8TrYWJdTiy7ffUwQvhiVY9fJ4tXeUzJjbsNKeqOkKPRjPoajcxUQpuCQ==
X-Received: by 2002:a0c:ef8b:: with SMTP id w11mr16595373qvr.77.1570235541269;
        Fri, 04 Oct 2019 17:32:21 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w85sm4223942qkb.57.2019.10.04.17.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 17:32:20 -0700 (PDT)
Date:   Fri, 4 Oct 2019 20:32:19 -0400
Message-ID: <20191004203219.GF32368@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
In-Reply-To: <20191004210934.12813-3-andrew@lunn.ch>
References: <20191004210934.12813-1-andrew@lunn.ch>
 <20191004210934.12813-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri,  4 Oct 2019 23:09:34 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> Some of the marvell switches have bits controlling the hash algorithm
> the ATU uses for MAC addresses. In some industrial settings, where all
> the devices are from the same manufacture, and hence use the same OUI,
> the default hashing algorithm is not optimal. Allow the other
> algorithms to be selected via devlink.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../networking/devlink-params-mv88e6xxx.txt   |   6 +
>  MAINTAINERS                                   |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c              | 134 +++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
>  drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
>  drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
>  6 files changed, 179 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt
> 
> diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink-params-mv88e6xxx.txt
> new file mode 100644
> index 000000000000..cc5c1ac87c36
> --- /dev/null
> +++ b/Documentation/networking/devlink-params-mv88e6xxx.txt
> @@ -0,0 +1,6 @@
> +ATU_hash		[DEVICE, DRIVER-SPECIFIC]
> +			Select one of four possible hashing algorithms for
> +			MAC addresses in the Address Translation Unity.
> +			A value of 3 seems to work better than the default of
> +			1 when many MAC addresses have the same OUI.
> +			Configuration mode: runtime
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 496e8f156925..2246dc121c30 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9736,6 +9736,7 @@ S:	Maintained
>  F:	drivers/net/dsa/mv88e6xxx/
>  F:	include/linux/platform_data/mv88e6xxx.h
>  F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
> +F:	Documentation/networking/devlink-params-mv88e6xxx.txt
>  
>  MARVELL ARMADA DRM SUPPORT
>  M:	Russell King <linux@armlinux.org.uk>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 6787d560e9e3..c9755a4285a9 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1370,6 +1370,22 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
>  	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
>  }
>  
> +static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
> +{
> +	if (chip->info->ops->atu_get_hash)
> +		return chip->info->ops->atu_get_hash(chip, hash);
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int mv88e6xxx_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash)
> +{
> +	if (chip->info->ops->atu_set_hash)
> +		return chip->info->ops->atu_set_hash(chip, hash);
> +
> +	return -EOPNOTSUPP;
> +}
> +
>  static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
>  					u16 vid_begin, u16 vid_end)
>  {
> @@ -2641,6 +2657,81 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
>  	return mv88e6xxx_software_reset(chip);
>  }
>  
> +enum mv88e6xxx_devlink_param_id {
> +	MV88E6XXX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
> +	MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
> +};
> +
> +static int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
> +				       struct devlink_param_gset_ctx *ctx)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int err;
> +	u8 hash;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	switch (id) {
> +	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
> +		err = mv88e6xxx_atu_get_hash(chip, &hash);
> +		if (err < 0)
> +			break;

No need to check for error signedness, just do if (err).

> +
> +		ctx->val.vu8 = hash;

Is ctx->val.vu8 an u8 as well? If so you can just write:

                err = mv88e6xxx_atu_get_hash(chip, &ctx->val.vu8);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;

Missing a break statement here.

> +	}
> +
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +static int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
> +				       struct devlink_param_gset_ctx *ctx)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int err;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	switch (id) {
> +	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
> +		err = mv88e6xxx_atu_set_hash(chip, ctx->val.vu8);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;

Missing a break statement here too.

> +	}
> +
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +static const struct devlink_param mv88e6xxx_devlink_params[] = {
> +	DSA_DEVLINK_PARAM_DRIVER(MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
> +				 "ATU_hash", DEVLINK_PARAM_TYPE_U8,
> +				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
> +};
> +
> +static int mv88e6xxx_setup_devlink_params(struct dsa_switch *ds)
> +{
> +	return dsa_devlink_params_register(ds, mv88e6xxx_devlink_params,
> +					   ARRAY_SIZE(mv88e6xxx_devlink_params));
> +}
> +
> +static void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds)
> +{
> +	dsa_devlink_params_unregister(ds, mv88e6xxx_devlink_params,
> +				      ARRAY_SIZE(mv88e6xxx_devlink_params));
> +}
> +
> +static void mv88e6xxx_teardown(struct dsa_switch *ds)
> +{
> +	mv88e6xxx_teardown_devlink_params(ds);
> +}
> +
>  static int mv88e6xxx_setup(struct dsa_switch *ds)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> @@ -2757,7 +2848,11 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  unlock:
>  	mv88e6xxx_reg_unlock(chip);
>  
> -	return err;
> +	/* Has to be called without holding the register lock, since
> +	 * it takes the devlink lock, and we later take the locks in
> +	 * the reverse order when getting/setting parameters.
> +	 */
> +	return mv88e6xxx_setup_devlink_params(ds);
>  }
>  
>  static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
> @@ -3117,6 +3212,8 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.phylink_validate = mv88e6185_phylink_validate,
> @@ -3246,6 +3343,8 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.avb_ops = &mv88e6165_avb_ops,
> @@ -3280,6 +3379,8 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.avb_ops = &mv88e6165_avb_ops,
> @@ -3322,6 +3423,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.phylink_validate = mv88e6185_phylink_validate,
> @@ -3366,6 +3469,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6352_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
> @@ -3409,6 +3514,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.phylink_validate = mv88e6185_phylink_validate,
> @@ -3453,6 +3560,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6352_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
> @@ -3538,6 +3647,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
> @@ -3587,6 +3698,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
> @@ -3635,6 +3748,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
> @@ -3686,6 +3801,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6352_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
> @@ -3777,6 +3894,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
> @@ -3963,6 +4082,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.phylink_validate = mv88e6185_phylink_validate,
> @@ -4003,6 +4124,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
>  	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.avb_ops = &mv88e6352_avb_ops,
> @@ -4049,6 +4172,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6352_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.serdes_get_lane = mv88e6352_serdes_get_lane,
> @@ -4105,6 +4230,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
> @@ -4158,6 +4285,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.atu_get_hash = mv88e6165_g1_atu_get_hash,
> +	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
>  	.serdes_power = mv88e6390_serdes_power,
> @@ -4933,6 +5062,7 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
>  static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
>  	.setup			= mv88e6xxx_setup,
> +	.teardown		= mv88e6xxx_teardown,
>  	.phylink_validate	= mv88e6xxx_validate,
>  	.phylink_mac_link_state	= mv88e6xxx_link_state,
>  	.phylink_mac_config	= mv88e6xxx_mac_config,
> @@ -4975,6 +5105,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.port_txtstamp		= mv88e6xxx_port_txtstamp,
>  	.port_rxtstamp		= mv88e6xxx_port_rxtstamp,
>  	.get_ts_info		= mv88e6xxx_get_ts_info,
> +	.devlink_param_get	= mv88e6xxx_devlink_param_get,
> +	.devlink_param_set	= mv88e6xxx_devlink_param_set,
>  };
>  
>  static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index e9b1a1ac9a8e..52f7726cc099 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -497,6 +497,10 @@ struct mv88e6xxx_ops {
>  	int (*serdes_get_stats)(struct mv88e6xxx_chip *chip,  int port,
>  				uint64_t *data);
>  
> +	/* Address Translation Unit operations */
> +	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
> +	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
> +
>  	/* VLAN Translation Unit operations */
>  	int (*vtu_getnext)(struct mv88e6xxx_chip *chip,
>  			   struct mv88e6xxx_vtu_entry *entry);
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> index 0870fcc8bfc8..9f2af711293b 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -109,6 +109,7 @@
>  /* Offset 0x0A: ATU Control Register */
>  #define MV88E6XXX_G1_ATU_CTL		0x0a
>  #define MV88E6XXX_G1_ATU_CTL_LEARN2ALL	0x0008
> +#define MV88E6161_G1_ATU_CTL_HASH_MASK	0x3
>  
>  /* Offset 0x0B: ATU Operation Register */
>  #define MV88E6XXX_G1_ATU_OP				0x0b
> @@ -318,6 +319,8 @@ int mv88e6xxx_g1_atu_remove(struct mv88e6xxx_chip *chip, u16 fid, int port,
>  			    bool all);
>  int mv88e6xxx_g1_atu_prob_irq_setup(struct mv88e6xxx_chip *chip);
>  void mv88e6xxx_g1_atu_prob_irq_free(struct mv88e6xxx_chip *chip);
> +int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash);
> +int mv88e6165_g1_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash);
>  
>  int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
>  			     struct mv88e6xxx_vtu_entry *entry);
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> index 792a96ef418f..d8a03bbba83c 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -73,6 +73,38 @@ int mv88e6xxx_g1_atu_set_age_time(struct mv88e6xxx_chip *chip,
>  	return 0;
>  }
>  
> +int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
> +{
> +	int err;
> +	u16 val;
> +
> +	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL, &val);
> +	if (err)
> +		return err;
> +
> +	*hash = val & MV88E6161_G1_ATU_CTL_HASH_MASK;
> +
> +	return 0;
> +}
> +
> +int mv88e6165_g1_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash)
> +{
> +	int err;
> +	u16 val;
> +
> +	if (hash & ~MV88E6161_G1_ATU_CTL_HASH_MASK)
> +		return -EINVAL;
> +
> +	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL, &val);
> +	if (err)
> +		return err;
> +
> +	val &= ~MV88E6161_G1_ATU_CTL_HASH_MASK;
> +	val |= hash;
> +
> +	return mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_CTL, val);
> +}
> +
>  /* Offset 0x0B: ATU Operation Register */
>  
>  static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)


Thanks,

	Vivien
