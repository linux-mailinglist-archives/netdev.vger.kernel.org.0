Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B9B6ADCF9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCGLL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCGLKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:10:50 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39601ABC7;
        Tue,  7 Mar 2023 03:08:32 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VdLD6tx_1678187309;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VdLD6tx_1678187309)
          by smtp.aliyun-inc.com;
          Tue, 07 Mar 2023 19:08:30 +0800
Message-ID: <1678187301.913421-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net 0/2] add checking sq is full inside xdp xmit
Date:   Tue, 7 Mar 2023 19:08:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20230306041535.73319-1-xuanzhuo@linux.alibaba.com>
 <20230306125742-mutt-send-email-mst@kernel.org>
 <1678153770.8281553-2-xuanzhuo@linux.alibaba.com>
 <27a06a7d79fef3446ae1167612808a2af09922be.camel@redhat.com>
In-Reply-To: <27a06a7d79fef3446ae1167612808a2af09922be.camel@redhat.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Mar 2023 10:53:41 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> Hi,
> On Tue, 2023-03-07 at 09:49 +0800, Xuan Zhuo wrote:
> > On Mon, 6 Mar 2023 12:58:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Mon, Mar 06, 2023 at 12:15:33PM +0800, Xuan Zhuo wrote:
> > > > If the queue of xdp xmit is not an independent queue, then when the xdp
> > > > xmit used all the desc, the xmit from the __dev_queue_xmit() may encounter
> > > > the following error.
> > > >
> > > > net ens4: Unexpected TXQ (0) queue failure: -28
> > > >
> > > > This patch adds a check whether sq is full in XDP Xmit.
> > > >
> > > > Thanks.
> > >
> > > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > needed for stable?
> >
> > Yes i think.
>
> Could you please re-post including a suitable 'Fixes' tag? That would
> address stable, too. Additionally you could rename check_sq_full() in
> patch 1, perhaps 'check_disable_sq_full()' would do.
>
> You can retain the already collected tags.

OK

Thanks.


>
> Thanks!
>
> Paolo
>
