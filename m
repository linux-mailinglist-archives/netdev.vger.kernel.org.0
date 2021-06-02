Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8114939944E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFBUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBUML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:12:11 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87960C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 13:10:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7429E4D2522E3;
        Wed,  2 Jun 2021 13:10:27 -0700 (PDT)
Date:   Wed, 02 Jun 2021 13:10:26 -0700 (PDT)
Message-Id: <20210602.131026.1242688865859450294.davem@davemloft.net>
To:     tannerlove.kernel@gmail.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, edumazet@google.com, willemb@google.com,
        ppenkov@google.com, kuba@kernel.org, tannerlove@google.com
Subject: Re: [PATCH net-next v3 0/3] virtio_net: add optional flow
 dissection in virtio_net_hdr_to_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 02 Jun 2021 13:10:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove.kernel@gmail.com>
Date: Tue,  1 Jun 2021 18:18:37 -0400

> From: Tanner Love <tannerlove@google.com>
> 
> First patch extends the flow dissector BPF program type to accept
> virtio-net header members.
> 
> Second patch uses this feature to add optional flow dissection in
> virtio_net_hdr_to_skb(). This allows admins to define permitted
> packets more strictly, for example dropping deprecated UDP_UFO
> packets.
> 
> Third patch extends kselftest to cover this feature.

Definitely need some bpf review of these changes.

Alexei, Daniel?

Thanks.
