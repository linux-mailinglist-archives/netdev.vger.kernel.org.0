Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B4C6E3F40
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDQGAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDQGAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:00:34 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A11B2D69;
        Sun, 16 Apr 2023 23:00:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0VgDbJGf_1681711226;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgDbJGf_1681711226)
          by smtp.aliyun-inc.com;
          Mon, 17 Apr 2023 14:00:27 +0800
Message-ID: <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Mon, 17 Apr 2023 13:58:01 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     netdev@vger.kernel.org,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org>
In-Reply-To: <ZDzKAD2SNe1q/XA6@infradead.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Apr 2023 21:24:32 -0700, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Apr 17, 2023 at 11:27:50AM +0800, Xuan Zhuo wrote:
> > The purpose of this patch is to allow driver pass the own dma_ops to
> > xsk.
>
> Drivers have no business passing around dma_ops, or even knowing about
> them.


May misunderstand, here the "dma_ops" is not the "dma_ops" of DMA API.

I mean the callbacks for xsk to do dma.

Maybe, I should rename it in the next version.

Thanks.


