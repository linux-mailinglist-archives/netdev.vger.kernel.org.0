Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948354DBC92
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 02:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352311AbiCQBnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 21:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiCQBnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 21:43:40 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3EFB10FE6;
        Wed, 16 Mar 2022 18:42:24 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:35528.1253522149
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 6D2F2280173;
        Thu, 17 Mar 2022 09:42:18 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 752860455006496ba09cef5e72b291a5 for kuba@kernel.org;
        Thu, 17 Mar 2022 09:42:22 CST
X-Transaction-ID: 752860455006496ba09cef5e72b291a5
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <daaa255e-9127-30e8-1f1a-68ba2d61ffc6@chinatelecom.cn>
Date:   Thu, 17 Mar 2022 09:42:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 0/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
 <20220316130537.3f43d467@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <20220316130537.3f43d467@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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


在 2022/3/17 4:05, Jakub Kicinski 写道:
> On Wed, 16 Mar 2022 04:49:54 -0400 Sun Shouxin wrote:
>> This patch is implementing IPV6 RLB for balance-alb mode.
> Patches 1, 2 and 3 do no build individually. Please build test each
> patch to avoid breaking bisection.


Sorry for mess up， I initially aim to submit patch belonging to seperate 
component by seperate patch,
  but it doesn't look like sense.
  I'll submit all code at a whole patch soon if no obiection, thanks 
your comments for kernel newbee.


