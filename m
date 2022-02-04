Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D615C4A9CFB
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376610AbiBDQbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376597AbiBDQbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 11:31:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4124C061714;
        Fri,  4 Feb 2022 08:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 726226194F;
        Fri,  4 Feb 2022 16:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67995C004E1;
        Fri,  4 Feb 2022 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643992268;
        bh=Qw5TbPRwqc1e4qa6LC9hxiEmKOWkT0VWlgphBEBrzhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KZFlgs78UMxi0aTlPwGizoMBuPzrJ03x/wI3w792/FkWiXdvGiLrQnCwMg7vLungz
         pi+mUIEJtrfpTMzDt8HTJUnNAufqc/5TbFpRSc5AUelqgGlEPRLfIOtbfu8uooAGpV
         5QRTJrPqMioqDP/Irkqn2JdzKjUgQdODyuQHTmFCePlcXR6EV3L9+vSI4cMUm5NcIf
         VzDKO0V3dfrAcPJvyGUY6DQOjE5SaaI67LnaexUIFctwhJgDLBdi7b289jjYx/wR1Z
         BC6XS+XHFI/4UGp9EP2/PABFqtZwymWVATVlcZa9wFFvFSyUcmhIPq5JudXKsmsNTD
         BLQEj1Rp7LBuw==
Date:   Fri, 4 Feb 2022 08:31:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 1/4] net: dev: Remove preempt_disable() and
 get_cpu() in netif_rx_internal().
Message-ID: <20220204083107.02dbf3d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yf1EWFgPtjIq3Hzw@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
        <20220202122848.647635-2-bigeasy@linutronix.de>
        <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
        <87v8xwb1o9.fsf@toke.dk>
        <YfvH9YpKTIU4EByk@linutronix.de>
        <87leysazrq.fsf@toke.dk>
        <Yf1EWFgPtjIq3Hzw@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 16:20:56 +0100 Sebastian Andrzej Siewior wrote:
> Subject: [PATCH net-next v2 1/4] net: dev: Remove preempt_disable() and  get_cpu() in netif_rx_internal().

FWIW, you'll need to repost the full series for it to be applied at 
the end. It'd be useful to add RFC in the subject of the one-off update
patches, maybe, so that I know that you know and patchwork knows that
we both know that a full repost will come. A little circle of knowing.
