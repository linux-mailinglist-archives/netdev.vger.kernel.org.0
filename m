Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42412218FD
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgGPAiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 20:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgGPAiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 20:38:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222D920714;
        Thu, 16 Jul 2020 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859895;
        bh=fMguRxk5YbyxDc8dblHcOpQTdIQrnyQBfWGaSuabkj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0X1GljBXtjIMuJ/Tb4HJXvU2niiGeMyN/YBq/3avFnxcCtD7+HUtOahLT+6OlsNj6
         M8Ktac3a3V2pvjN78b2L5v5TZ2G8uOQOGslkgSf495b7k08YeSL0toWHiA4r6bvIG2
         G7sKbFR7O5gYvQQfamwvdraD57Nt13mLwf021few=
Date:   Wed, 15 Jul 2020 17:38:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] dpaa2-eth: check fsl_mc_get_endpoint for
 IS_ERR_OR_NULL()
Message-ID: <20200715173813.5711aeb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714120816.6929-1-ioana.ciornei@nxp.com>
References: <20200714120816.6929-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 15:08:16 +0300 Ioana Ciornei wrote:
> The fsl_mc_get_endpoint() function can return an error or directly a
> NULL pointer in case the peer device is not under the root DPRC
> container. Treat this case also, otherwise it would lead to a NULL
> pointer when trying to access the peer fsl_mc_device.
> 
> Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks!
