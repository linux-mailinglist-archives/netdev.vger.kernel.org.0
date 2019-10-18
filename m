Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578F9DBD8A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 08:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407410AbfJRGLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 02:11:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34190 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407177AbfJRGLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 02:11:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id j11so4855571wrp.1
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 23:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7fioqtGhiAfkkgTzVRfYVTVnaEIvFcIXuwyzsXwNU7Y=;
        b=VIfwsjdkCjta0+/YMBtSttccfL3OroFY69SlwKkq+iKotwASyZ8kIbtlfnyYmexQ/Z
         iVGbAUDU3WjuBTUDCDrwuapWtBV9JweunIuuJX8N+3lXmm4lmIxvNVTSx9IRRCEorO1b
         pEIKafQwx2Ee7ITuTcl8+1boJITNSNi0rE3JJ+D6Y//b4kL9e1SoJuLs907S9Qz2PPdn
         ex3Dux5vdtOAy1n+u4ARfd7kx06nyx9VNq4PpWd15bKNNxfB2b0GZTgohpdF4q/WJkQp
         9jUtBwifRAztgIvRsIAsGo9OaQz2/54GxMgQNxd746TEJAdYq6EHoOGNVC8Y7F5Txpls
         N/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7fioqtGhiAfkkgTzVRfYVTVnaEIvFcIXuwyzsXwNU7Y=;
        b=bYIQZi3cIjBXgyAo7x/MUmwyEFOGQ9UWRuMIgSnY25tATmTJFAtcufg50VLjNgNfZ4
         e2RH5DoP9sXcAoipp40d3NAZv6bcHBjW4MX2qq1L2feK4WapZvnjzVZfNtXaJOtxxT9Y
         H3J0dyLdd2at+cVEpRDeZV353PcwhE0pkBsUNvCxeIegjwTbL2eN2o+WNLDU32kAoK7b
         kk/HI+W5Ea4RC14QnftsNez9o4CBKNkgqht5xyUhp3UD5ADerMvW6064tdIBdyadwXA/
         QUe4wVjrRgwteBsmMfneX9C2fDwTdVIGqP1xbqNzwyneROXV7BoVl5AWyVCUcuKz5QCK
         8GAA==
X-Gm-Message-State: APjAAAW4yzTUUi8K2HkB/g6Oyov/Pz/qB4GZx2a3PtYX36MDY+6q2STx
        Qv2X9iVNMFwDS9n5yNrV5E//UA==
X-Google-Smtp-Source: APXvYqx8DJDZSp9q+9wlt2eL0rJ1ZrrkwbIlxFZD3jO4MJCX8H0W5NPzxikJAP68zzejq/2wlzF5PQ==
X-Received: by 2002:a5d:46ca:: with SMTP id g10mr6348698wrs.193.1571379074115;
        Thu, 17 Oct 2019 23:11:14 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z9sm5102253wrl.35.2019.10.17.23.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 23:11:13 -0700 (PDT)
Date:   Fri, 18 Oct 2019 08:11:13 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191018061113.GD2185@nanopsycho>
References: <20191017192055.23770-1-andrew@lunn.ch>
 <20191017192055.23770-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017192055.23770-3-andrew@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 17, 2019 at 09:20:55PM CEST, andrew@lunn.ch wrote:
>Some of the marvell switches have bits controlling the hash algorithm

s/marvell/Marvell/


>the ATU uses for MAC addresses. In some industrial settings, where all
>the devices are from the same manufacture, and hence use the same OUI,
>the default hashing algorithm is not optimal. Allow the other
>algorithms to be selected via devlink.

s/via devlink/via devlink parameter/


