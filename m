Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B024DA77D
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352996AbiCPBsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbiCPBsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:48:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A948329
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 18:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B161061618
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB546C340E8;
        Wed, 16 Mar 2022 01:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647395215;
        bh=B/fBODX9xhQW15ZrgGqbVU2TPoFyMgZ+buflVH1JS/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hJmA5uDwVSEdxl4srFTF1tEnSZnyTChxloR7g0skBJVmteFb+h2OJE3XeYcgLRcJs
         WQfPAS/eV9nPeZ5t2KintrwzSeXOOKvRN9mgNivBBiGv6/7eV+8meW5Ywv5LUr1f9J
         GAM1t9kShF/kRcuhUpVuxW9N5AIGyqLWhXOVarmSO0IncVLpNvyxnAsVFlHZfmf6q0
         TILea7LRatVgMO7fQZB6teCgYhdFLLBPEMBMlcB1c0z+9fCj/hy+vcW5+iIGdrx2uG
         W3OfkhY10xfUKRgRZEJMIBp5E6TlzTUowQQQmS+SFGgDhF6okTlDvxpFBD/n8UtsxH
         TY/WxB+DKOlXg==
Date:   Tue, 15 Mar 2022 18:46:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/3] net/sched: add vlan push_eth and
 pop_eth action to the hardware IR
Message-ID: <20220315184654.4646139c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315110211.1581468-2-roid@nvidia.com>
References: <20220315110211.1581468-1-roid@nvidia.com>
        <20220315110211.1581468-2-roid@nvidia.com>
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

On Tue, 15 Mar 2022 13:02:09 +0200 Roi Dayan wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> Add vlan push_eth and pop_eth action to the hardware intermediate
> representation model which would subsequently allow it to be used
> by drivers for offload.
> 
> Signed-off-by: Maor Dickman <maord@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
