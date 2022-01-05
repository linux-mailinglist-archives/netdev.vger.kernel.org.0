Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F60484C54
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 03:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiAECKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 21:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiAECKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 21:10:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10842C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 18:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 290E6B818BE
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29BFC36AED;
        Wed,  5 Jan 2022 02:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641348601;
        bh=j09/AaE97doM+ui5KdlJaYuVU3BXx/UrRMPcBKndIkg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XtHwn89JaQ9vm3uiRyZD3gEQUrKBrY7K4HhJcoNXgOuBgmpx+wYq259UAsJt4OIAk
         Co+1IJK8mPshKEMdNAiplQhBVNPqVciOv0LH0i/VC8W2uHLKKj7WmkP70qo5oz6D1m
         LDto1i6AWvdyP9kdZ8wlvliq6M4q2117wOA/Pt9A0GtEH36BmF8Gi+fg36m/UdroM4
         nOSrLjpqBXmE1wvJ6F3Nsg6bwSs4ddb3mxZyFyF9aMNBVZikRot7QijMHTe+BlT0D2
         TU7xUWtd2oiSKqoO5Sm3eImJFfRNcCusOQJd5r4+HXNjz4Wlrs+qsNAv8zh0n9MTDq
         iXHige4OUhLUQ==
Date:   Tue, 4 Jan 2022 18:09:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
Message-ID: <20220104180959.1291af97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104064657.2095041-3-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
        <20220104064657.2095041-3-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 22:46:51 -0800 Dimitris Michailidis wrote:
> Fungible cards have a number of different PCI functions and thus
> different drivers, all of which use a common method to initialize and
> interact with the device. This commit adds a library module that
> collects these common mechanisms. They mainly deal with device
> initialization, setting up and destroying queues, and operating an admin
> queue. A subset of the FW interface is also included here.
> 
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

CHECK: Unnecessary parentheses around 'fdev->admin_q->rq_depth > 0'
#630: FILE: drivers/net/ethernet/fungible/funcore/fun_dev.c:584:
+	if (cq_count < 2 || sq_count < 2 + (fdev->admin_q->rq_depth > 0))
