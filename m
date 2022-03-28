Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED94E9212
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 11:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239632AbiC1J5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 05:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiC1J5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 05:57:43 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7304F475;
        Mon, 28 Mar 2022 02:56:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V8R2xSD_1648461360;
Received: from 30.225.24.58(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V8R2xSD_1648461360)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 28 Mar 2022 17:56:01 +0800
Message-ID: <da663f43-a593-6acc-d4ec-9bd932637bee@linux.alibaba.com>
Date:   Mon, 28 Mar 2022 17:55:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net] net/smc: Send out the remaining data in sndbuf before
 close
To:     dust.li@linux.alibaba.com, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1648447836-111521-1-git-send-email-guwen@linux.alibaba.com>
 <20220328090411.GI35207@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220328090411.GI35207@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your comments.

On 2022/3/28 5:04 pm, dust.li wrote:
> 
> I think this issue should also happen if TCP_CORK is set and
> autocorking is not enabled ?

Yes, setting TCP_CORK also works.
> 
> Autocorking and delaying the TX from BH to smc_release_cb() greatly
> increased the probability of this problem.
>
Thanks,
Wen Gu
