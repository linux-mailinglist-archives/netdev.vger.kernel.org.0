Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0D603972
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 07:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJSF7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 01:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJSF7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 01:59:06 -0400
Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56D6537C2
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 22:59:04 -0700 (PDT)
Received: from eig-obgw-5012a.ext.cloudfilter.net ([10.0.29.230])
        by cmsmtp with ESMTP
        id kzAEo6bRGh3t8l26ZoRcmB; Wed, 19 Oct 2022 05:59:03 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id l26VobTsLMAVel26VoDn1v; Wed, 19 Oct 2022 05:58:59 +0000
X-Authority-Analysis: v=2.4 cv=DLqcXgBb c=1 sm=1 tr=0 ts=634f9223
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=VLn1U4HDsV/kFU42pi1uTw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=Qawa6l4ZSaYA:10
 a=wYkD_t78qR0A:10 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=Qgz39EsCW-LGziui3z8A:9
 a=QEXdDO2ut3YA:10 a=xmb-EsYY8bH0VWELuYED:22 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cO2pMH5o5rFNjaegSUZJR5RRzkW1PCUC3AUJ+Q7uoNc=; b=ycvo3HFILiKjWdun33pRJ01AvN
        s2rgU8+eozWvKOZlVv/R6Y4pQ6+kVtzGPOD+oQ6EucZwZvx0XWTdExWl6ATWYX1CYflpMCa/VjoNV
        5a0ift/n1buAOyhhk/u20x9ys5iUSQwy7o6BTXeplBIzsZfFzRIegDPu2SKnijxd96LfZQTqHvv2o
        wFz/MYfGycnJ0h3rF847pOJiBj44n54oP0PsJepme72nlMV0LPRjyDWjl2MaJaeKo9I73vKtfGC5u
        OMORO9rhwQcJ0axs7C4BCKpk4L0Bjy4QcvhZDzmzxSsDuRaJar5C/i9fwfGdu9YSx2foF2DYWgsVY
        g1n8VHrQ==;
Received: from [187.184.159.238] (port=9278 helo=[192.168.0.24])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ol26T-0001NQ-Sd;
        Wed, 19 Oct 2022 00:58:58 -0500
Message-ID: <f134c4ff-aac0-eb79-871e-73cff18a57c8@embeddedor.com>
Date:   Wed, 19 Oct 2022 00:58:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6/6][next] airo: Avoid clashing function prototypes
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <cover.1666038048.git.gustavoars@kernel.org>
 <ab0047382e6fd20c694e4ca14de8ca2c2a0e19d0.1666038048.git.gustavoars@kernel.org>
 <202210171950.B5F2676D7F@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <202210171950.B5F2676D7F@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.184.159.238
X-Source-L: No
X-Exim-ID: 1ol26T-0001NQ-Sd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.24]) [187.184.159.238]:9278
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJZudnsNNLICK4F6bkKKic+KkRDJIdiLRulTc+q+u8Z4K0N9AJRc0Sv5Hxap8okRu8pPNdLOLz75HNv3JVvNFnPH6ymEqV+ZezzbSuqWrbpKRISiQvQ6
 /5n+L8czVl7D5U+UPugpM6T25bY7DQZCwxyWEvEuicRR30ZjWnXX4mqBx2EaV6jIXYYN6+Eu3u2LkRui2BauXr8ka1HXxNGFgg8=
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/22 21:53, Kees Cook wrote:
> On Mon, Oct 17, 2022 at 03:36:20PM -0500, Gustavo A. R. Silva wrote:
>> [...]
>> @@ -6312,16 +6326,16 @@ static int airo_get_mode(struct net_device *dev,
>>   	/* If not managed, assume it's ad-hoc */
>>   	switch (local->config.opmode & MODE_CFG_MASK) {
>>   		case MODE_STA_ESS:
>> -			*uwrq = IW_MODE_INFRA;
>> +			uwrq->mode = IW_MODE_INFRA;
>>   			break;
>>   		case MODE_AP:
>> -			*uwrq = IW_MODE_MASTER;
>> +			uwrq->mode = IW_MODE_MASTER;
>>   			break;
>>   		case MODE_AP_RPTR:
>> -			*uwrq = IW_MODE_REPEAT;
>> +			uwrq->mode = IW_MODE_REPEAT;
>>   			break;
>>   		default:
>> -			*uwrq = IW_MODE_ADHOC;
>> +			uwrq->mode = IW_MODE_ADHOC;
>>   	}
>>   
>>   	return 0;
> 
> Sometimes you use the union directly, sometimes not. What was your
> heuristic for that?

Oh it is just that I had previously used a new variable in function airo_set_mode(),
and then I immediately ran into this similar scenario (function airo_get_mode) and
I said "wait a second, why don't I directly use the union, instead? :thinking_face:"
and I did, and moved on. :P

> 
> Regardless, looks good!
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

Thanks for this!

BTW, I already have a new series (this time a 4-patch series, instead of 6), with
the latest fixes, here:

https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=6.1-rc1-Wcast-function-type-strict

I think we could quickly review it tomorrow before I send it out. :)

--
Gustavo
