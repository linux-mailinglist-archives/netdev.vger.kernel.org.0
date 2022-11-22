Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C655633674
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiKVH57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiKVH5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:57:50 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607FB1E;
        Mon, 21 Nov 2022 23:57:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VVRB.va_1669103862;
Received: from 30.221.149.157(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVRB.va_1669103862)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:57:44 +0800
Message-ID: <f3cd8ecc-b75c-d470-4a92-77ececf753b9@linux.alibaba.com>
Date:   Tue, 22 Nov 2022 15:57:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:106.0)
 Gecko/20100101 Thunderbird/106.0
Subject: Re: [PATCH 0/2] Revert "veth: Avoid drop packets when xdp_redirect
 performs" and its fix
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        John Fastabend <john.fastabend@gmail.com>, toke@kernel.org
References: <20221122035015.19296-1-hengqi@linux.alibaba.com>
 <20221121203526.00e3698a@kernel.org>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <20221121203526.00e3698a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/22 下午12:35, Jakub Kicinski 写道:
> On Tue, 22 Nov 2022 11:50:13 +0800 Heng Qi wrote:
>> This patch 2e0de6366ac16 enables napi of the peer veth automatically when the
>> veth loads the xdp, but it breaks down as reported by Paolo and John. So reverting
>> it and its fix, we will rework the patch and make it more robust based on comments.
> Did anything change since the previous posting?

Do you mean this positing?
https://lore.kernel.org/all/20221121112848.51388-1-hengqi@linux.alibaba.com/

If yes, there is no difference between this posting and the posting 
posted by the link. This posting is to make it easier to merge.


