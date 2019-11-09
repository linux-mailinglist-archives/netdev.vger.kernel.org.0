Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D2F614E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfKIUHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:07:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45075 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKIUHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:07:12 -0500
Received: by mail-pg1-f196.google.com with SMTP id w11so6341846pga.12;
        Sat, 09 Nov 2019 12:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Si5s3bzMAQov17yw0CHAsJWQKQgH2VgMPXWm1TaEN1U=;
        b=AyTuV7gwFU9di1Ft7Cm3Nej9pelv5YeSeM00Jp4+7BRg0GM1Ng5sEXHqwhytsBrKPb
         Z0f6I/ZcTBC9BYDl6TGf1fvgDIYWOSbdcVBUCCgJ118IxtovoY5lYZVQwbxH/9C4SXco
         L4BnEGDCvI09GPeY78PN8o0cDfnKON3qwmiwz/mhuPf3jP139wqGfelfO8od6bK6cORL
         NFk0XYnHulRncpcyQt2S8qvWWITH3wOTS/72tiP/ymvArn5TObfcBWuu2tdB+gAq9fIg
         5266Fe/QCmi/endFxkqU3ml1M/OjDgPDGgBBI253RwOIR7yMX3UeP0fYIGVgUHCln551
         yMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=Si5s3bzMAQov17yw0CHAsJWQKQgH2VgMPXWm1TaEN1U=;
        b=R3+qnaQ9joWP17pYQFfwNDGeyypY8EzhM2cMoeQAGEUYEfUhIF+ulgydf19O/ivgVN
         LgWAa6l3qB/Ie6IOQ9t2dlro4pjAlza3n1GHhtdH09NWJppScQrtdedEmSCKdbAhu6PH
         D0S60aFCVLWJVySxZdiry6BQpUhEf1wJRWf3lHyB50mo/8bPJVo3eZ1KdTUDOePpV1o8
         HX8wDmBfk6sB3Z+dHfX4IgI8l7u1RRtztFygerm5ZmOxSOzzxnn0LrHyot9Dmn5wiARf
         ku4o2rkPX0gfyMHD3YpKUm2LvpVUQICk/pqc73ViC0QOOnIPRK2mQCWhVrz07qZ+QFLx
         KJlA==
X-Gm-Message-State: APjAAAUGiVIIi9LHP5GAJgz3gRY6jFwt1ZcR2PjA5m8AeOf3glRunOkT
        tLNXR28KPAxKRbK3dH8CBOna0wqgIjnAZA==
X-Google-Smtp-Source: APXvYqyBex766qRwdKJQacYip8zrQb9MPiAsHBjSlr81yNtYHZ/+xGThD1gZDxpctf5JNF5IkipYbw==
X-Received: by 2002:a62:4dc6:: with SMTP id a189mr20583737pfb.71.1573330031218;
        Sat, 09 Nov 2019 12:07:11 -0800 (PST)
Received: from [192.168.1.104] (c-76-21-111-180.hsd1.ca.comcast.net. [76.21.111.180])
        by smtp.gmail.com with ESMTPSA id e7sm868792pfi.29.2019.11.09.12.07.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 12:07:10 -0800 (PST)
From:   Mark D Rustad <mrustad@gmail.com>
Message-Id: <D62E513D-61C9-424E-93B8-42129CEE5385@gmail.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_D05307C6-4866-43A6-8D11-32A87E41330B";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 1/2] IFC hardware operation layer
Date:   Sat, 9 Nov 2019 12:07:08 -0800
In-Reply-To: <20191108075143-mutt-send-email-mst@kernel.org>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, Dan Daly <dan.daly@intel.com>,
        Cunming Liang <cunming.liang@intel.com>, tiwei.bie@intel.com,
        jason.zeng@intel.com, "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com>
 <1572946660-26265-2-git-send-email-lingshan.zhu@intel.com>
 <20191108075143-mutt-send-email-mst@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_D05307C6-4866-43A6-8D11-32A87E41330B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed

On Tue, Nov 05, 2019 at 05:37:39PM +0800, Zhu Lingshan wrote:
> This commit introduced ifcvf_base layer, which handles hardware
> operations and configurations.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vhost/ifcvf/ifcvf_base.c | 344 +++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/ifcvf/ifcvf_base.h | 132 +++++++++++++++
>  2 files changed, 476 insertions(+)
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
>
> diff --git a/drivers/vhost/ifcvf/ifcvf_base.c  
> b/drivers/vhost/ifcvf/ifcvf_base.c
> new file mode 100644
> index 0000000..0659f41
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_base.c
> @@ -0,0 +1,344 @@

<snip>

