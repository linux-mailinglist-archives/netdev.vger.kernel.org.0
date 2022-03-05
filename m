Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDA44CE258
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiCEDAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 22:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCEDAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 22:00:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E1F53E2E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC3EAB827E6
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 02:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D23C340E9;
        Sat,  5 Mar 2022 02:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646449152;
        bh=3xJ5uoN04ZC7lIWibVFrATKZMPkJbeqRH7yIp3vPviQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lsX+tGzEgbImxjatlj0kStra5y46Olj4VVQ4/uGl98Jl8bYQmBhXeLiY5ovXpOWXF
         bnUc9p5ebmc/gPG/ZGl55Sf8VOb9oql2ezpyFH0LTW44ZUqgaYQlb+6grCHNBi/VWQ
         rB2KX3Nk4CCb5w5oaZT+jYV5J0F6WEWyP/8vLOuHDal3uY50oT+JU83R7WHHz5Hw0a
         tYZ1n7dzqhBhhZzlHxpJ5Ez51b4cJiVP/b94r4mnnbJeg4nC+OQ2k8byj+iNFJ9kWD
         hZ6bbVSEVmAJ+R0aIP5Cg++ITGNUtgk4Eg601eqjRhexpCNlwiC6G+Z8slpTm98l+k
         5pQbsSHRJ9f6A==
Date:   Fri, 4 Mar 2022 18:59:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 7/7] net: axienet: add coalesce timer
 ethtool configuration
Message-ID: <20220304185911.14b61973@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b2e8b639333ebd770297a5b654960f979dad5acd.camel@calian.com>
References: <20220305002305.1710462-1-robert.hancock@calian.com>
        <20220305002305.1710462-8-robert.hancock@calian.com>
        <b2e8b639333ebd770297a5b654960f979dad5acd.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Mar 2022 02:20:38 +0000 Robert Hancock wrote:
> > @@ -482,7 +482,9 @@ struct axienet_local {
> >  	int csum_offload_on_rx_path;
> >  
> >  	u32 coalesce_count_rx;
> > +	u32 coalesce_usec_rx;
> >  	u32 coalesce_count_tx;
> > +	u32 coalesce_usec_tx;  
> 
> Forgot the kerneldoc for these - another rev coming..

The mailing list is not for build testing patches. Please be more
careful, and leave at least 24 hours between posts so reviewers get
a chance to share additional comments.
