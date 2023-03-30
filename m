Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29146CFB24
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjC3GB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjC3GBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:01:40 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C71A6A54;
        Wed, 29 Mar 2023 23:01:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VezSI9h_1680156082;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VezSI9h_1680156082)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 14:01:23 +0800
Message-ID: <1680156071.4256074-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 12/16] virtio_net: introduce virtnet_get_netdev()
Date:   Thu, 30 Mar 2023 14:01:11 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
 <20230328092847.91643-13-xuanzhuo@linux.alibaba.com>
 <20230329212203.3c3bf199@kernel.org>
In-Reply-To: <20230329212203.3c3bf199@kernel.org>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 21:22:03 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 28 Mar 2023 17:28:43 +0800 Xuan Zhuo wrote:
> > +const struct net_device_ops *virtnet_get_netdev(void)
> > +{
> > +	return &virtnet_netdev;
> > +}
>
> Why not just make the virtnet_netdev symbol visible?
> Many drivers do that.
>
> If you prefer the function maybe virtnet_get_ndos() would be a better
> name for example? The current name sounds like it will get a... well..
> a netdev. And it gets ops.


Will fix.

Thanks.
