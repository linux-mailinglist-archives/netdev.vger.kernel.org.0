Return-Path: <netdev+bounces-8261-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D70472351D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4E20281524
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67713391;
	Tue,  6 Jun 2023 02:14:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502157F;
	Tue,  6 Jun 2023 02:14:21 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62671E5E;
	Mon,  5 Jun 2023 19:14:12 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VkUHd8d_1686017647;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VkUHd8d_1686017647)
          by smtp.aliyun-inc.com;
          Tue, 06 Jun 2023 10:14:08 +0800
Message-ID: <1686017511.351475-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v10 10/10] virtio_net: support dma premapped
Date: Tue, 6 Jun 2023 10:11:51 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
 virtualization@lists.linux-foundation.org,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 netdev@vger.kernel.org,
 bpf@vger.kernel.org
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602092206.50108-11-xuanzhuo@linux.alibaba.com>
 <20230602233152.4d9b9ba4@kernel.org>
 <1685931044.5893385-2-xuanzhuo@linux.alibaba.com>
 <20230605014154-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230605014154-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Mon, 5 Jun 2023 01:44:28 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Jun 05, 2023 at 10:10:44AM +0800, Xuan Zhuo wrote:
> > On Fri, 2 Jun 2023 23:31:52 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Fri,  2 Jun 2023 17:22:06 +0800 Xuan Zhuo wrote:
> > > >  drivers/net/virtio_net.c | 163 +++++++++++++++++++++++++++++++++------
> > >
> > > ack for this going via the vhost tree, FWIW, but you'll potentially
> > > need to wait for the merge window to move forward with the actual
> > > af xdp patches, in this case.
> >
> >
> > My current plan is to let virtio support premapped dma first, and then implement
> > virtio-net to support af-xdp zerocopy.
> >
> > This will indeed involve two branches. But most of the implementations in this
> > patch are virtio code, so I think it would be more appropriate to commit to
> > vhost. Do you have any good ideas?
> >
> >
> > Thanks.
>
> Are you still making changes to net core? DMA core? If it's only
> virtio-net then I can probably merge all of it - just a couple of
> bugfixes there so far, it shouldn't cause complex conflicts.

Just one small change to net core. no dma core.

I will try to fix this problem.

Thanks.


>
> --
> MST
>

