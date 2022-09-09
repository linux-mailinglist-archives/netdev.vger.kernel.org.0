Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A500A5B2F1C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiIIGhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiIIGhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:37:22 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7509629CA8
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:37:20 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id v6so733553ljj.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 23:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Bg5ocaBDMZXz/y7RnNvSFBqHjizpljxLfV+YvLj5BGw=;
        b=dpbyWKFRVu3askZCcK7/focid7gElm/kpCBOwwkM5O96sHdn+La6XDfB56HfyU5LQQ
         RHaq1TQp6Im3my2GLVc0WZGICIlvPxsdXhsj5GhwcsQu9bBF7kAnKmFxhm+Gnq0RxXf2
         NfSqQ9beaMhYaOordOndJuFyMkv0NBku65SDgv7RXiIQgRS3VvpqdJGb7KzjfNqYYLFv
         nOtJJWnlB6mMC3O2zOmTog+k0hvRGP5qolcfehfgsPWfv/jlW8tArYbkyFv1zi2DLgPO
         9jisIcmuKkzkQWhAtozckd+oE6LcVhPb5Axi8j+Dkuagxj7Q0FKiYu4WtgQJHswJ1fRj
         ITjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Bg5ocaBDMZXz/y7RnNvSFBqHjizpljxLfV+YvLj5BGw=;
        b=OnnPCDT/y8T1BGZeMsc4O1OJ1Hd7NcLSqi82YEfv1WBShq2p8SG+z+sWbnLAp7pMfL
         YrDSSm2g4yQ+jtpgIgFBqixgZBLU1Lmt+SD8yryBvNSIVb2/9whAxxD4e5W/vC+hvPOT
         T3Tb+CNGsbQ6ASXvR0Ima17AOxhNNX7T3Dz09X5kPkoUIX0N2uI3fNaGlY1MtowtU7jp
         kZhyxQYb5JKzZQH3Zgjtdtx/ZWOcnyQoA165P2K3bInotnr+94lEVDFZyPuHypRmC/CX
         3DnQk+MAuvhAjatQDsEj51AueaXf8cjGXd3idQVzcamBaOwwG1mnJyblPWLmnvON8DzI
         ACyA==
X-Gm-Message-State: ACgBeo2hsgaUIucGymxLScmazVOebW/CuuvUbrnbLpwBFpbEGFKJrKj1
        2n6DVLGI5QSWplA/yJ2B0Ss=
X-Google-Smtp-Source: AA6agR4KPCCbcmCEnz9onpYC3ztpRjL6OvFsDL/euun6b8SfSSRZ/gRXACd9W+zxz80QZ8sjhC4lTQ==
X-Received: by 2002:a2e:681a:0:b0:26b:e56c:ef7 with SMTP id c26-20020a2e681a000000b0026be56c0ef7mr318744lja.528.1662705438707;
        Thu, 08 Sep 2022 23:37:18 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id o16-20020a05651205d000b00497ad8e6d07sm138318lfo.222.2022.09.08.23.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 23:37:18 -0700 (PDT)
Message-ID: <0121f604-e8b9-2551-7881-c1fd64c434e2@gmail.com>
Date:   Fri, 9 Sep 2022 08:37:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v7 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-5-mattias.forsblad@gmail.com>
 <YxqYjoZeGhYIZ29b@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <YxqYjoZeGhYIZ29b@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-09 03:36, Andrew Lunn wrote:
