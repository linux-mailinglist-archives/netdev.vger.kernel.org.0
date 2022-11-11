Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003B3624FFF
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiKKCJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKKCJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:09:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE29B31ECF;
        Thu, 10 Nov 2022 18:09:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ABC2B822D7;
        Fri, 11 Nov 2022 02:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8E5C433D7;
        Fri, 11 Nov 2022 02:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668132583;
        bh=qcXT7KsM5AB7BhN9n5UAOoecfPi2ohVfDNCAo8pmWak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BOWE3xASGTo5opUTU8n+qd6emXvNL4zBwG74lih/1WEmy+PNHIwvmzgCgVTU2IHSS
         AAsn7ZLfk1l6dVi9t2VwT0/dOTi9/iZKnNoTnWC50RO3jhOvuSqfj6By3GNDoL0MHM
         CjeAKkXKacSUAch/n80gUJK11yEn/qWRCg0My80tEHQe5i1GazAJM2T6tQU+v2jZ9X
         RdB9Sv8BB9P6bM5MDhRKcV8mQYgTxOa3wcDxGtQkoJh+OTHFU1ONmGZc/KdjinFwj4
         w3dvHijRNpqrO3ZDfSZvgWkm6QLdfApI3TSlyJqVGid9eIqUHsKOTlLkDIr3JEM1Oh
         oTbAGcfhs8y+g==
Date:   Thu, 10 Nov 2022 18:09:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: ethernet: mtk_eth_soc: set
 NETIF_F_ALL_TSO
Message-ID: <20221110180941.11eff62e@kernel.org>
In-Reply-To: <20221109163426.76164-12-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
        <20221109163426.76164-12-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Nov 2022 17:34:25 +0100 Felix Fietkau wrote:
> Significantly improves performance by avoiding unnecessary segmentation

NETIF_F_TSO_ECN is the bit that matters here, right?
It'd be reassuring if the commit message mentioned it and confirmed 
it works correctly :S
