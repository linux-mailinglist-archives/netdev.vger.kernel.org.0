Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008445A4606
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiH2JZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiH2JZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:25:13 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9446A22B29
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:25:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNbclzB_1661765103;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VNbclzB_1661765103)
          by smtp.aliyun-inc.com;
          Mon, 29 Aug 2022 17:25:03 +0800
Message-ID: <1661764683.0447783-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
Date:   Mon, 29 Aug 2022 17:18:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <1661762805.8266613-1-xuanzhuo@linux.alibaba.com>
 <CAJs=3_A6hLcTUj_KCG=n+DH9TA0-BaJ0m_CsXgObWjraE0cbeA@mail.gmail.com>
In-Reply-To: <CAJs=3_A6hLcTUj_KCG=n+DH9TA0-BaJ0m_CsXgObWjraE0cbeA@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022 12:14:54 +0300, Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
> > We are very interested in this, and I would like to know what other plans you
> > have in the future? Such as qemu, vhost-uer, vhost-net. And further development
> > work in the kernel.
>
> Hi Xuan,
> I'm actually working on a VirtIO compatible DPU, no virtualization at
> all, so I wasn't planning on implementing it in qemu or vhost.
>
> I have some more development plans for the VirtIO spec and for the
> linux kernel in virtio-net (and maybe virtio-blk).
> Adding a timeout to the control vq is one example (needed with
> physical VirtIO devices).
>
> I would of course help to implement the notifications coalescing
> feature in qemu/vhost if you need.


We'll do some implementation of net dim based on your previous work. In the
meantime, if you don't implement coalescing on backends like qemu, we might
do some work on that.

Thanks.


>
> Alvaro
