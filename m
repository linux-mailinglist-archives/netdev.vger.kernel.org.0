Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE56AC777
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCFQQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjCFQQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:16:02 -0500
Received: from out199-17.us.a.mail.aliyun.com (out199-17.us.a.mail.aliyun.com [47.90.199.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC5F55528;
        Mon,  6 Mar 2023 08:12:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VdI7ZWY_1678118984;
Received: from 192.168.50.70(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VdI7ZWY_1678118984)
          by smtp.aliyun-inc.com;
          Tue, 07 Mar 2023 00:09:45 +0800
Message-ID: <59209406-037b-3b6a-fa71-731ace92d509@linux.alibaba.com>
Date:   Tue, 7 Mar 2023 00:09:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net] net/smc: fix fallback failed while sendmsg with
 fastopen
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1678075728-18812-1-git-send-email-alibuda@linux.alibaba.com>
 <ZAXbkUh4h2rIJdR2@corigine.com>
 <5e64b96e-5c8e-a631-287d-f960f52d8aaa@linux.alibaba.com>
 <ZAYOmSy9+pbZpTag@corigine.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <ZAYOmSy9+pbZpTag@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roger that.

Thanks for you information.  I will issue the next version after the 
community

has no more comments.


On 3/7/23 12:02 AM, Simon Horman wrote:
> On Tue, Mar 07, 2023 at 12:01:01AM +0800, D. Wythe wrote:
>> Hi Simon,
>>
>> Thank you for your suggestion.  Your writing style is more elegant.
>>
>> I will modify it according to your plan. Can I add your name as a
>> co-developer?
> Sure, thanks!
>
> If you need it, my code can be:
>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
