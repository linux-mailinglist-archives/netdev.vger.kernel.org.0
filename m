Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DE64DACBF
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiCPIqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiCPIqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:46:31 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F3D8606E6;
        Wed, 16 Mar 2022 01:45:17 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:56746.157783914
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id DB1162800CD;
        Wed, 16 Mar 2022 16:45:06 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 3126531201094bec8621442dbf886d9f for jiri@resnulli.us;
        Wed, 16 Mar 2022 16:45:13 CST
X-Transaction-ID: 3126531201094bec8621442dbf886d9f
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <c5d18455-c2ff-6e1d-c2d5-55417995c014@chinatelecom.cn>
Date:   Wed, 16 Mar 2022 16:45:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20220315073008.17441-1-sunshouxin@chinatelecom.cn>
 <20220315073008.17441-4-sunshouxin@chinatelecom.cn>
 <YjB0wCcubE6713C+@nanopsycho>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <YjB0wCcubE6713C+@nanopsycho>
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


在 2022/3/15 19:13, Jiri Pirko 写道:
> Tue, Mar 15, 2022 at 08:30:07AM CET, sunshouxin@chinatelecom.cn wrote:
>> This patch is implementing IPV6 RLB for balance-alb mode.
> Out of curiosity, what is exactly your usecase? I'm asking because
> I don't see any good reason to use RLB/ALB modes. I have to be missing
> something.


This is previous discusion thread：

https://www.spinics.net/lists/kernel/msg4187085.html