>> +	kfree_skb(chip->rmu.resp);
>> +	chip->rmu.resp = NULL;
>> +
>> +	mutex_unlock(&chip->rmu.mutex);
>> +
>> +	return ret > 0 ? 0 : ret;
>> +}
>> +
>> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
>> +{
>> +	const u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_GET_ID,
>> +			     MV88E6XXX_RMU_REQ_PAD,
>> +			     MV88E6XXX_RMU_REQ_CODE_GET_ID,
>> +			     MV88E6XXX_RMU_REQ_DATA};
>> +	struct rmu_header resp;
>> +	int ret = -1;
>> +	u16 format;
>> +	u16 code;
>> +
>> +	ret = mv88e6xxx_rmu_send_wait(chip, port, (const char *)req, sizeof(req),
>> +				      (char *)&resp, sizeof(resp));
>> +	if (ret) {
>> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
>> +		return ret;
>> +	}
>> +
>> +	/* Got response */
>> +	format = get_unaligned_be16(&resp.format);
>> +	code = get_unaligned_be16(&resp.code);
> 
> You don't need get_unaligned_be16() etc here, because resp is a stack
> variable, it is guaranteed to be aligned. You only need to use these
> helpers when you have no idea about alignment, like data in an skb.
>

So this I don't understand. We map a packed struct from incoming skb data
(which could be unaligned). Couldn't the struct members then be unaligned
also?
 
>> +
>> +	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
>> +	    format != MV88E6XXX_RMU_RESP_FORMAT_2 &&
>> +	    code != MV88E6XXX_RMU_RESP_CODE_GOT_ID) {
>> +		net_dbg_ratelimited("RMU: received unknown format 0x%04x code 0x%04x",
>> +				    format, code);
>> +		return -EIO;
>> +	}
>> +
>> +	chip->rmu.prodnr = get_unaligned_be16(&resp.prodnr);
>> +
>> +	return 0;
>> +}
>> +
>> +static void mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
> 
> I would split this into a separate patch. Add the core RMU handling in
> one patch, and then add users of it one patch at a time. There is too
> much going on in this patch, and it is not obviously correct.
> 

Yes, this should be in the patch 5

>> +{
>> +	u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_SOHO,
>> +		       MV88E6XXX_RMU_REQ_PAD,
>> +		       MV88E6XXX_RMU_REQ_CODE_DUMP_MIB,
>> +		       MV88E6XXX_RMU_REQ_DATA};
>> +	struct dump_mib_resp resp;
>> +	struct mv88e6xxx_port *p;
>> +	u8 resp_port;
>> +	u16 format;
>> +	u16 code;
>> +	int ret;
>> +	int i;
>> +
>> +	/* Populate port number in request */
>> +	req[3] = FIELD_PREP(MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK, port);
>> +
>> +	ret = mv88e6xxx_rmu_send_wait(chip, port, (const char *)req, sizeof(req),
>> +				      (char *)&resp, sizeof(resp));
>> +	if (ret) {
>> +		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
>> +			ERR_PTR(ret), port);
>> +		return;
>> +	}
> 
> I'm surprised this is a void function, since mv88e6xxx_rmu_send_wait()
> etc can return an error.
> 

This is because the caller prototype is declared thus:
 	void	(*get_ethtool_stats)(struct dsa_switch *ds,
				     int port, uint64_t *data);


