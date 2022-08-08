Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B999158C884
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 14:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbiHHMoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 08:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242767AbiHHMoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 08:44:07 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F238DBF73
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 05:44:05 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b96so11241204edf.0
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=wjjnjFvciY1+o+kUZL5Zaq4vJtWZDjrE8n2gegOZ6HU=;
        b=N/aHLmoXdwpj66yGEnvuwJloSEQ6Ay7aEbjOSDrwes8/JLZgyXuV9Yh9PSNd3gQ6op
         L1TNHs9PjoMRIAhdoYnLXb7C2mlKOXXwTymFEfECc1CKfvr5MA2kMrIlzsZqLArRt5+E
         5/QJ1rKQwx7qCZOMTmsqOy2Ku/WG83lriiYbQHRRQbjD+k68rgxRHJ4WQYzZZtU+55yz
         fUNw5gZY+qsNgRlqqY822EwKUGqQh26yzq6TCx9MVz2Br4KhXirEsa5YrZb6HRgkutRy
         qCp3qaYn2OE8kUQlW6IWYSmpIJ28LrWoqTttAIITzWcqkUdmapyrBu81Lg03PHKbaxZB
         yihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=wjjnjFvciY1+o+kUZL5Zaq4vJtWZDjrE8n2gegOZ6HU=;
        b=Alw2INyc1lY4js28hXwiu6/XgMr2B0SMf6Aa+xRfSe6asfGFcUaXb5bzpZP89q/zM9
         RwvVNTbN59xjR3QNibVzXThtHkVjdtV4DGVZeitxQJGCNU7pCa0x5WrfhgS7iLf0J1NR
         CrvFTinwxh3ILlhSW/rJZvbP3A5dUW20q+lb3d//qQjT1M7vvgnT7fJq2ayUe2xgTexw
         0SsyLogsu6np0j70sxMV65Bxyltmva/gDgMl3tKuQWcOg6k5GpddtAPOKXMDWMKmuu7F
         5B9WXlh5BBcluIrjOYH8Ky/lJrXTjDpt0OiCjKui8VtZ2mKVBhniYhaJPt9G5DAg90OO
         /sDA==
X-Gm-Message-State: ACgBeo3adFXSZmEa677EFMA1snYdu3LhrvBEMYF4A/pnOx/gtcPgH+T+
        uaZZQEgdcJZVFeBJtAna0JCz4USoMxcORNMb
X-Google-Smtp-Source: AA6agR6KQNAvZHEQWP2pezKnZH3wA4PFCt51flm1O6HdWtXGYFwYmV+flVbqSSWZmvGqvsWEHS19gA==
X-Received: by 2002:a05:6402:3546:b0:43e:466c:d4ed with SMTP id f6-20020a056402354600b0043e466cd4edmr18031010edd.48.1659962644374;
        Mon, 08 Aug 2022 05:44:04 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ku10-20020a170907788a00b00726abf9a32bsm4944830ejc.138.2022.08.08.05.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 05:44:04 -0700 (PDT)
Message-ID: <278221fe-e836-9794-374f-0955cc10f8be@blackwall.org>
Date:   Mon, 8 Aug 2022 15:44:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v1] net:bonding:support balance-alb interface with vlan to
 bridge
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220808094107.6150-1-sunshouxin@chinatelecom.cn>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220808094107.6150-1-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/2022 12:41, Sun Shouxin wrote:
> In my test, balance-alb bonding with two slaves eth0 and eth1,
> and then Bond0.150 is created with vlan id attached bond0.
> After adding bond0.150 into one linux bridge, I noted that Bond0,
> bond0.150 and  bridge were assigned to the same MAC as eth0.
> Once bond0.150 receives a packet whose dest IP is bridge's
> and dest MAC is eth1's, the linux bridge cannot process it as expected.
> The patch fix the issue, and diagram as below:
> 
> eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
>                       |
>                    bond0.150(mac:eth0_mac)
>                       |
>                    bridge(ip:br_ip, mac:eth0_mac)--other port
> 
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
>  drivers/net/bonding/bond_alb.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 007d43e46dcb..0dea04f00f12 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -654,6 +654,7 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
>  {
>  	struct slave *tx_slave = NULL;
>  	struct arp_pkt *arp;
> +	struct net_device *dev;

reverse xmas tree order

>  
>  	if (!pskb_network_may_pull(skb, sizeof(*arp)))
>  		return NULL;
> @@ -665,6 +666,13 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
>  	if (!bond_slave_has_mac_rx(bond, arp->mac_src))
>  		return NULL;
>  
> +	dev = ip_dev_find(dev_net(bond->dev), arp->ip_src);
> +	if (dev) {
> +		if (netif_is_bridge_master(dev)) {
> +			return NULL;
> +		}

nit: the {} aren't needed

> +	}
> +
>  	if (arp->op_code == htons(ARPOP_REPLY)) {
>  		/* the arp must be sent on the selected rx channel */
>  		tx_slave = rlb_choose_channel(skb, bond, arp);

Aside from the small cosmetic comments, have you tried adding the second mac address
as permanent in the bridge?
i.e.: 
$ bridge fdb add <eth1_mac> dev bond0.150 master permanent

That should fix your problem without any bonding hacks.

Cheers,
 Nik


