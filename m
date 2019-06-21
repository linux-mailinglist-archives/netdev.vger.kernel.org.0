Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63B34DF15
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 04:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfFUCYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 22:24:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36049 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfFUCYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 22:24:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so2745717pfl.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 19:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j742XT/o2uvpO3PqzF2hBPUA5pJAmTLZ11CBd0XOfzY=;
        b=TYeSu4k7/0uQAPtEMEgpg0u41JW6LU9/QmlTRf/WAt7mYb3C9Oua3ON88XI5nacicC
         f7+V4JrZTlh1IONeh1e4MX2zilaCeH8Hdr1YGaCsyD4l0/yOVBvrnivP9SCfefL/9RCm
         0/oXiap/xT5DKUB1eTJBZOxuGbUTrkP03+Fbw+JILfnss8xEVgvx2FR/ED7MSAqH8Fun
         ayypf+aEqW7vCpK5c1DTqqZa1CZgki8I5KJWzExFXXZUuVyTe0WdB+vTvBQ35OxRbl56
         BbZulkzVyk1JPqz4L7qzHXmbnP8hbYtBj7rZycflAK5ScrGrYsh4lYFui0M3CCmIW5xF
         zthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j742XT/o2uvpO3PqzF2hBPUA5pJAmTLZ11CBd0XOfzY=;
        b=MZExm0C0x4w1m2SQUdQkNTO6Q/394bzfuJ3Ib/dGzbxErhTQF3AFFXSCkCP/woW16I
         EajgtHW/2kEOJtV5J0+MuQqmW9a9w5ccodVWUH1G8d6DUdxbVHNeFJa1Y00oVk+ndkho
         tqkUn7WdjUIFafbVMjJjN6XYrkIP09jNj5zxid5WDPEww0JYXGBxJQTRu+ii19GzxXPx
         wV+O7tiwTW+8JOfV1fmuvKKmANFixjJpiJjCVbSBHiT8+L8OfWtcwqSS/IsRLl44U7xK
         dWhchcFrN6j9dd8tchqp2XkizKma/9cOgcNtD+IMPUT7IijRO3/d9P58Zg2TACnkO0kc
         Tt+A==
X-Gm-Message-State: APjAAAWP0DKTTx5qCri8x2gt8D+OgoQy3W4ScWVnxj2wdiJgHWX4Habm
        lXccjSjMZ4Wdx6oG+VuRIAA=
X-Google-Smtp-Source: APXvYqx5nOXn4rk08C+ew6h+JUiGIG7j5y1X2wn8KsDc10USDEms8wbzcWhWsMloP8hbdCSLPFM/3A==
X-Received: by 2002:a63:1d5:: with SMTP id 204mr16217984pgb.207.1561083890844;
        Thu, 20 Jun 2019 19:24:50 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id a12sm1102518pje.3.2019.06.20.19.24.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 19:24:50 -0700 (PDT)
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        idosch@mellanox.com, Jiri Pirko <jiri@resnulli.us>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, davem@davemloft.net
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
Date:   Thu, 20 Jun 2019 19:24:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190620235639.24102-1-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/20/2019 4:56 PM, Vivien Didelot wrote:
> This patch adds support for enabling or disabling the flooding of
> unknown multicast traffic on the CPU ports, depending on the value
> of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute.
> 
> This allows the user to prevent the CPU to be flooded with a lot of
> undesirable traffic that the network stack needs to filter in software.
> 
> The bridge has multicast snooping enabled by default, hence CPU ports
> aren't bottlenecked with arbitrary network applications anymore.
> But this can be an issue in some scenarios such as pinging the bridge's
> IPv6 address. Setting /sys/class/net/br0/bridge/multicast_snooping to
> 0 would restore unknown multicast flooding and thus fix ICMPv6. As
> an alternative, enabling multicast_querier would program the bridge
> address into the switch.
From what I can read from mlxsw, we should probably also implement the
SWITCHDEV_ATTR_ID_PORT_MROUTER attribute in order to be consistent.

Since the attribute MC_DISABLED is on the bridge master, we should also
iterate over the list of switch ports being a member of that bridge and
change their flooding attribute, taking into account whether
BR_MCAST_FLOOD is set on that particular port or not. Just paraphrasing
what mlxsw does here again...

Once you act on the user-facing ports, you might be able to leave the
CPU port flooding unconditionally, since it would only "flood" the CPU
port either because an user-facing port has BR_MCAST_FLOOD set, or
because this is known MC traffic that got programmed via the bridge's
MDB. Would that work?

On a higher level, I really wish we did not have to re-implement a lot
of identical or similar logic in each switch drivers and had a more
central model of what is behaviorally expected.

[snip]

> +int dsa_port_bridge_mc_disabled(const struct dsa_port *dp, bool mc_disabled,
> +				struct switchdev_trans *trans)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int port = dp->index;
> +
> +	if (switchdev_trans_ph_prepare(trans)) {
> +		if (!ds->ops->port_egress_floods)
> +			return -EOPNOTSUPP;
> +
> +		return 0;
> +	}
> +
> +	/* When multicast snooping is disabled,
> +	 * every multicast packet should be flooded to the CPU port.
> +         */

The comment alignment is a bit off.
-- 
Florian