> +	while (pos) {
> +		ret = ifcvf_read_config_range(dev, (u32 *)&cap,
> +					      sizeof(cap), pos);
> +
> +		if (ret < 0) {
> +			IFC_ERR(&dev->dev, "Failed to get PCI capability at %x",

Missing a \n on the message.

> +				pos);
> +			break;
> +		}
> +
> +		if (cap.cap_vndr != PCI_CAP_ID_VNDR)
> +			goto next;
> +
> +		IFC_DBG(&dev->dev, "read PCI config: config type: %u, PCI bar: %u,\
> +			 PCI bar offset: %u, PCI config len: %u.\n",

Really do not continue strings in this way. Again, just start the format on  
the second line and let it be as long as it needs to be. Also drop the . on  
the end of the log messages (there are many in this patch).

> +			cap.cfg_type, cap.bar, cap.offset, cap.length);
>
<snip>

> +	hw->lm_cfg = hw->mem_resource[IFCVF_LM_BAR].addr;
> +
> +	IFC_DBG(&dev->dev, "PCI capability mapping: common cfg: %p,\
> +		notify base: %p\n, isr cfg: %p, device cfg: %p,\
> +		multiplier: %u\n",

Another continued long format string to go onto one line.

> +		hw->common_cfg, hw->notify_base, hw->isr,
> +		hw->net_cfg, hw->notify_off_multiplier);
> +
> +	return 0;
> +}
> +
> +u8 ifcvf_get_status(struct ifcvf_hw *hw)
> +{
> +	u8 old_gen, new_gen, status;
> +
> +	do {
> +		old_gen = ioread8(&hw->common_cfg->config_generation);
> +		status = ioread8(&hw->common_cfg->device_status);
> +		new_gen = ioread8(&hw->common_cfg->config_generation);
> +	} while (old_gen != new_gen);
> +
> +	return status;
> +}
> +
> +void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
> +{
> +	iowrite8(status, &hw->common_cfg->device_status);
> +}
> +
> +void ifcvf_reset(struct ifcvf_hw *hw)
> +{
> +	ifcvf_set_status(hw, 0);
> +	ifcvf_get_status(hw);
> +}
> +
> +static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
> +{
> +	if (status != 0)
> +		status |= ifcvf_get_status(hw);
> +
> +	ifcvf_set_status(hw, status);
> +	ifcvf_get_status(hw);
> +}
> +
> +u64 ifcvf_get_features(struct ifcvf_hw *hw)
> +{
> +	struct virtio_pci_common_cfg *cfg = hw->common_cfg;
> +	u32 features_lo, features_hi;
> +
> +	iowrite32(0, &cfg->device_feature_select);
> +	features_lo = ioread32(&cfg->device_feature);
> +
> +	iowrite32(1, &cfg->device_feature_select);
> +	features_hi = ioread32(&cfg->device_feature);
> +
> +	return ((u64)features_hi << 32) | features_lo;
> +}
> +
> +void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
> +		       void *dst, int length)
> +{
> +	u8 old_gen, new_gen, *p;
> +	int i;
> +
> +	WARN_ON(offset + length > sizeof (struct ifcvf_net_config));
> +
> +	do {
> +		old_gen = ioread8(&hw->common_cfg->config_generation);
> +		p = dst;
> +
> +		for (i = 0; i < length; i++)
> +			*p++ = ioread8((u8 *)hw->net_cfg + offset + i);
> +
> +		new_gen = ioread8(&hw->common_cfg->config_generation);
> +	} while (old_gen != new_gen);
> +}
> +
> +void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
> +			    const void *src, int length)
> +{
> +	const u8 *p;
> +	int i;
> +
> +	p = src;
> +	WARN_ON(offset + length > sizeof (struct ifcvf_net_config));

No space after sizeof.

<snip>

--
Mark Rustad, MRustad@gmail.com

--Apple-Mail=_D05307C6-4866-43A6-8D11-32A87E41330B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEE6ug8b0Wg+ULmnksNPA7/547j7m4FAl3HHGwACgkQPA7/547j
7m4vbBAAifgyhEVdnk6lvhD95nXr36li03urFfMnvOtnb8TJb/AGxYPbucYufNAR
UZyHcufBLKvALLksE3YELMAMaS3LVHCAlmRAbpMWk6i05TswKJAk0ujgnUA7RALT
fA4E32jTaFNmpoY44bFM6ShiLGrnqLq+l0nLBCF4dmVCpd0ksB1BTZ+bEMCTr+/P
ZxYaHhZCIv6gdos3RvmA7oyTdhLKq3yVvTWhI1vRtWv467jSj2Is22Cw4qqcKqnk
RY/wLhWaqxZSS8uTkhW1tkqKgflK3oB+cmYEJn+LJ7wAyOnzLpP33upYVzinzGAz
HmlDtKIvvXoBP7Az0jn+AP+NFxdcR7STmEe78U3s1nOioc0mWk/jwyQaWfep/kTO
kXQAU24YRjxhv/HNQu7mTYMp/Gx88DJi/M/rHYBwiwcfesSmnw15vEBtCkjQcorj
0ftN4VDMFrVXwJ2rA0VorWO1vCw2h15F+o2iVPVkgThBuu53P/ers4/tLyO+ZCIL
xYoDgbL4/qpesgWWxZ+w304YB5/DNCtgOKlzbH9N99AqotkLWYnLu6W6Y3BbXlmT
JNAxkpbE8W7KnhKuPYboKK5QDkBYZvjDtvJfhTAinS4Zv/PTdXh3E5a4YO42zr3m
MAaa8z2TyTQ2VuXE2x2OaS9MnfSHLr0dKQUEep9+ha7Z7E43Vc0=
=Mpwh
-----END PGP SIGNATURE-----

--Apple-Mail=_D05307C6-4866-43A6-8D11-32A87E41330B--