>> +	for (i = 0; i < MV88E6XXX_RMU_MAX_RMON; i++)
>> +		p->rmu_raw_stats[i] = get_unaligned_be32(&resp.mib[i]);
>> +
>> +	/* Update MIB for port */
>> +	if (chip->info->ops->stats_get_stats)
>> +		chip->info->ops->stats_get_stats(chip, port, data);
>> +}
>> +
>> +void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
>> +			     bool operational)
>> +{
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	struct dsa_port *cpu_dp;
>> +	int port;
>> +	int ret;
>> +
>> +	cpu_dp = master->dsa_ptr;
>> +	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
>> +
>> +	mv88e6xxx_reg_lock(chip);
>> +
>> +	if (operational && chip->info->ops->rmu_enable) {
>> +		if (!chip->info->ops->rmu_enable(chip, port)) {
> 
> You should probably differentiate on the error here. -EOPNOTSUPP you
> want to handle different to other errors, which are fatal.
> 

Will fix.

>> +			dev_dbg(chip->dev, "RMU: Enabled on port %d", port);
>> +			chip->rmu.master_netdev = (struct net_device *)master;
>> +
>> +			/* Check if chip is alive */
>> +			ret = mv88e6xxx_rmu_get_id(chip, port);
>> +			if (!ret)
>> +				goto out;
>> +
>> +			chip->smi_ops = chip->rmu.rmu_ops;
>> +
>> +		} else {
>> +			dev_err(chip->dev, "RMU: Unable to enable on port %d", port);
> 
> Don't you need a goto out; here?
> 

Will fix.

>> +		}
>> +	}
>> +
>> +	chip->smi_ops = chip->rmu.smi_ops;
>> +	chip->rmu.master_netdev = NULL;
>> +	if (chip->info->ops->rmu_disable)
>> +		chip->info->ops->rmu_disable(chip);
> 
> I would probably pull this function apart, break it up into helpers,
> to make the flow simpler.
> 

Ok, will fix.

>> +
>> +out:
>> +	mv88e6xxx_reg_unlock(chip);
>> +}
>> +
>> +static int mv88e6xxx_validate_mac(struct dsa_switch *ds, struct sk_buff *skb)
>> +{
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	unsigned char *ethhdr;
>> +
>> +	/* Check matching MAC */
>> +	ethhdr = skb_mac_header(skb);
>> +	if (!ether_addr_equal(chip->rmu.master_netdev->dev_addr, ethhdr)) {
>> +		dev_dbg_ratelimited(ds->dev, "RMU: mismatching MAC address for request. Rx %pM expecting %pM\n",
>> +				    ethhdr, chip->rmu.master_netdev->dev_addr);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
>> +{
>> +	struct dsa_port *dp = dev->dsa_ptr;
>> +	struct dsa_switch *ds = dp->ds;
>> +	struct mv88e6xxx_chip *chip;
>> +	int source_device;
>> +	u8 *dsa_header;
>> +	u8 seqno;
>> +
>> +	/* Decode Frame2Reg DSA portion */
>> +	dsa_header = skb->data - 2;
>> +
>> +	source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
>> +	ds = dsa_switch_find(ds->dst->index, source_device);
>> +	if (!ds) {
>> +		net_err_ratelimited("RMU: Didn't find switch with index %d", source_device);
>> +		return;
>> +	}
>> +
>> +	if (mv88e6xxx_validate_mac(ds, skb))
>> +		return;
>> +
>> +	chip = ds->priv;
>> +	seqno = dsa_header[3];
>> +	if (seqno != chip->rmu.seqno) {
>> +		net_err_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
>> +				    seqno, chip->rmu.seqno);
>> +		return;
>> +	}
>> +
>> +	/* Pull DSA L2 data */
>> +	skb_pull(skb, MV88E6XXX_DSA_HLEN);
>> +
>> +	/* Make an copy for further processing in initiator */
>> +	chip->rmu.resp = skb_copy(skb, GFP_ATOMIC);
>> +	if (!chip->rmu.resp)
>> +		return;
> 
> I think this should be in the other order. First see if there is
> anybody interested in the skb, then make a copy of it.
> 

That's not what it's doing. It's a check that the skb_copy
finished correctly, not that anyone is interested in a reply.
Or did I misinterpret your comment?

>> +
>> +	dsa_switch_inband_complete(ds, NULL);
>> +}
>> +
>> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
>> +{
>> +	mutex_init(&chip->rmu.mutex);
>> +
>> +	/* Remember original ops for restore */
>> +	chip->rmu.smi_ops = chip->smi_ops;
>> +
>> +	/* Change rmu ops with our own pointer */
>> +	chip->rmu.rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
> 
> Why do you need a cast? In general, casts are wrong, it suggests your
> types are wrong.
> 
>> +	chip->rmu.rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
>> +
>> +	if (chip->info->ops->rmu_disable)
>> +		return chip->info->ops->rmu_disable(chip);
> 
> Why is a setup function calling disable?
> 

So Vladimir Oltean commented before:
"I think it's very important for the RMU to still start as disabled.
You enable it dynamically when the master goes up."

>     Andrew

