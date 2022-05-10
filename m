Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C95520A53
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiEJAqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiEJAqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:46:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E84F3E5DD
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5438CE1BDA
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EE8C385C5;
        Tue, 10 May 2022 00:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652143356;
        bh=cDwM/7V/mBK5JjtoEgE26zbtnbQghumeTSPVtAnEuPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C12rXeSwrNF6LK1buYkAkNDCsgkINMkBnRp9pMdwGpCmWcWTgPd+8udy4s5LBVlWY
         XNjoaFvDBU3Tf2tiEEuyRRraKtgkZ6BIU9Fjw44LfdkBHMYyZ8AzQ/rOPfasWhL+DD
         pCmFwWc26lESvI5b+e/C57nPqRuglGFg9sul5r3v2aazh0/cq11zyvT4mtqBDXdMqa
         FfjTAezrXq2dYz2f/ynii/G6u3Bnhh22Kt2F/QXLlhzhGmKgLAx5edEmHymxPxNPhp
         IiOV44mBU9K7yc6HA9rdW5OGJ82oWhuBmRO0cs+WxBh5LBV018mTPXdJZAyrRII4VE
         K3ZxJggNwzGlA==
Date:   Mon, 9 May 2022 17:42:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     <pabeni@redhat.com>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH V3] octeontx2-pf: Add support for adaptive interrupt
 coalescing
Message-ID: <20220509174234.4a31ff92@kernel.org>
In-Reply-To: <20220509174145.629b04df@kernel.org>
References: <20220506054519.323295-1-sumang@marvell.com>
        <20220509174145.629b04df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 17:41:45 -0700 Jakub Kicinski wrote:
> On Fri, 6 May 2022 11:15:19 +0530 Suman Ghosh wrote:
> > Added support for adaptive IRQ coalescing. It uses net_dim
> > algorithm to find the suitable delay/IRQ count based on the
> > current packet rate.
> > 
> > Signed-off-by: Suman Ghosh <sumang@marvell.com>
> > Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>  
> 
> Have you tested this?

It doesn't apply to net-next.
