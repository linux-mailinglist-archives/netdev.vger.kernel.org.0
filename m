Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8F04BADDA
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 01:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiBRAEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 19:04:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBRAED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 19:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6D14D25F;
        Thu, 17 Feb 2022 16:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6C6961A5A;
        Fri, 18 Feb 2022 00:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90E9C340E8;
        Fri, 18 Feb 2022 00:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645142606;
        bh=Zv4nvLsa1Tz4/lxRSyGoV0jhg3MpoCzqCgSrpjIkfLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BbWmlFqi6zB3YfJpvqk+iTY89arpsUMOLKUUti2Pg7IkagXT7+pNXdU6oTc3Kxj3K
         oBfG4jz5xrO/q0AWUurDg5NR7PaI0LY10B3wGkde1Q4qBRjNP9CfoxSwuwwz7zTBrp
         /a7zrFuax9iCCeLPZLkGb2O9tzvVMhPZu/a0tRGTG/gKuPfv2ys66bsQo/DLlr4oXD
         valxWP/UrcmwjIA5Q7zodEh94I/Se5WQbP23v8lsGzujRyMyAHJK5TY2PVqAA2NLGt
         JNxYssHM1ClAPTlhoH3pgC+xLRObUchfq2bb9k1ez1EoN5qsUb3TvWOJk1wti8gUye
         mppLD/ySfGI5w==
Date:   Thu, 17 Feb 2022 16:03:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH 0/3] RVU AF and NETDEV drivers' PTP updates.
Message-ID: <20220217160324.52c7ce0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217180450.21721-1-rsaladi2@marvell.com>
References: <20220217180450.21721-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 23:34:47 +0530 Rakesh Babu Saladi wrote:
> The following patch series contains the workarounds and new features that
> are added to RVU AF and NETDEV drivers w.r.t PTP.
> 
> Patch 1: This patch introduces timestamp counter so that subsequent
> PTP_CLOCK_HI can be obtained directly instead of processing a mbox
> request.
> Patch 2: Add suppot such that RVU drivers support new timestamp format.
> Patch 3: This patch adds workaround for PTP errata.

You need to CC Richard Cochran <richardcochran@gmail.com> on PTP
related patches, please add him and repost.
