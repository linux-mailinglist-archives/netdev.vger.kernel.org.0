Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4D4B5851
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357035AbiBNRQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:16:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357034AbiBNRQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:16:22 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C101652C3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:16:14 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m22so11128124pfk.6
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FNzsmm5a0LpX8EsRPph0oJGS9W8xfFJkyUBoKrEUk3Q=;
        b=hDbCyIUhrBDEFLcSgk9CId82Fkl7Uel3SItt59Pj22FM4cwk1iHU7nW7SADpmwohY9
         OYfILMaZmRZq8v1dmxujXKCND0LBrYmHOOte/yuYn/8OcuGuVdNWqzoOoYnsQvwbY2VE
         c7LcypjsP2osX3OqNVjsYHqc/F+8tQwEyrUKfeaDexinLCunoICRv90lPp1IpIXQTzIB
         WxX/jdYvhmfwLZm9WSf08kCXUMPuD+pWkiqtdwT0ZC5UJRNYqS4rs/N9+rac8LdpCsKW
         uZLDwWNY58rTh5tLzGk0ZXadag69MV3MmQDy3sQgKYgojDleGermK7lh6lm2gKrUfThZ
         aXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FNzsmm5a0LpX8EsRPph0oJGS9W8xfFJkyUBoKrEUk3Q=;
        b=vyB4EGtT3YbKfgxf1b5t4NCri7mHRrxIYVHuv5pk30iyntiMOZUH78ePHGTl/PtGpq
         sTC2JNi4F1koArUnze3hvwEZcOzxCQLJXNCddb+vR3IYZxT/6g3ecFt1C0H9ZdTfayOk
         AUR9+d2vtltD7hyNbs34KFfO7pfwM77WUtXCi82w1NSQYx32sOK2qnVHUjzrVuvwULg9
         cC4P5APLuH8/BwUGO3dFs7gMeldoR8gMq1YG/nHZBKJGA05ie6lB/XlE7Uo/tfHCpRIf
         2zT93f1SmJ1LLWwmqkKCakTovwnKawbGAVt6j/tS4kf76QyoFHwLlf/RCj31bLIPGJzj
         PX/g==
X-Gm-Message-State: AOAM532U2CpJtEJZDEdJeG+dBA3Jq7fYpKzCgX7tUPjo6YD3L+1SZLSk
        ZzCul1YUc77E/NDVw5F9Ua0=
X-Google-Smtp-Source: ABdhPJz+xEuC9GWAjj2tj3KycjGCRvj7g8Yb9Nqi4zq/mUmMAOI4MacG0gDLHXA57GCI/+Fj3uWyNQ==
X-Received: by 2002:a63:2ca:: with SMTP id 193mr581084pgc.371.1644858973847;
        Mon, 14 Feb 2022 09:16:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l20sm38610318pfc.53.2022.02.14.09.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 09:16:13 -0800 (PST)
Subject: Re: DSA using cpsw and lan9303
To:     =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
References: <yw1x8rud4cux.fsf@mansr.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
Date:   Mon, 14 Feb 2022 09:16:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <yw1x8rud4cux.fsf@mansr.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+others,

netdev is a high volume list, you should probably copy directly the
people involved with the code you are working with.

On 2/14/22 8:44 AM, Måns Rullgård wrote:
> The hardware I'm working on has a LAN9303 switch connected to the
> Ethernet port of an AM335x (ZCE package).  In trying to make DSA work
> with this combination, I have encountered two problems.
> 
> Firstly, the cpsw driver configures the hardware to filter out frames
> with unknown VLAN tags.  To make it accept the tagged frames coming from
> the LAN9303, I had to modify the latter driver like this:
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 2de67708bbd2..460c998c0c33 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1078,20 +1079,28 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
>                                struct phy_device *phy)
>  {
>         struct lan9303 *chip = ds->priv;
> +       struct net_device *master;
>  
>         if (!dsa_is_user_port(ds, port))
>                 return 0;
>  
> +       master = dsa_to_port(chip->ds, 0)->master;
> +       vlan_vid_add(master, htons(ETH_P_8021Q), port);

That looks about right given that net/dsa/tag_lan9303.c appears to be a
quasi DSA_TAG_PROTO_8021Q implementation AFAICT.

> +
>         return lan9303_enable_processing_port(chip, port);
>  }
>  
> Secondly, the cpsw driver strips VLAN tags from incoming frames, and
> this prevents the DSA parsing from working.  As a dirty workaround, I
> did this:
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 424e644724e4..e15f42ece8bf 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -235,6 +235,7 @@ void cpsw_rx_vlan_encap(struct sk_buff *skb)
>  
>         /* Remove VLAN header encapsulation word */
>         skb_pull(skb, CPSW_RX_VLAN_ENCAP_HDR_SIZE);
> +       return;
>  
>         pkt_type = (rx_vlan_encap_hdr >>
>                     CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_SHIFT) &
> 
> With these changes, everything seems to work as expected.
> 
> Now I'd appreciate if someone could tell me how I should have done this.
> Please don't make me send an actual patch.
-- 
Florian
