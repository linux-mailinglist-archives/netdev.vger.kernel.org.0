Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA1C2BB0FC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgKTQ4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:56:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730143AbgKTQ4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 11:56:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDFB62100A;
        Fri, 20 Nov 2020 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605891363;
        bh=XwBAqhn2BD+gCEBMM978l4Op29a6WhTi2llelBkBZHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYQCPYicvBTVe+cemaqTWr2oPP8us7bHJjWnPiRhs6ZQOGLdTTnloPxTFDwVxFkBD
         1NeP979PCIx0C5MXeN1SJx98pzrrQFMVfNdeYcklniEwM1L0w/zY4x0crJ/UbhYlgE
         PH34E3LQ/ws5f6R5g/NZ5tU5Cgp84Ha5HWCMJLPM=
Date:   Fri, 20 Nov 2020 08:56:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next resend 0/2] enetc: Clean endianness warnings up
Message-ID: <20201120085601.29b60268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119101215.19223-1-claudiu.manoil@nxp.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 12:12:13 +0200 Claudiu Manoil wrote:
> Cleanup patches to address the outstanding endianness issues
> in the driver reported by sparse.

Applied, thanks.
