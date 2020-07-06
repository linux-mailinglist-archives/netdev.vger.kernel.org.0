Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F66D2160F0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 23:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgGFVXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 17:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFVXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 17:23:16 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D459BC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 14:23:15 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k6so42836235wrn.3
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 14:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k2mitgUEcWIG9wVSFzXeZW0o+9/lzgFj8nt+1+itO2o=;
        b=q4G1F/EnBvnRxj47H9j+GKbqTiHl59y/Thx/UhOSaD9u+Ur8UvBFnBy7BplrP3sHfG
         QQ8NQDCpUjVSFp5uoyWXHkHSZ4HPU3uNrE6+BDWlpHPTkKrgTG63wNALPG35PkrFU0kO
         20+9rG8DlTacWgaYE49adllDXsX0ZBCscZFDWLmdrkWtm7uLqm/H6Uub07FZlO58yCUM
         Q3oxkZCe4la/GvamFr6b9X+xXV5kYF/CnZWfmIF4fhdeJ8G+cDLQ2e9q2aSMYeOubcVu
         5nLU+dctAL7UXm4fjFuWL3gP5+w4YeaSHgDemeJS6p+E2v+nPMtEoNW3hm/5K+FREycF
         sBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k2mitgUEcWIG9wVSFzXeZW0o+9/lzgFj8nt+1+itO2o=;
        b=l4alOwPMwG5eO9h6wnjyKur5KUqyuaZ8c7v2omyhZbJxGgoLYfHdsEWH6vKxXFgHzc
         ecFmg8X6KZvBdrZmYUx/9K2hGF0aXXg7Hmwm7fN7qxdD6HssK02dv70VFKReqErIWRtQ
         NGy+J8/rB2ykUx+htWxtHiGiI6D7kbPXnL+H7Q9isDMdvrrHrtf5YHlltIrtwdQa6J8X
         ig0ndhbB94tzuekekJnUn8TLN75WkeTVDvBFdlO73X9ZDTEq7oDDIoGkoEb6Q0rUK9zd
         kfpY4ob1zVLpq1AT8TmyHbq+oGPZDKQi+rC77+A2kbcd0w4EgzaBJqgNpJaS94moEOb0
         73SQ==
X-Gm-Message-State: AOAM5307VpaSiCMUF2bsMjeOaDjbwyA1psJ97HdqjMhYLSbbA8dRXRxy
        cX/ka3/uUlVm07KSQmMd/U4=
X-Google-Smtp-Source: ABdhPJwk3Qt+EiYDswJYutEvU/6ZpuvSSx5QiCdp5pJoX3B2+lnh2izvpLrEv9vvns4L/nRiQPIC5Q==
X-Received: by 2002:a5d:68c7:: with SMTP id p7mr53429240wrw.16.1594070594524;
        Mon, 06 Jul 2020 14:23:14 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e23sm739084wme.35.2020.07.06.14.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 14:23:13 -0700 (PDT)
Subject: Re: [net-next PATCH 4/5 v4] net: dsa: rtl8366: VLAN 0 as disable
 tagging
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20200706205245.937091-1-linus.walleij@linaro.org>
 <20200706205245.937091-5-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9a87a847-05e9-0de8-bdf1-d56eab15f2a9@gmail.com>
Date:   Mon, 6 Jul 2020 14:23:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706205245.937091-5-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2020 1:52 PM, Linus Walleij wrote:
> The code in net/8021q/vlan.c, vlan_device_event() sets
> VLAN 0 for a VLAN-capable ethernet device when it
> comes up.
> 
> Since the RTL8366 DSA switches must have a VLAN and
> PVID set up for any packets to come through we have
> already set up default VLAN for each port as part of
> bringing the switch online.
> 
> Make sure that setting VLAN 0 has the same effect
> and does not try to actually tell the hardware to use
> VLAN 0 on the port because that will not work.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v3->v4:
> - Resend with the rest
> ChangeLog v2->v3:
> - Collected Andrew's review tag.
> ChangeLog v1->v2:
> - Rebased on v5.8-rc1 and other changes.
> ---
>  drivers/net/dsa/rtl8366.c | 65 +++++++++++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> index b907c0ed9697..a000d458d121 100644
> --- a/drivers/net/dsa/rtl8366.c
> +++ b/drivers/net/dsa/rtl8366.c
> @@ -355,15 +355,25 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
>  			 const struct switchdev_obj_port_vlan *vlan)
>  {
>  	struct realtek_smi *smi = ds->priv;
> +	u16 vid_begin = vlan->vid_begin;
> +	u16 vid_end = vlan->vid_end;
>  	u16 vid;
>  	int ret;
>  
> -	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
> +	if (vid_begin == 0) {
> +		dev_info(smi->dev, "prepare VLAN 0 - ignored\n");
> +		if (vid_end == 0)
> +			return 0;
> +		/* Skip VLAN 0 and start with VLAN 1 */
> +		vid_begin = 1;
> +	}

Humm I still don't understand why you are doing that. Upon DSA network
device creation, VID 0 will be pushed because we advertise support for
NETIF_F_HW_VLAN_CTAG_FILTER, so if nothing else, we will be getting the
"prepare VLAN 0 -ignored" message which is not relevant nor a good idea
to print.

You can force this VLAN to be programmed as untagged, in fact you should
be doing that per the 802.1Q specification.

There are no other cases other than the initial network device creation
that will lead to programming this VLAN ID. The bridge will always
specify a VID range within 1 through 4094 and the VLAN RX filter offload
will not add or remove VID 0 other than at creation/destruction.

As mentioned before, if you need VLAN awareness into the switch from the
get go, you need to set configure_vlan_while_not_filtering and that
would ensure that all ports belong to a VID at startup. Later on, when
the bridge gets set-up, it will be requesting the ports added as bridge
ports to be programmed into VID 1 as PVID untagged. And this should
still be fine.
-- 
Florian
