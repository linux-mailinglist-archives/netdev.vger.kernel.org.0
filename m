Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9044E1E96
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 02:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343954AbiCUBTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 21:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiCUBTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 21:19:12 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D68B17C421;
        Sun, 20 Mar 2022 18:17:48 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:54162.245595637
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.171 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 38A1A2800A5;
        Mon, 21 Mar 2022 09:17:35 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 0a1d7d2c711841a29da9266bd3fe4ff9 for jiri@resnulli.us;
        Mon, 21 Mar 2022 09:17:44 CST
X-Transaction-ID: 0a1d7d2c711841a29da9266bd3fe4ff9
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <e24c1190-ba41-6ba5-0aca-463cac2a2b2f@chinatelecom.cn>
Date:   Mon, 21 Mar 2022 09:17:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20220317061521.23985-1-sunshouxin@chinatelecom.cn>
 <YjLtLdH9gmg7yaNl@nanopsycho>
 <1f7b15a6-861f-9762-a159-73d16c95eebc@chinatelecom.cn>
 <YjRuXPJzp2fKvMst@nanopsycho>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <YjRuXPJzp2fKvMst@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/18 19:34, Jiri Pirko 写道:
> Fri, Mar 18, 2022 at 10:49:02AM CET, sunshouxin@chinatelecom.cn wrote:
>> 在 2022/3/17 16:11, Jiri Pirko 写道:
>>> Thu, Mar 17, 2022 at 07:15:21AM CET, sunshouxin@chinatelecom.cn wrote:
>>>> This patch is implementing IPV6 RLB for balance-alb mode.
>>>>
>>>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>>>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>>> Could you please reply to my question I asked for v1:
>>> Out of curiosity, what is exactly your usecase? I'm asking because
>>> I don't see any good reason to use RLB/ALB modes. I have to be missing
>>> something.
>>>
>>> This is adding a lot of code in bonding that needs to be maintained.
>>> However, if there is no particular need to add it, why would we?
>>>
>>> Could you please spell out why exactly do you need this? I'm pretty sure
>>> that in the end well find out, that you really don't need this at all.
>>>
>>> Thanks!
>>
>> This patch is certainly aim fix one real issue in ou lab.
>> For historical inheritance, the bond6 with ipv4 is widely used in our lab.
>> We started to support ipv6 for all service last year, networking operation
>> and maintenance team
>> think it does work with ipv6 ALB capacity take it for granted due to bond6's
>> specification
>> but it doesn't work in the end. as you know, it is impossible to change link
>> neworking to LACP
>> because of huge cost and effective to online server.
> I don't follow. Why exactly can't you use LACP? Every switch supports
> it.


Hi jiri


Changing to Lacp means risk  to our online service requring high available.

Also,we have multiple DCs installed bond6,it is huge cost to change it.