>
>Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>---
> .../networking/devlink-params-mv88e6xxx.txt   |   7 +
> MAINTAINERS                                   |   1 +
> drivers/net/dsa/mv88e6xxx/chip.c              | 131 +++++++++++++++++-
> drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
> drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
> drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
> 6 files changed, 177 insertions(+), 1 deletion(-)
> create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt
>
>diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink-params-mv88e6xxx.txt
>new file mode 100644
>index 000000000000..9a515b438688
>--- /dev/null
>+++ b/Documentation/networking/devlink-params-mv88e6xxx.txt
>@@ -0,0 +1,7 @@
>+ATU_hash		[DEVICE, DRIVER-SPECIFIC]
>+			Select one of four possible hashing algorithms for
>+			MAC addresses in the Address Translation Unity.
>+			A value of 3 seems to work better than the default of
>+			1 when many MAC addresses have the same OUI.
>+			Configuration mode: runtime
>+			Type: u8. 0-3 valid.
>diff --git a/MAINTAINERS b/MAINTAINERS
>index b431e6d5f43f..ab1f6dd876a9 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -9740,6 +9740,7 @@ S:	Maintained
> F:	drivers/net/dsa/mv88e6xxx/
> F:	include/linux/platform_data/mv88e6xxx.h
> F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
>+F:	Documentation/networking/devlink-params-mv88e6xxx.txt
> 
> MARVELL ARMADA DRM SUPPORT
> M:	Russell King <linux@armlinux.org.uk>
>diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>index 6787d560e9e3..404f6fc97e4c 100644
>--- a/drivers/net/dsa/mv88e6xxx/chip.c
>+++ b/drivers/net/dsa/mv88e6xxx/chip.c
>@@ -1370,6 +1370,22 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
> 	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
> }
> 
>+static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
>+{
>+	if (chip->info->ops->atu_get_hash)
>+		return chip->info->ops->atu_get_hash(chip, hash);
>+
>+	return -EOPNOTSUPP;
>+}
>+
>+static int mv88e6xxx_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash)
>+{
>+	if (chip->info->ops->atu_set_hash)
>+		return chip->info->ops->atu_set_hash(chip, hash);
>+
>+	return -EOPNOTSUPP;
>+}
>+
> static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
> 					u16 vid_begin, u16 vid_end)
> {
>@@ -2641,6 +2657,78 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
> 	return mv88e6xxx_software_reset(chip);
> }
> 
>+enum mv88e6xxx_devlink_param_id {
>+	MV88E6XXX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
>+	MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
>+};
>+
>+static int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
>+				       struct devlink_param_gset_ctx *ctx)
>+{
>+	struct mv88e6xxx_chip *chip = ds->priv;
>+	int err;
>+
>+	mv88e6xxx_reg_lock(chip);
>+
>+	switch (id) {
>+	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
>+		err = mv88e6xxx_atu_get_hash(chip, &ctx->val.vu8);
>+		break;
>+	default:
>+		err = -EOPNOTSUPP;
>+		break;
>+	}
>+
>+	mv88e6xxx_reg_unlock(chip);
>+
>+	return err;
>+}
>+
>+static int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
>+				       struct devlink_param_gset_ctx *ctx)
>+{
>+	struct mv88e6xxx_chip *chip = ds->priv;
>+	int err;
>+
>+	mv88e6xxx_reg_lock(chip);
>+
>+	switch (id) {
>+	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
>+		err = mv88e6xxx_atu_set_hash(chip, ctx->val.vu8);
>+		break;
>+	default:
	
WARN_ON could be here, this should never happen.


>+		err = -EOPNOTSUPP;
>+		break;
>+	}
>+
>+	mv88e6xxx_reg_unlock(chip);
>+
>+	return err;
>+}
>+
>+static const struct devlink_param mv88e6xxx_devlink_params[] = {
>+	DSA_DEVLINK_PARAM_DRIVER(MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
>+				 "ATU_hash", DEVLINK_PARAM_TYPE_U8,

Can't this be lowercase please?
"atu_hash".



>+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
>+};
>+
>+static int mv88e6xxx_setup_devlink_params(struct dsa_switch *ds)
>+{
>+	return dsa_devlink_params_register(ds, mv88e6xxx_devlink_params,
>+					   ARRAY_SIZE(mv88e6xxx_devlink_params));
>+}
>+
>+static void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds)
>+{
>+	dsa_devlink_params_unregister(ds, mv88e6xxx_devlink_params,
>+				      ARRAY_SIZE(mv88e6xxx_devlink_params));
>+}
>+
>+static void mv88e6xxx_teardown(struct dsa_switch *ds)
>+{
>+	mv88e6xxx_teardown_devlink_params(ds);
>+}
>+

[...]
