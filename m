Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F04A5F55DC
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJENxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 09:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJENxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 09:53:49 -0400
Received: from premium237-5.web-hosting.com (premium237-5.web-hosting.com [66.29.146.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BBD5C35A;
        Wed,  5 Oct 2022 06:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sladewatkins.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:Cc:References:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+yaz2PTOel5SQwAAFZu+4eCM67Glm7cbv/XXj5lQq/Y=; b=ETWp7ebF38ki2Ickf3q2CQ6WPA
        5H8tJ58EsKagfhjzgz7RyidzFf4VzODb2L5vSR6C+FmoiG3QeJNxuXDF6WlhtCENV0q1QxGdsdK0r
        4dOf+USrp/T241mTX1HzHdYBIP3iRrKEzt2HjFMmi90CLQBqxcQzfJpEl3inzx6TtkdqcWpvef4cq
        aHbhweVYO/kGq99DilxRTj/SJIu4S2CD8tblX2y4GyLmbBb3CWAIEBG33jjiGP8ob4GFb3xb89v/r
        8hqYAbLjpfIwddMevOhjM5fNo01hYzHym5ev26RQRsjxKphnIifyUR6mR+gRLez3mr3xXgn6Dxadz
        L3joMHbg==;
Received: from pool-108-4-135-94.albyny.fios.verizon.net ([108.4.135.94]:55095 helo=[192.168.1.30])
        by premium237.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srw@sladewatkins.net>)
        id 1og4qI-00CwCW-N8;
        Wed, 05 Oct 2022 09:53:46 -0400
Message-ID: <2e6b2a03-6287-0a23-c187-51fe8e9b7941@sladewatkins.net>
Date:   Wed, 5 Oct 2022 09:53:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.1
Subject: Re: MTU does not change
Content-Language: en-US
To:     =?UTF-8?B?0JLRj9GH0LXRgdC70LDQsiDQodCw0LvRjNC90LjQutC+0LI=?= 
        <snordicstr16@gmail.com>
References: <CACzz7ux8mGT-d5YPWdkvTw5vg4-LKXUUsunL8sJySOeuYd0G1w@mail.gmail.com>
Cc:     linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, netdev@vger.kernel.org
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <CACzz7ux8mGT-d5YPWdkvTw5vg4-LKXUUsunL8sJySOeuYd0G1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - premium237.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sladewatkins.net
X-Get-Message-Sender-Via: premium237.web-hosting.com: authenticated_id: srw@sladewatkins.net
X-Authenticated-Sender: premium237.web-hosting.com: srw@sladewatkins.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey there,

On 10/5/22 at 9:47 AM, Вячеслав Сальников wrote:
> Hi.
> 
> I apologize if I wrote in the wrong mail list. I have not found
> linux-netdev for questions

I've Cc'd the netdev and stable lists.

> 
> I switched from kernel versions 4.9 to 5.15 and found that the MTU on
> the interfaces in the bridge does not change.
> For example:
> I have the following bridge:
> bridge      interface
> br0          sw1
>                 sw2
>                 sw3
> 
> And I change with ifconfig MTU.
> I see that br0 sw1..sw3 has changed MTU from 1500 -> 1982.
> 
> But if i send a ping through these interfaces, I get 1500(I added
> prints for output)
> I investigated the code and found the reason:
> The following commit came in the new kernel:
> https://github.com/torvalds/linux/commit/ac6627a28dbfb5d96736544a00c3938fa7ea6dfb
> 
> And the behavior of the MTU setting has changed:
>>
>> Kernel 4.9:
>> if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
>>     ip_mtu_locked(dst) ||
>>     !forwarding)  <--- True
>> return dst_mtu(dst) <--- 1982
>>
>>
>> / 'forwarding = true' case should always honour route mtu /
>> mtu = dst_metric_raw(dst, RTAX_MTU);
>> if (mtu)
>> return mtu;
> 
> 
> 
> Kernel 5.15:
>>
>> if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
>>     ip_mtu_locked(dst) ||
>>     !forwarding) { <--- True
>> mtu = rt->rt_pmtu;  <--- 0
>> if (mtu && time_before(jiffies, rt->dst.expires)) <-- False
>> goto out;
>> }
>>
>> / 'forwarding = true' case should always honour route mtu /
>> mtu = dst_metric_raw(dst, RTAX_MTU); <---- 1500
>> if (mtu) <--- True
>> goto out;
> 
> 
> Why is rt_pmtu now used instead of dst_mtu?
> Why is forwarding = False called with dst_metric_raw?
> Maybe we should add processing when mtu = rt->rt_pmtu == 0?
> Could this be an error?
> 

Cheers,
-srw

