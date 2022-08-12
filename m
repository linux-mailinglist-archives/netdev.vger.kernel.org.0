Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E06A5909E4
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 03:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiHLBdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 21:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiHLBdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 21:33:37 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83337BF71
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 18:33:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VM.UGd7_1660268012;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VM.UGd7_1660268012)
          by smtp.aliyun-inc.com;
          Fri, 12 Aug 2022 09:33:32 +0800
Message-ID: <1660267838.1945586-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 0/2] virtio_net: fix for stuck when change ring size with dev down
Date:   Fri, 12 Aug 2022 09:30:38 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
 <20220811041041-mutt-send-email-mst@kernel.org>
 <20220811103730.0f085866@kernel.org>
In-Reply-To: <20220811103730.0f085866@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 10:37:30 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 11 Aug 2022 04:11:22 -0400 Michael S. Tsirkin wrote:
> > Which patches does this fix?
> > Maybe I should squash.
>
> Side question to make sure I understand the terminology - this
> is *not* a vhost patch, right? vhost is the host side of virtio?
> Is the work going via the vhost tree because of some dependencies?


Yes, the commits fixed by this patch are currently in Michael's vhost branch.

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=linux-next

So I mean that by "vhost" here, not into the net/net-next branch. Or should I use
a more accurate term next time?

Thanks.
