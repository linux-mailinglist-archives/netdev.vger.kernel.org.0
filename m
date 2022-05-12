Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F165243B7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243301AbiELDvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiELDv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:51:29 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21BF30553;
        Wed, 11 May 2022 20:51:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VCyplkM_1652327482;
Received: from 30.43.105.60(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VCyplkM_1652327482)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 May 2022 11:51:23 +0800
Message-ID: <9be49a5a-c87d-1630-3ff3-90e6a233d38b@linux.alibaba.com>
Date:   Thu, 12 May 2022 11:51:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v2 1/2] net/smc: non blocking recvmsg() return
 -EAGAIN when no data and signal_pending
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220512031156.74054-1-guangguan.wang@linux.alibaba.com>
 <20220512031156.74054-2-guangguan.wang@linux.alibaba.com>
 <YnyCblJuPf+UAvjY@TonyMac-Alibaba>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <YnyCblJuPf+UAvjY@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/12 11:43, Tony Lu wrote:
> On Thu, May 12, 2022 at 11:11:55AM +0800, Guangguan Wang wrote:
>> Non blocking sendmsg will return -EAGAIN when any signal pending
>> and no send space left, while non blocking recvmsg return -EINTR
>> when signal pending and no data received. This may makes confused.
>> As TCP returns -EAGAIN in the conditions described above. Align the
>> behavior of smc with TCP.
>>
>> Fixes: 846e344eb722 ("net/smc: add receive timeout check")
>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> I see that you have already sent this patch to net, so this patch is a
> duplicate. There is no need to send it again to net-next.
> 
> Thanks,
> Tony Lu

Ok, just ignore it. Thanks！
