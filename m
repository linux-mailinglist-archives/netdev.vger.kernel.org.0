Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53D35A42F7
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 08:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiH2GKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 02:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiH2GKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 02:10:12 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8CF1FCE6
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 23:10:11 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id x10so7017799ljq.4
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 23:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=PzFW/iYxmKY7XfA4r5YsgFTvwiJLhhNOfEHDMuT37qg=;
        b=hBDsb2N7Gfx/eqw51l0kREfJJxY4DeEEcxa4A35MFLcfJx4+S0uoj8+nZ21yOy7R1I
         MRWdiN9d07SM5vUUg+2Ea+eIPQepQIeS23ZxNe1rJj7hX2a5x7MUkXC2dlgDpkYo5XKu
         mTGUz16A7rFqmM+Gdh7XgoUQ2DjA86c4G/ItoxN51e+ykQDRCo4Mjt+m1JsXk0MJY5fA
         4tpbWlQXUoXuGtGulZ1cVnicC6YY1hcfKkyHUVvOxVc0ged8SJhTByJUcDL8Qcok0ZAc
         6xd6DFHhQcJEpBnz+uXEVOYQC0Y4zVO11s0z+9LsDICB6PDEqN5+wBeeiM2/ul3jvL2K
         HnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PzFW/iYxmKY7XfA4r5YsgFTvwiJLhhNOfEHDMuT37qg=;
        b=zcZus+10MBehkNUsJfrOWzu0XDzm2lO5Wni1+MBSyPfy+pdPbNcDp98XzWfzMOQIs7
         CkgWWPSBJCWv1gOY8wAalzZb4qL9uqFnrLPv4jN9MZ3qRGh3EbwxxSXTnpIiEeBkI5PB
         bsZOOaHmA/9S0xALzcgAwkjwPDGMXWD5nhOewTBMUa/fvhXl9ltwkwZEMG+oNfpYDVkH
         /13AKUDxPCUPTBU4zuOZU96UELh9EfkhGlDCIarpNtGDn4w8PbseSpUAoqkclrJcPtci
         TFNBx3JjJ4fDJein7kE2Cte4bb5DAg+KEuWwn0vrLRrRPt/aU1bA8/1wP/uD7FAw8m/8
         C5mQ==
X-Gm-Message-State: ACgBeo3cnEa7Zjb9LgKJiyxYyQ2i9eO1ISJ/S+ZqUQCs9HFXY1mQyrgx
        ot8D1VWnPbcb5veAn/+NDo0=
X-Google-Smtp-Source: AA6agR7xoLjbh0fiPg39OPVuk+YCCKttFztYxCTxfBwfQNJSi9Yol69U5We9ldWWe9K1cG4JPgYP0g==
X-Received: by 2002:a2e:a7d3:0:b0:25e:7a20:e255 with SMTP id x19-20020a2ea7d3000000b0025e7a20e255mr4798836ljp.426.1661753409564;
        Sun, 28 Aug 2022 23:10:09 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id y4-20020ac255a4000000b0048137a6486bsm474064lfg.228.2022.08.28.23.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Aug 2022 23:10:09 -0700 (PDT)
Message-ID: <5f550ab1-13b5-d78c-d4be-abc6fd7ac8f9@gmail.com>
Date:   Mon, 29 Aug 2022 08:10:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 1/3] dsa: Implement RMU layer in DSA
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-2-mattias.forsblad@gmail.com>
 <YwkelQ7NWgNU2+xm@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <YwkelQ7NWgNU2+xm@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-26 21:27, Andrew Lunn wrote:
> On Fri, Aug 26, 2022 at 08:38:14AM +0200, Mattias Forsblad wrote:
>> Support handling of layer 2 part for RMU frames which is
>> handled in-band with other DSA traffic.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
>>  include/net/dsa.h             |   7 +++
>>  include/uapi/linux/if_ether.h |   1 +
>>  net/dsa/tag_dsa.c             | 109 +++++++++++++++++++++++++++++++++-
>>  3 files changed, 114 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index f2ce12860546..54f7f3494f84 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -92,6 +92,7 @@ struct dsa_switch;
>>  struct dsa_device_ops {
>>  	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
>>  	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
>> +	int (*inband_xmit)(struct sk_buff *skb, struct net_device *dev, int seq_no);
>>  	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
>>  			     int *offset);
>>  	int (*connect)(struct dsa_switch *ds);
>> @@ -1193,6 +1194,12 @@ struct dsa_switch_ops {
>>  	void	(*master_state_change)(struct dsa_switch *ds,
>>  				       const struct net_device *master,
>>  				       bool operational);
>> +
>> +	/*
>> +	 * RMU operations
>> +	 */
>> +	int (*inband_receive)(struct dsa_switch *ds, struct sk_buff *skb,
>> +			int seq_no);
>>  };
> 
> Hi Mattias
> 
> Vladimer pointed you towards the qca driver, in a comment for your
> RFC. qca already has support for switch commands via Ethernet frames.
> 
> The point he was trying to make is that you should look at that
> code. The concept of executing a command via an Ethernet frame, and
> expecting a reply via an Ethernet frame is generic. The format of
> those frames is specific to the switch. We want the generic parts to
> look the same for all switches. If possible, we want to implement it
> once in the dsa core, so all switch drivers share it. Less code,
> better tested code, less bugs, easier maintenance.
> 
> Take a look at qca_tagger_data. Please use the same mechanism with

This I can do which makes sense.

> mv88e6xxx. But also look deeper. What else can be shared? You need a

I can also make a generic dsa_eth_tx_timeout routine which
handles the sending and receiving of cmd frames.

> buffer to put the request in, you need to send it, you need to wait

The skb is the buffer and it's up to the driver to decode it properly?
I've looked into the qca driver and that uses a small static buffer
for replies, no buffer lifetime cycle.

> for the reply, you need to pass the results to the driver, you need to
> free that buffer afterwards. That should all be common. Look at these
> parts in the qca driver. Can you make them generic, move them into the
> DSA core? Are there other parts which could be shared?

I cannot change the qca code as I have no way of verifying that the
resulting code works.

> 
>     Andrew
> 
> 

/Mattias
