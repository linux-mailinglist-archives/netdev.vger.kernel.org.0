Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C66C4159
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjCVD7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVD7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCC247816;
        Tue, 21 Mar 2023 20:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D74561E6B;
        Wed, 22 Mar 2023 03:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307D8C433D2;
        Wed, 22 Mar 2023 03:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679457575;
        bh=NoLU/eJzzjgbu3ElUlUbqyFYCYbcbIXfszzy/XJHJwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FDJZdb5kvsNmTp91a8TD/se1HZfHGeq8h2GbA4wWmmKRxhBIGhv6XqrRvQjC0fN9y
         M/tHNhFiaB8LX8gOF3UgfItp2TJmKEybApIgP7ICtsxgMjxXVvXHKhy8XGGKxkrveo
         zOQBIKgLASZ6UAMf4XT0xRbDbm4cN/x/NAJMGLylyXLwZ07a0nexu1nln1Or+8P88N
         voIik3TWae726aQqStJY9BnYWAAOufp8zuw9pP1gUZNGGF4UP0fgxPYvpn453YvYtt
         8PAbUKdeqm8NXzjF4mv0b7tcjHadQleZNzBbQ2i7AnGE5XT7FXB+f/U8udAX6WLjRq
         NA9jirqI4E84A==
Date:   Tue, 21 Mar 2023 20:59:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] virtio_net: refactor xdp codes
Message-ID: <20230321205934.1c787208@kernel.org>
In-Reply-To: <20230321235326-mutt-send-email-mst@kernel.org>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
        <20230321233325-mutt-send-email-mst@kernel.org>
        <1679456456.3777983-1-xuanzhuo@linux.alibaba.com>
        <20230321235326-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 23:53:52 -0400 Michael S. Tsirkin wrote:
> > > Would it make sense to merge this one through the virtio tree? =20
> >=20
> > There are some small problems that we merge this patch-set to Virtio Tr=
ee
> > directly.
>=20
> what exactly? is there a dependency on net-next?

XDP is very actively developed, this seems like a bad idea :(

Is there a problem? Is it because the RFC was not getting much
attention? RFCs are for interesting code, really, nobody was=20
interested =F0=9F=A4=B7=EF=B8=8F When it comes to merging - it will be in t=
he tree
in two days if nobody finds bugs...
