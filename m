Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43054C9DDF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbiCBGjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiCBGjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:39:09 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3059A13E17
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:38:27 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id j15so1031524lfe.11
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 22:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hVnGfIcdqWD286LhnfBxvkIQmhmmOUO1/K+6YQjfSho=;
        b=mC2UljtUr2GezqlJzVSxFlhdU3EnlCtx80pGQ1+2ucMZ6IcfWYIevSkOuu/PtmhmB+
         m1OVMt4a2nrQvOkYr+mBoE1IqqHYcMHVl8UEoXbhfoccZ7S2n4iaXDwiVyBCjHadgIM/
         HuL436wyFPEwIHLcKpVvPeqntRfFw7SEqANuO95Mo6f3JXjgsIfV4wkTF0AcZGJZ529w
         MyRYko67H1EuE715X6hNQ8doTFez4LptegBb+3dIVd1KNhoDK0TAPyeDp3EOnzr4BNnq
         h4Owzy5Utwr8hGriH57WWyaYJSO/xO/ne9sPRFNJi7ytQK8uDS/dd7F5p3JT9Tmltx00
         oSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hVnGfIcdqWD286LhnfBxvkIQmhmmOUO1/K+6YQjfSho=;
        b=c0ksuBUmmyEm4a+YHcWB2TOPeHeOST8PFHkHv4OKaMJSskMgHMor2DzcgL0k0L+HVq
         H9picyzEGYGxqASOlSoIrK4uJsesYBKtNUt2xMKJLs1XaOdYOWoO/uw1Assa7t2YmHK1
         0OpIlDcnWOmN70Zv7A0sl5NxQArGp4zhwXqeHaR9gI481fIAKIO4dPxUpFOcASsJZE+u
         JS8jpvSWobe0D2UBcJqq/FpL954i9iy0TmcxaAP9Ile4mnKDGV+O7TCYwtKwPMRhIGgg
         MJiPvsZorcrKVLB75nI85ju085bf+8OQ749p3cOEyD2fXi4v6Q4MNzV9FsDmxC21Lx8v
         PhAA==
X-Gm-Message-State: AOAM531YBPbHpI9iND6B5YlMEeXbjxyaO78vHb1/Kh1rwZc4r0DZkVvC
        /7JjjiZX3Il3+6JN4sCG/5OOwayzwqh7wzpfFQs=
X-Google-Smtp-Source: ABdhPJzg5F8AiH92mXXoewdiHPrOAPex3aaK2dTGaekx32ubW8EViApaNm3hWZrnSvEB0rMHa5Ymrw==
X-Received: by 2002:a05:6512:33d1:b0:443:7ab1:ea65 with SMTP id d17-20020a05651233d100b004437ab1ea65mr17691051lfg.166.1646203105528;
        Tue, 01 Mar 2022 22:38:25 -0800 (PST)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id k5-20020a2e6f05000000b00245de81bb0esm2432200ljc.13.2022.03.01.22.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 22:38:24 -0800 (PST)
Message-ID: <17bc989b-9433-9521-4a87-386931f21b56@gmail.com>
Date:   Wed, 2 Mar 2022 07:38:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: mattias.forsblad+netdev@gmail.com
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <520758A5-F615-4B36-A24C-6F03C527DDC5@blackwall.org>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <520758A5-F615-4B36-A24C-6F03C527DDC5@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-01 23:43, Nikolay Aleksandrov wrote:
> On 1 March 2022 13:31:02 CET, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
>> This patch implements the bridge flag local_receive. When this
>> flag is cleared packets received on bridge ports will not be forwarded up.
>> This makes is possible to only forward traffic between the port members
>> of the bridge.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
>> ---
>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>> index 7557e90b60e1..57dd14d5e360 100644
>> --- a/net/bridge/br_vlan.c
>> +++ b/net/bridge/br_vlan.c
>> @@ -905,6 +905,14 @@ bool br_vlan_enabled(const struct net_device *dev)
>> }
>> EXPORT_SYMBOL_GPL(br_vlan_enabled);
>>
>> +bool br_local_receive_enabled(const struct net_device *dev)
>> +{
>> +	struct net_bridge *br = netdev_priv(dev);
>> +
>> +	return br_opt_get(br, BROPT_LOCAL_RECEIVE);
>> +}
>> +EXPORT_SYMBOL_GPL(br_local_receive_enabled);
>> +
> 
> What the hell is this doing in br_vlan.c???
> 

I'm truly sorry to have made an error, might I inqire for a better approach?

>> int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
>> {
>> 	struct net_bridge *br = netdev_priv(dev);
> 

