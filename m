Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC864A83B5
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350383AbiBCMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiBCMUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:20:20 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DDBC061714;
        Thu,  3 Feb 2022 04:20:20 -0800 (PST)
Date:   Thu, 3 Feb 2022 13:20:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643890819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=geZj16l1Sh5aq48+Nbhrn9TCaIQ/nXruupjQ9sDXkMM=;
        b=myp0JXMWyyXbhx3ACfbu9yYcdfOcmEOR3QxiVU+dm93qPX/KDA5hli10/j1xbOpPUAt0mH
        oBRFgaLqh0G1v1ROalV/6faTf9NfteR7WlM7IsU5bUlFP0nZCuvDiNqZTaiPIUNEuJUD96
        BVZ19Oee5kuy9IBs8x8C7f2CN1L2hGQAn6bSf3kbfYVuetWo+NYYssqd+ANV5/h3RVudH2
        L8DXnjOLIPFncl6vaqjaNJovDzpfw8Tk8A6R0qxSrS157QRea9jO7BjJKtMlqJeVeisItR
        XvdV72rwyqv73ALCkc6AKisqkP7mB+mSMMcBT/6KthcNPri0z8uTytEit0lVQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643890819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=geZj16l1Sh5aq48+Nbhrn9TCaIQ/nXruupjQ9sDXkMM=;
        b=1n68T/gs/AApGvNex0bBmEDNejAJD737kstjqi98pVjWiPvmQ1dS12oDYWDrY3OuKoOGKf
        WYnsLY4SvxlIuHAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <YfvIgdEmIh6cgk3f@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <20220202085004.6bab2fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220202085004.6bab2fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-02 08:50:04 [-0800], Jakub Kicinski wrote:
> On Wed,  2 Feb 2022 13:28:47 +0100 Sebastian Andrzej Siewior wrote:
> > so they can be removed once they are no more users left.
> 
> Any plans for doing the cleanup? 

Sure. If this is not rejected I can go and hunt netif_rx_ni() and
netif_rx_any_context().

Sebastian
