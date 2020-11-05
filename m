Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388562A74F5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgKEBgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKEBgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:36:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1610520825;
        Thu,  5 Nov 2020 01:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604540177;
        bh=1ttN5AeD1yps0Zv8nSd+HRQ/QCmn3EcoFOvRmO35RM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j/ZwLBC6MSV7KjV4bXz8SqtWrz2LI9GcU3whWV+rciRwHOZ4GZdrHNIE3h2Au1Rvi
         /bLMf/mDbY5Hv0x0ogi0WUcal9CNl/7iCT52N8tYDSTw/ho3h9SNlR/qAIPuAxrTYO
         EKOvPuj7mZW/TvyRU40M4WZ51bhg0R7utEO4VY/s=
Date:   Wed, 4 Nov 2020 17:36:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] enetc: Remove Tx checksumming offload code
Message-ID: <20201104173616.7cbc42d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103140213.3294-1-claudiu.manoil@nxp.com>
References: <20201103140213.3294-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 16:02:13 +0200 Claudiu Manoil wrote:
> Tx checksumming has been defeatured and completely removed
> from the h/w reference manual. Made a little cleanup for the
> TSE case as this is complementary code.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks!
