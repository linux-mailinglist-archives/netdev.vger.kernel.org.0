Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA29A13705
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEDCRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:17:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36900 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:17:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id e6so3598015pgc.4;
        Fri, 03 May 2019 19:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FdFkjTtbV9VvfXaga3T7DcZNWEFcPMcBy5xwubcyVd8=;
        b=LuSmqADsT8HEbFCPr60hbUACFBcY9mq7GeHgf9NPz+JbY8/KbwxafwZssgkoo0DbfO
         yMkBaZdmI9xvGFEJgHF2blmBrzAf1PAzoLorVq33taC2y3mzFgvzsMgfFvqi5MPKAqpY
         oT8VN+EUyFZrSrDPn6h3hdvz4BoEhJjM5VS+X/IsZkLML8/y5va/7mwAlC7Z39f5DjcV
         tJ7gEoqnS8r4jbBWRfNBo6AQMVZGarlZqGzEoKG7KG4dfep8LgkpDml7eGjB6ZKM4ZSj
         taMCxoOMyvZRNjvJEb8pfpdGI0MepIjWTjfztfvQGQK/n5ZWZmHIHtuUdc6mUownsuiB
         zlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FdFkjTtbV9VvfXaga3T7DcZNWEFcPMcBy5xwubcyVd8=;
        b=I+9SOWQAiLQ4JUCkNI8WCOwMz6TWd7zgjEdT6cEkMjefzZVqH0psVIkjhWobgZKYsL
         oQhj4XnpzHZJb8m80WV7ADIPu1T+mgMWY8qSh5kOp3gsV87L3uD7QbWAMBqe6A6cU6fa
         P5lyb2vnx/7EtG2o/2jGeEzCOpNnMRVF59Z9JcJZCUI+TLGoGYWewaYVM5ZNTIaR3PKj
         o6snIQp8xUKL158Xx4SFv8PgzeBw66QlVQRaRZz0ANqfA5EfDLSmyUW2qnplgCMgPFV2
         9K9NOim53NHou6sFXJbyOLW+JfaYkjQm2PfXqD0h6zKtwQQEs3BWiNa51chx+iWlzc9y
         3WOQ==
X-Gm-Message-State: APjAAAUYo/CC72epGFJffRsTHu96SAYc/px9btVL0hPc6wcWvxmnBKmL
        Z9dqvYPP9hD2qOURBVP8DEbINFxA
X-Google-Smtp-Source: APXvYqz8guwzfg0TM6fOpf1KbWIIy59ZOHZrk9XDOLvF9YttJ1a4dxPlG1m2oZvqjvqx4XGYsGExqQ==
X-Received: by 2002:aa7:9afc:: with SMTP id y28mr15761979pfp.101.1556936264629;
        Fri, 03 May 2019 19:17:44 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id b14sm4322747pfi.92.2019.05.03.19.17.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 19:17:43 -0700 (PDT)
Subject: Re: [PATCH net-next 9/9] Documentation: net: dsa: sja1105: Add info
 about supported traffic modes
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504011826.30477-1-olteanv@gmail.com>
 <20190504011826.30477-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a0b29ac4-7159-6ccf-9ad1-8193951be7ea@gmail.com>
Date:   Fri, 3 May 2019 19:17:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504011826.30477-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/dsa/sja1105.rst | 49 ++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
> index 7c13b40915c0..a70a04164d07 100644
> --- a/Documentation/networking/dsa/sja1105.rst
> +++ b/Documentation/networking/dsa/sja1105.rst
> @@ -63,6 +63,38 @@ If that changed setting can be transmitted to the switch through the dynamic
>  reconfiguration interface, it is; otherwise the switch is reset and
>  reprogrammed with the updated static configuration.
>  
> +Traffic support
> +===============
> +
> +The switches do not support switch tagging in hardware. But they do support
> +customizing the TPID by which VLAN traffic is identified as such. The switch
> +driver is leveraging ``CONFIG_NET_DSA_TAG_8021Q`` by requesting that special
> +VLANs (with a custom TPID of ``ETH_P_EDSA`` instead of ``ETH_P_8021Q``) are
> +installed on its ports when not in ``vlan_filtering`` mode. This does not
> +interfere with the reception and transmission of real 802.1Q-tagged traffic,
> +because the switch does no longer parse those packets as VLAN after the TPID
> +change.
> +The TPID is restored when ``vlan_filtering`` is requested by the user through
> +the bridge layer, and general IP termination becomes no longer possible through
> +the switch netdevices in this mode.
> +
> +The switches have two programmable filters for link-local destination MACs.
> +These are used to trap BPDUs and PTP traffic to the master netdevice, and are
> +further used to support STP and 1588 ordinary clock/boundary clock
> +functionality.
> +
> +The following traffic modes are supported over the switch netdevices:
> +
> ++--------------------+------------+------------------+------------------+
> +|                    | Standalone |   Bridged with   |   Bridged with   |
> +|                    |    ports   | vlan_filtering 0 | vlan_filtering 1 |
> ++====================+============+==================+==================+
> +| Regular traffic    |     Yes    |       Yes        |  No (use master) |
> ++--------------------+------------+------------------+------------------+

Just to make sure I fully understand the limitation here and sorry for
making you repeat it since I am sure you have explained it already.

Let's say that I have a bridge with vlan_filtering=1 configured, and I
assign an IP address to the bridge master device (as is a common thing
with e.g.: SOHO routers), does that mean I cannot ping any stations
behind that bridge at all?

We used to have this problem with DSA master devices being a bridge
member which was fixed a while ago by simply denying them a bridge join
[1], would that be something to rework somehow here such that we can let
your DSA master device join the bridge to continue delivering frames to
the bridge master?

[1]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8db0a2ee2c6302a1dcbcdb93cb731dfc6c0cdb5e


> +| Management traffic |     Yes    |       Yes        |       Yes        |
> +|    (BPDU, PTP)     |            |                  |                  |
> ++--------------------+------------+------------------+------------------+
> +
>  Switching features
>  ==================
>  
> @@ -92,6 +124,23 @@ that VLAN awareness is global at the switch level is that once a bridge with
>  ``vlan_filtering`` enslaves at least one switch port, the other un-bridged
>  ports are no longer available for standalone traffic termination.
>  
> +Topology and loop detection through STP is supported.
> +
> +L2 FDB manipulation (add/delete/dump) is currently possible for the first
> +generation devices. Aging time of FDB entries, as well as enabling fully static
> +management (no address learning and no flooding of unknown traffic) is not yet
> +configurable in the driver.
> +
> +Other notable features
> +======================
> +
> +The switches have a PTP Hardware Clock that can be steered through SPI and used
> +for timestamping management traffic on ingress and egress.
> +Also, the T, Q and S devices support TTEthernet (an implementation of SAE
> +AS6802 from TTTech), which is a set of Ethernet QoS enhancements somewhat
> +similar in behavior to IEEE TSN (time-aware shaping, time-based policing).
> +Configuring these features is currently not supported in the driver.
> +
>  Device Tree bindings and board design
>  =====================================
>  
> 

-- 
Florian
