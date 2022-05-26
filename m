Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC569534975
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 05:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244076AbiEZDrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 23:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiEZDr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 23:47:29 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AC6257;
        Wed, 25 May 2022 20:47:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VEQTeja_1653536838;
Received: from 30.225.28.183(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VEQTeja_1653536838)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 May 2022 11:47:24 +0800
Message-ID: <8a518b27-3048-cb0b-d2e3-a68d0ef05171@linux.alibaba.com>
Date:   Thu, 26 May 2022 11:47:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/5/25 下午9:42, Alexandra Winter 写道:

> Thank you D. Wythe for your proposals, the prototype and measurements.
> They sound quite promising to us.
>  > We need to carefully evaluate them and make sure everything is compatible
> with the existing implementations of SMC-D and SMC-R v1 and v2. In the
> typical s390 environment ROCE LAG is propably not good enough, as the card
> is still a single point of failure. So your ideas need to be compatible
> with link redundancy. We also need to consider that the extension of the
> protocol does not block other desirable extensions.
> 
> Your prototype is very helpful for the understanding. Before submitting any
> code patches to net-next, we should agree on the details of the protocol
> extension. Maybe you could formulate your proposal in plain text, so we can
> discuss it here?

I am very pleased to hear that your team have interest in this 
proposals, and thanks a lot for your advise. We really appreciate your 
point of view about compatibility, In fact, we are working on some 
written drafts which compatibility is quite a important part, and will 
be shared here soon.

> 
> We also need to inform you that several public holidays are upcoming in the
> next weeks and several of our team will be out for summer vacation, so please
> allow for longer response times.

Thanks for your informing, that's totaly okay to us. May your holidays 
be full of warmth and cheer.


> Kind regards
> Alexandra Winter
> 


D. Wyther
Thanks.




