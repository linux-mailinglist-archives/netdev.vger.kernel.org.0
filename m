Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0130653A76
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 03:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiLVCEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 21:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLVCEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 21:04:34 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01E720F64;
        Wed, 21 Dec 2022 18:04:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXrFu9A_1671674668;
Received: from 30.236.23.70(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXrFu9A_1671674668)
          by smtp.aliyun-inc.com;
          Thu, 22 Dec 2022 10:04:29 +0800
Message-ID: <2206a016-743b-6316-9546-d1f827f12dd2@linux.alibaba.com>
Date:   Thu, 22 Dec 2022 10:04:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v2 0/9] virtio_net: support multi buffer xdp
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221221173022.2056b45b@kernel.org>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <20221221173022.2056b45b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/22 上午9:30, Jakub Kicinski 写道:
> On Tue, 20 Dec 2022 22:14:40 +0800 Heng Qi wrote:
>> Changes since RFC:
>> - Using headroom instead of vi->xdp_enabled to avoid re-reading
>>    in add_recvbuf_mergeable();
>> - Disable GRO_HW and keep linearization for single buffer xdp;
>> - Renamed to virtnet_build_xdp_buff_mrg();
>> - pr_debug() to netdev_dbg();
>> - Adjusted the order of the patch series.
> # Form letter - net-next is closed
>
> We have already submitted the networking pull request to Linus
> for v6.2 and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
>
> Please repost when net-next reopens after Jan 2nd.
>
> RFC patches sent for review only are obviously welcome at any time.

Yes, I understand, we can also review this patch series first.

Thanks.




