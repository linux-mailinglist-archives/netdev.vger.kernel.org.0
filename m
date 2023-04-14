Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC346E2B79
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDNVGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDNVGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:06:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04CA9B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:06:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pnQd2-0004Hd-EW; Fri, 14 Apr 2023 23:06:44 +0200
Date:   Fri, 14 Apr 2023 23:06:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net-next 4/5] net: skbuff: push nf_trace down the bitfield
Message-ID: <20230414210644.GB5927@breakpoint.cc>
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414160105.172125-5-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> nf_trace is a debug feature, AFAIU, and yet it sits oddly
> high in the sk_buff bitfield. Move it down, pushing up
> dst_pending_confirm and inner_protocol_type.

Yes, its a debug feature and can be moved.

Acked-by: Florian Westphal <fw@strlen.de>
