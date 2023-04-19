Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E11F6E71CD
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 05:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbjDSDs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 23:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDSDs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 23:48:28 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3589F8E;
        Tue, 18 Apr 2023 20:48:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VgTAsnt_1681876102;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgTAsnt_1681876102)
          by smtp.aliyun-inc.com;
          Wed, 19 Apr 2023 11:48:23 +0800
Message-ID: <1681876092.206569-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] MAINTAINERS: make me a reviewer of VIRTIO CORE AND NET DRIVERS
Date:   Wed, 19 Apr 2023 11:48:12 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20230413071610.43659-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230413071610.43659-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 15:16:10 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> First of all, I personally love open source, linux and virtio. I have
> also participated in community work such as virtio for a long time.
>
> I think I am familiar enough with virtio/virtio-net and is adequate as a
> reviewer.
>
> Every time there is some patch/bug, I wish I can get pinged
> and I will feedback on that.
>
> For me personally, being a reviewer is an honor and a responsibility,
> and it also makes it easier for me to participate in virtio-related
> work. And I will spend more time reviewing virtio patch. Better advance
> virtio development
>
> I had some contributions to virtio/virtio-net and some support for it.
>
> * per-queue reset
> * virtio-net xdp
> * some bug fix
> * ......
>
> I make a humble request to grant the reviewer role for the virtio core
> and net drivers.

ping!!

>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cacd6074fb89..700b00a9e225 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22064,6 +22064,7 @@ F:	include/uapi/linux/virtio_console.h
>  VIRTIO CORE AND NET DRIVERS
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
>  M:	Jason Wang <jasowang@redhat.com>
> +R:	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>  L:	virtualization@lists.linux-foundation.org
>  S:	Maintained
>  F:	Documentation/ABI/testing/sysfs-bus-vdpa
> --
> 2.32.0.3.g01195cf9f
>
