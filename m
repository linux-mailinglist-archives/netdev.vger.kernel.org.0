Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0649D2F4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiAZUAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiAZUAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAA4C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 092D361759
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 20:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F55C340E3;
        Wed, 26 Jan 2022 20:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643227200;
        bh=MCzNj8jUcxuRcAWIAa+PfeyM4MMgxGcPjMq9zrhpTGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q6JAEOTKnQwEt/yMI+BIzIdBzIY04wa8VhzSbZDTIBdtMEeeL6a5DXn2KRgQ+X/3w
         2rh+EJpNx2qUCh6eW9mHIZ1KCbXZ4cqBDu/dpQlPki4Rv/sUSjoWDDewCXfw6Oh8PU
         Nx6Y8b9u4LszWrPHCxtzWoavIe1SfDSgDZ+k6MraJlYr8pVBPiORIorjA7i8PM+q7/
         xRo+WhpH43GlXL73DpB0Aqhg5nE3eEtGVLqLiOIf2dIXWPsrMOHgirK/gjflOIwN+c
         iXGvVhgmnB1Mc5oFPNsl5+qi5uzp6WsVafjOE7Ln+mCcucZHJ4kHai3GYhvGsdh93f
         yckEbryYSLUVA==
Date:   Wed, 26 Jan 2022 11:59:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     <anthony.l.nguyen@intel.com>, <shiraz.saleem@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH] i40e: remove enum i40e_client_state
Message-ID: <20220126115959.56eee765@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <bb6675f9-63ce-77a2-e4fe-76cc592e5f41@intel.com>
References: <20220126185544.2787111-1-kuba@kernel.org>
        <bb6675f9-63ce-77a2-e4fe-76cc592e5f41@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 11:53:29 -0800 Jesse Brandeburg wrote:
> On 1/26/2022 10:55 AM, Jakub Kicinski wrote:
> > It's not used.  
> 
> minor nit, you didn't say if you wanted this to go to net or net-next or 
> add a Fixes: tag?

Right, I'm not targeting net or net-next directly. I should have put
something like "intel-next", probably.

> maybe:
> Fixes: e3219ce6a775 ("i40e: Add support for client interface for IWARP 
> driver")
> 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> for the patch itself, it looks fine to me, so if you spin this
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
