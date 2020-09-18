Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E6726EEFD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgIRCc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729950AbgIRCc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:32:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49A7C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:32:25 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m15so2176704pls.8
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IdE5LQWCDhgEGZeLr4BG6QGAc/On1YROKBjYNPv9KFk=;
        b=uo+rk6Rdi93m0viefaRuBDJqyOdlgz2Y5FMaXdXv0kc3dhXHHb4h/93g5JKN73ljhW
         w5RRW60hKWD0qyswKGa/dkritY/8dM900LhHDU1ueA0kWgCIE1bBP80woq9+SxFGfOxh
         qQw9bOjvCJFhuQIomNaPH2M2C6Mk7x1wVlQXIwzgXMor/RRwKqAw1vE/leIhTNMYGjgp
         li8Cgau36iAAj9PNzHu4/mgkEz6M9AYYSRknnZBGbdWciM/Nauy6GIKci0o7yRtL/XsR
         ACWE7X6fbYn7tv+aFfrnwYNnL0iT6mhnF/unzp8/VRKm/jtvoUjdc0ciWmeabkrZPBaM
         qC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IdE5LQWCDhgEGZeLr4BG6QGAc/On1YROKBjYNPv9KFk=;
        b=Zxguqhzg5w99y4GJHJshIySsDqmccJf/glAEe4neFNLMHHfjpiLCRqYUglCN1/T6Bb
         gw2UQ8Z2pznCs5mdsR2lclzptHWSGirIXBsLIEH1EoF0GhB094Mzl0SW1rR7Etmz2K18
         npIcidfKNdRhS9UR6clKqsBxv19XHJEAZlM2FdU3/d9jSWYu0qtNeIHjg9x0HDP9VwhL
         kizwZXSPIscn1b8lphTZjlOvoLcNkaKq3MeCvxaldYqLbW/0X3LHF74o/hzkiod9fj2J
         jT3k2LFckWPP8/OJEwxiNroQqqp3DOhGW7hdTDlJt7t8an7obEDFGBrRH5lEYf+MDO4A
         Cbxg==
X-Gm-Message-State: AOAM5334KVfxNvtjRV/V9cYTRVYEvUDdCmug7FBVZqT/7Hm2aUP1H9gK
        fSf0893hREO1Lm7FrHKbddo=
X-Google-Smtp-Source: ABdhPJwY8raC2gPCCiVIdVKlBKazfPTaDF8fQLY6xp05IbulUVvWcC/pRIkuJCwLEwvE52MNZxNSwA==
X-Received: by 2002:a17:90a:e207:: with SMTP id a7mr11620072pjz.117.1600396345328;
        Thu, 17 Sep 2020 19:32:25 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm1003429pfk.201.2020.09.17.19.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:32:24 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-8-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 net-next 7/9] net: dsa: mv88e6xxx: Add devlink regions
Message-ID: <f4942b08-3bf8-cdd6-a8b7-61b77c746648@gmail.com>
Date:   Thu, 17 Sep 2020 19:32:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-8-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> Allow the global registers, and the ATU to be snapshot via devlink
> regions. It is later planned to add support for the port registers.
> 
> v2:
> Remove left over debug prints
> Comment ATU format is generic for mv88e6xxx, not wider
> 
> v3:
> Make use of ops structure passed to snapshot function
> Remove port regions
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

[snip]

> +static int mv88e6xxx_region_global_snapshot(struct devlink *dl,
> +					    const struct devlink_region_ops *ops,
> +					    struct netlink_ext_ack *extack,
> +					    u8 **data)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	u16 *registers;
> +	int i, err;
> +
> +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i = 0; i < 32; i++) {
> +		switch ((long)ops->priv) {
> +		case 1:
> +			err = mv88e6xxx_g1_read(chip, i, &registers[i]);
> +			break;
> +		case 2:
> +			err = mv88e6xxx_g1_read(chip, i, &registers[i]);

Should this be mv88e6xxx_g2_read() here? Can you use the region IDs you 
defined above?

> +			break;
> +		default:
> +			err = -EOPNOTSUPP;
> +		}
> +
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +/* The ATU entry varies between mv88e6xxx chipset generations. Define
> + * a generic format which covers all the current and hopefully future
> + * mv88e6xxx generations
> + */
> +
> +struct mv88e6xxx_devlink_atu_entry {
> +	/* The FID is scattered over multiple registers. */
> +	u16 fid;
> +	u16 atu_op;
> +	u16 atu_data;
> +	u16 atu_01;
> +	u16 atu_23;
> +	u16 atu_45;
> +};
> +
> +static int mv88e6xxx_region_atu_snapshot_fid(struct mv88e6xxx_chip *chip,
> +					     int fid,
> +					     struct mv88e6xxx_devlink_atu_entry *table,
> +					     int *count)
> +{
> +	u16 atu_op, atu_data, atu_01, atu_23, atu_45;
> +	struct mv88e6xxx_atu_entry addr;
> +	int err;
> +
> +	addr.state = 0;
> +	eth_broadcast_addr(addr.mac);
> +
> +	do {
> +		err = mv88e6xxx_g1_atu_getnext(chip, fid, &addr);
> +		if (err)
> +			return err;
> +
> +		if (!addr.state)
> +			break;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &atu_op);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_DATA, &atu_data);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC01, &atu_01);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC23, &atu_23);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC45, &atu_45);
> +		if (err)
> +			return err;
> +
> +		table[*count].fid = fid;
> +		table[*count].atu_op = atu_op;
> +		table[*count].atu_data = atu_data;
> +		table[*count].atu_01 = atu_01;
> +		table[*count].atu_23 = atu_23;
> +		table[*count].atu_45 = atu_45;

Can you refactor this to use a for/while loop?


> +		(*count)++;
> +	} while (!is_broadcast_ether_addr(addr.mac));
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
> +					 const struct devlink_region_ops *ops,
> +					 struct netlink_ext_ack *extack,
> +					 u8 **data)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	DECLARE_BITMAP(fid_bitmap, MV88E6XXX_N_FID);
> +	struct mv88e6xxx_devlink_atu_entry *table;
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int fid = -1, count, err;
> +
> +	table = kmalloc_array(mv88e6xxx_num_databases(chip),
> +			      sizeof(struct mv88e6xxx_devlink_atu_entry),
> +			      GFP_KERNEL);
> +	if (!table)
> +		return -ENOMEM;
> +
> +	memset(table, 0, mv88e6xxx_num_databases(chip) *
> +	       sizeof(struct mv88e6xxx_devlink_atu_entry));
> +
> +	count = 0;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	err = mv88e6xxx_fid_map(chip, fid_bitmap);
> +	if (err)
> +		goto out;
> +
> +	while (1) {
> +		fid = find_next_bit(fid_bitmap, MV88E6XXX_N_FID, fid + 1);
> +		if (fid == MV88E6XXX_N_FID)
> +			break;
> +
> +		err =  mv88e6xxx_region_atu_snapshot_fid(chip, fid, table,
> +							 &count);
> +		if (err) {
> +			kfree(table);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)table;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +static struct devlink_region_ops mv88e6xxx_region_global1_ops = {
> +	.name = "global1",
> +	.snapshot = mv88e6xxx_region_global_snapshot,
> +	.destructor = kfree,
> +	.priv = (void *)1,

Can you use the region IDs you defined?
-- 
Florian
