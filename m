Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6E666AC6
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbjALFYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbjALFYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:24:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EF665C6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6900D61F66
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A86CC433D2;
        Thu, 12 Jan 2023 05:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673501057;
        bh=qmoGRLu4SwnxFbCe+Ux9mnVsJSwHWRxzge5yWXE/IZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4hLLOyoD6Jpp49YE4eqVSJ8TsoG2Wm25zFLLp6/E+piRd0sr9k9Yr1obr5DY8IU1
         ZWtNZyKz3IQiqAOKRnVf3MkmhvYTltag+J6c6m/3ySp8kU6JgTyJXbomm60hnbjWHi
         gj4VH9XZyWkCTlkmyRHXcSRWxWRpa0+FkiTBX8PD1X5ypejHtnyyeIa+PQ95tS2noT
         2dTNGRR540HgbirB9u22iBrJtlUaIRaTerROnwBReH6KW15Dh60CFvstl4uqXHtEKb
         cn43N27hcw3ZFf8dx/GnPq5pNOg717NJQ3+d9srrTgCCN8PQJ7o9CI7VPC5xUOwljZ
         GAgFSocNwgjOQ==
Date:   Wed, 11 Jan 2023 21:24:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: Re: [PATCH v2 net-next,0/8] octeontx2-af: Miscellaneous changes for
 CPT
Message-ID: <20230111212416.3319a128@kernel.org>
In-Reply-To: <20230112044147.931159-1-schalla@marvell.com>
References: <20230112044147.931159-1-schalla@marvell.com>
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

On Thu, 12 Jan 2023 10:11:39 +0530 Srujana Challa wrote:
> This patchset consists of miscellaneous changes for CPT.
> - Adds a new mailbox to reset the requested CPT LF.
> - Modify FLR sequence as per HW team suggested.
> - Adds support to recover CPT engines when they gets fault.
> - Updates CPT inbound inline IPsec configuration mailbox,
>   as per new generation of the OcteonTX2 chips.
> - Adds a new mailbox to return CPT FLT Interrupt info.

24 hours have not passed since your previous fumbled posting. 
Please keep that in mind going forward:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
