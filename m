Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CEC68EFBA
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjBHNas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBHNar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:30:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40E42366D
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:30:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ml19so51386094ejb.0
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 05:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bghcBSVVjOnDSTu4fI5Fr851/TGgxU6OXRrvvQvz/M8=;
        b=vsG6o0+N006tv5j5AVuAR9PdyHfVEk7j/0/wj2XKjodhe4nFVNeA+CleK3E0rN4D/R
         iWcVumwXa5V3cxpg2fw6SzUH2dj3TPAyXz06UqOaVR2MJ4RAChiSIDUC3wZfKDw7uauD
         pVlutxhJIDu/9s3AYCxnRFcW0N0xg7I5/7D0r14o4JKHmOTK0IQLHBpEPi+CJMaJ9uaP
         DhFOQ4Q4t8HY44yv0xvu+fjCMcSb38w/B0poS+i6xOGpyFVSNNII0Gco8/HKvXBSDMoG
         eqAYskyI9EK01cc3mgND4cfHVk6zj4qJhukbL1bjZtTn7IgyGJH57p02pPDYCuWVgLSr
         u+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bghcBSVVjOnDSTu4fI5Fr851/TGgxU6OXRrvvQvz/M8=;
        b=dSctJTWZZk2lVsQ/tNteJratV3Irarc1AkquxMZwNaFtIzPF+/pOnLgBJYPHqidV2L
         zrGpnQXpIT4PPHavvFA8ausM/N76BhfcZBoqxC3n1qJSx+XuRBZKV7Nj9fT/etoIvOLN
         a7m7akqveyfZeyceho+ZXdkRi0YttmCB26xxXZbRGbNXjC/at8cFtdkbmJJdKWloVdfc
         ldd25ep8rcCcVmaFuutaq27QmxaMbbOZWUQA/24fffUGZsiBrheGLE9g4LoyMAAXj7gZ
         kI4TyDENXbgpkqh1wgyz8zVDoMNA2YC2YGvnb/ZbvBZDa9Y48Ps3glgUSvQFzncHBvNy
         V/7A==
X-Gm-Message-State: AO0yUKWxpEyiTkAPx/O0lyx0JDltfL5azmJqKK84BPZrBDcYi8lr6pAs
        5b5DM1W2zhVmV1zD7y27sLMCOA==
X-Google-Smtp-Source: AK7set+3bEtDssHH7Nx7ZO0qprJo0mrpmZnd2ui3ik3JXFQ7TcjyC2d4jN2azLEGKuAtcuSnhKuGFA==
X-Received: by 2002:a17:906:1ec8:b0:88d:5fd1:3197 with SMTP id m8-20020a1709061ec800b0088d5fd13197mr7478243ejj.50.1675863044339;
        Wed, 08 Feb 2023 05:30:44 -0800 (PST)
Received: from [192.168.3.225] ([81.6.34.132])
        by smtp.gmail.com with ESMTPSA id bl3-20020a170906c24300b007bff9fb211fsm8345526ejb.57.2023.02.08.05.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 05:30:44 -0800 (PST)
Message-ID: <1a71f6f8-09f6-9208-7368-6b2e3bb4af87@blackwall.org>
Date:   Wed, 8 Feb 2023 14:30:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next] net: bridge: clean up one inconsistent indenting
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        roopa@nvidia.com, pabeni@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
 <Y+OdyiQpz7lIBfh3@corigine.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <Y+OdyiQpz7lIBfh3@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 15:04, Simon Horman wrote:
> On Wed, Feb 08, 2023 at 08:56:26AM +0800, Yang Li wrote:
>> ./net/bridge/br_netlink_tunnel.c:317:4-27: code aligned with following code on line 318
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3977
>> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> As you may need to respin this:
> 
> Assuming this is targeting net-next, which seems likely to me,
> the subject should denote that. Something like this:
> 
> [PATCH net-next] net: bridge: clean up one inconsistent indenting
> 
>> ---
>>   net/bridge/br_netlink_tunnel.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
>> index 17abf092f7ca..eff949bfdd83 100644
>> --- a/net/bridge/br_netlink_tunnel.c
>> +++ b/net/bridge/br_netlink_tunnel.c
>> @@ -315,7 +315,7 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
>>   
>>   			if (curr_change)
>>   				*changed = curr_change;
>> -			 __vlan_tunnel_handle_range(p, &v_start, &v_end, v,
>> +			__vlan_tunnel_handle_range(p, &v_start, &v_end, v,
>>   						    curr_change);
> 
> I think you also need to adjust the line immediately above.

You meant below, right? :) i.e. "curr_change)", that seems to get
misaligned after the change and needs to be adjusted as well.

> 
>>   		}
>>   		if (v_start && v_end)
>> -- 
>> 2.20.1.7.g153144c
>>

