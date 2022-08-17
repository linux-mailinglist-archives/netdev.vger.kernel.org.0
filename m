Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D5259736C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbiHQP6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbiHQP6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E265870E4E;
        Wed, 17 Aug 2022 08:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 801AF6159B;
        Wed, 17 Aug 2022 15:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92959C433D6;
        Wed, 17 Aug 2022 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660751922;
        bh=PZD+fbtKCdoJeCd+nMgozddq+hp252RrNCHwzpmto0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CyUwpAc2WUAswrxXLt4JQzIdXVQ0z6AP0RBGETcaIzi8jGh4G/bAOTqenUrnBFQo3
         IGY139W3m6qd7mL5qXuTrFb7CEd5ZyTDa3In5QZO15dFvqWFwXj99MH1w1lfw8pLCs
         rpbzV2J1f7KV2ccFUFa/gag3HCqlhr7otUbC658LSeqTb5rz+XV1dQLKEnBZTnZhI+
         PlAYF6z4bs7z0T9RzMxM+VkeUgao1KaHMlUan3DBfGUxKF6RNWjN8X7C/iwCEX8Yuk
         chtza0hBcsMxYwdLNa2jkUhbUj84BnPVk7pSWnmKOgjpSPL/VxAhXoz40V6Erf4aoH
         wIwl+hL7OlFog==
Date:   Wed, 17 Aug 2022 08:58:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around net.core.XXX
 (Round 1)
Message-ID: <20220817085841.60ef3b85@kernel.org>
In-Reply-To: <20220816165848.97512-1-kuniyu@amazon.com>
References: <20220816092703.7fe8cbb6@kernel.org>
        <20220816165848.97512-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 09:58:48 -0700 Kuniyuki Iwashima wrote:
> From:   Jakub Kicinski <kuba@kernel.org>
> Date:   Tue, 16 Aug 2022 09:27:03 -0700
> > On Mon, 15 Aug 2022 22:23:32 -0700 Kuniyuki Iwashima wrote:  
> > >   bpf: Fix data-races around bpf_jit_enable.
> > >   bpf: Fix data-races around bpf_jit_harden.
> > >   bpf: Fix data-races around bpf_jit_kallsyms.
> > >   bpf: Fix a data-race around bpf_jit_limit.  
> > 
> > The BPF stuff needs to go via the BPF tree, or get an ack from the BPF
> > maintainers. I see Daniel is CCed on some of the patches but not all.  
> 
> Sorry, I just added the author in CC.
> Thanks for CCing bpf mailing list, I'll wait an ACK from them.

So we got no reply from BPF folks and the patch got marked as Changes
Requested overnight, so probably best if you split the series up 
and send to appropriate trees.
