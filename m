Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AA8259E5E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgIASrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgIASre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:47:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9869C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:47:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9768C13630BCF;
        Tue,  1 Sep 2020 11:30:46 -0700 (PDT)
Date:   Tue, 01 Sep 2020 11:47:32 -0700 (PDT)
Message-Id: <20200901.114732.1206867680814103555.davem@davemloft.net>
To:     yhayakawa3720@gmail.com
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        michio.honda@ed.ac.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901135945.57072-1-yutaro.hayakawa@linecorp.com>
References: <20200831113010.0107dc5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200901135945.57072-1-yutaro.hayakawa@linecorp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 11:30:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yutaro Hayakawa <yhayakawa3720@gmail.com>
Date: Tue,  1 Sep 2020 22:59:45 +0900

> From: Yutaro Hayakawa <yhayakawa3720@gmail.com>
> 
> Implement the getsockopt SOL_TLS TLS_RX which is currently missing. The
> primary usecase is to use it in conjunction with TCP_REPAIR to
> checkpoint/restore the TLS record layer state.
> 
> TLS connection state usually exists on the user space library. So
> basically we can easily extract it from there, but when the TLS
> connections are delegated to the kTLS, it is not the case. We need to
> have a way to extract the TLS state from the kernel for both of TX and
> RX side.
> 
> The new TLS_RX getsockopt copies the crypto_info to user in the same
> way as TLS_TX does.
> 
> We have described use cases in our research work in Netdev 0x14
> Transport Workshop [1].
> 
> Also, there is an TLS implementation called tlse [2] which supports
> TLS connection migration. They have support of kTLS and their code
> shows that they are expecting the future support of this option.
> 
> [1] https://speakerdeck.com/yutarohayakawa/prism-proxies-without-the-pain
> [2] https://github.com/eduardsui/tlse
> 
> Signed-off-by: Yutaro Hayakawa <yhayakawa3720@gmail.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Applied, thank you.
