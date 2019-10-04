Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB6CBDCD
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389176AbfJDOrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:47:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33223 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388870AbfJDOrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:47:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id r5so8945811qtd.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 07:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=s4y5wtlEyd2oMP9WTjwTUlNjmjHaZBKzycyijDa/ORs=;
        b=oio1guMX2vOOtD8Nz9onXIJynOp3hXwXVPA3E0bBIP/RIh1UKA/aj6IoZusMo1UIWF
         zleOkYbBrNvhIdYVRIRKQWNM3szbFRkJiKIbuC53xAmZuYKZ9rbSPPFUNTkJOUduOJPn
         yq0bDUYXla9YbQ/Bzyj+vaIIdnPWfUCAKrX37F+g8JOv5FHDhAYiLfP+ROCW15STXdtH
         ANNWCOUuP7Xn92WePFB5jotT7IPHwCZg7DAisq7mkdBwNRmDHA26TsRPUmrqUskP87kO
         cYjbuCM3+3G+rdYCjzuRJgh163iZDFvl5ouW+HgRyTU6PVkWwy+M1+XEojvC1PRjI2ZP
         JRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=s4y5wtlEyd2oMP9WTjwTUlNjmjHaZBKzycyijDa/ORs=;
        b=VOljYtHGr6I2+nQppKzaYWKiElGf9HAOK8AkmC7y5o9om6G8DX82yR1zgy79DA/v2A
         0uJAo0PdS3y0kBhSlTFOk5PpPLc1aO/iZJiMiOZ4XUadFmUDgjtYe4I/b03Ga/herU9E
         tkIi4/0lXzdHAkOJGKb/+dhzYBUV2urUv/6Iqt1HmaSiy1Pr3PvYC+xjnrgnV1MBF2lS
         Nfw+W2x2IWFhSrxInFOMPgYRzZwWyufPYMOkaHMJIQj546uY9WddJLAEB1Gi9VgoCNfg
         DrXqfkN1MGDiIZZAK6Vg1qtUP2DQm/c0m6fMYDbVidFtnW6K3FwNUP9DKAXlkzoiaTzR
         RPKQ==
X-Gm-Message-State: APjAAAXShesYfe6QRn3lwOBQDK1F3/7mJdD56P6eRyRPw5+YkRp808Tq
        9XlEAgOQsqG1eCUBQ8FNhTxAaXQz
X-Google-Smtp-Source: APXvYqyA2D/J9ZM9evhSgqXWnPq7Iw+Rd9am4i6nLNCYokHbQPWaD4D3wroo/qkcKquGUzrDSIv1pA==
X-Received: by 2002:a0c:ca02:: with SMTP id c2mr13970992qvk.209.1570200460855;
        Fri, 04 Oct 2019 07:47:40 -0700 (PDT)
Received: from localhost (modemcable127.163-178-173.mc.videotron.ca. [173.178.163.127])
        by smtp.gmail.com with ESMTPSA id t199sm3040483qke.36.2019.10.04.07.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 07:47:40 -0700 (PDT)
Date:   Fri, 4 Oct 2019 10:47:38 -0400
Message-ID: <20191004104738.GB80061@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Add devlink param for
 ATU hash algorithm.
In-Reply-To: <20191004013523.28306-3-andrew@lunn.ch>
References: <20191004013523.28306-1-andrew@lunn.ch>
 <20191004013523.28306-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri,  4 Oct 2019 03:35:23 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> Some of the marvell switches have bits controlling the hash algorithm
> the ATU uses for MAC addresses. In some industrial settings, where all
> the devices are from the same manufacture, and hence use the same OUI,
> the default hashing algorithm is not optimal. Allow the other
> algorithms to be selected via devlink.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c        | 136 +++++++++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
>  drivers/net/dsa/mv88e6xxx/global1.h     |   3 +
>  drivers/net/dsa/mv88e6xxx/global1_atu.c |  30 ++++++
>  4 files changed, 172 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 6787d560e9e3..ebadcdba03df 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1370,6 +1370,22 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
>  	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
>  }
>  
> +static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip)
> +{
> +	if (chip->info->ops->atu_get_hash)
> +		return chip->info->ops->atu_get_hash(chip);
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
> @@ -2641,6 +2657,83 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
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
> +	int err = 0;
> +	int hash;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	switch (id) {
> +	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
> +		hash = mv88e6xxx_atu_get_hash(chip);
> +		if (hash < 0) {
> +			err = hash;
> +			break;
> +		}

Could you please keep the common construct used in the driver for
functions which may fail, that is to say using a pointer to the correct
type and only returning error codes, so that we end up with something
like this:

    u8 hash;
    int err;

    err = mv88e6xxx_atu_get_hash(chip, &hash);
    if (err)
        ...


Thanks,

	Vivien
