Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB844D903C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 00:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343660AbiCNXTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 19:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343659AbiCNXTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 19:19:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1493EAB1;
        Mon, 14 Mar 2022 16:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77DCDB8105A;
        Mon, 14 Mar 2022 23:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D44C340E9;
        Mon, 14 Mar 2022 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647299901;
        bh=rjNcPAQdK0WB+3bxsp1cff4tqXm1d3KBODgmzGOot4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=du+XF+j8lGCTXYbsWNazkOCMTHw6lItUGxxC3XD8pAnICdVnLLWb0cotH1Wm2pOp0
         Z6wo+gqT2e/IA4PCEcb29fWEsyZAsJw3ywWprx79K/P8mskU96g8Ed8+nIaLevJBCY
         8xwE/2RebjrJTVN9GcykiCCBWK6DN09j5YBk3RlTSlavPzrlEe2EkuMBl03b//1cZ4
         mTLZCe0s0ThngRttLSpT2rAfOIifHJMDDUY39/1s7L73DH5R8uijnlTKBKZ15ALntQ
         xej3Vao29q2WrVcEaUiA3L2EMZ4odgvB9ND8bEEj7/CcLuckEJyaqMXpPoErgBXOEC
         mepq3EM2cPUKA==
Date:   Mon, 14 Mar 2022 16:18:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20220314161820.1c783f28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314230719.GA16569@breakpoint.cc>
References: <20220312220315.64531-1-pablo@netfilter.org>
        <20220314155440.33149b87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220314230719.GA16569@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 00:07:19 +0100 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > Minor nit for the future - it'd still be useful to have Fixes tags even
> > for reverts or current release fixes so that lowly backporters (myself
> > included) do not have to dig into history to double confirm patches
> > are not needed in the production kernels we maintain. Thanks!  
> 
> Understood, will do so next time.
> 
> For the record, the tags would have been:
> 
> Fixes: 878aed8db324 ("netfilter: nat: force port remap to prevent shadowing well-known ports")
> Fixes: 4a6fbdd801e8 ("netfilter: conntrack: tag conntracks picked up in local out hook")
> Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")
> 
> ... all were merged v5.17-rc1 onwards.

Thanks!
