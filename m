Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E776E7217
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjDSEHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjDSEHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACB84C1C;
        Tue, 18 Apr 2023 21:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA26C63AD7;
        Wed, 19 Apr 2023 04:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F17AC433D2;
        Wed, 19 Apr 2023 04:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681877267;
        bh=UHFMfq+tk9+KU3+6ycZDTXl9M/tQTAv6XtYu+cPYXKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j3FrEcjlLA1gcwXOIuTdP5ugOnWMq4bGR4dxoof6qBY3JahcPh60wT0MC7cJEnklT
         RJ/RGsAnZEI91rOPAh7+6erfQw7b5HX2z0McFs6Ht+ebV+A9HIyXIT5xXEuE202RXW
         /Tp76QUhIm9lTNAci2/WF9gAbnuubk8dK+RndyWTYJZpwHVMTLyMVse6uQ4ZAyELeh
         UGm9sS57hq9j/nIlzenvCT4bSAmKxm9kaUQ53yqOMjcdwOYuaWfE95fYhxaus6dklq
         KnPNOOFuo4FUbnOhTjIKKTs93ULV7JHI2zf45mlzJ7i5/I2nBMaE0WHqwRu6y+nANt
         xtqWVfY9AA5vw==
Date:   Tue, 18 Apr 2023 21:07:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] MAINTAINERS: make me a reviewer of VIRTIO CORE AND NET
 DRIVERS
Message-ID: <20230418210745.100e93a0@kernel.org>
In-Reply-To: <1681876092.206569-1-xuanzhuo@linux.alibaba.com>
References: <20230413071610.43659-1-xuanzhuo@linux.alibaba.com>
        <1681876092.206569-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 11:48:12 +0800 Xuan Zhuo wrote:
> > I had some contributions to virtio/virtio-net and some support for it.
> >
> > * per-queue reset
> > * virtio-net xdp
> > * some bug fix
> > * ......
> >
> > I make a humble request to grant the reviewer role for the virtio core
> > and net drivers.  
> 
> ping!!

Please don't send meaningless pings, if you have a question ask it and
make sure you set the right person in the To: header. 'Cause right now
it looks like you're pinging yourself.

-- 
doc-bot: sub/impatient
