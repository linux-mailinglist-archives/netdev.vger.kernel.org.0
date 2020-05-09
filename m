Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FAA1CBC2D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgEIBq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEIBq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 21:46:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B26622184D;
        Sat,  9 May 2020 01:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588988789;
        bh=Aia1eRn1IZk0ij0AFrGXq6rXZoOOlH8Fd531yVcT1rs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fqfe8oa6UGXBiVOJTjA/Q9FhJe5lxKJskZNXQWOBRussAt1zWZOsGNHNzG9I7oj2s
         cjugEVaWFCMt5BwM/j/uvN+4X0Xn+qu3hadpraHU/4k8lwK1IK+l/DVtknMtuid6SC
         fLc4zxlfz0ZbqnH8NRZTHFQxucuvwRQ4P+JOWOy8=
Date:   Fri, 8 May 2020 18:46:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] dpaa2-eth: prevent array underflow in
 update_cls_rule()
Message-ID: <20200508184627.70e76aa3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508143720.GA410645@mwanda>
References: <20200508143720.GA410645@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 17:37:20 +0300 Dan Carpenter wrote:
> The "location" is controlled by the user via the ethtool_set_rxnfc()
> function.  This update_cls_rule() function checks for array overflows
> but it doesn't check if the value is negative.  I have changed the type
> to unsigned to prevent array underflows.
> 
> Fixes: afb90dbb5f78 ("dpaa2-eth: Add ethtool support for flow classification")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thank you!
