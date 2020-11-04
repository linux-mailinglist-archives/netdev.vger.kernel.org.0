Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2CB2A7002
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgKDV65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbgKDV63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 16:58:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93EBE20795;
        Wed,  4 Nov 2020 21:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604527109;
        bh=UggdVEvTS+sD1iHCFJL3t3kpiLmy6CJ9a/2imKYKIpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KqWkKydtgAj/mvBdT39fr0UHxcrcsHDDYfmIsgycofBcFYIZmPLULA+raQXVwCR2B
         M4EkvMoUs4NMlSIxlDYniib1MixWg/Y16Yr6mYpc/T8+nIt4mSxjANvexcIPeIJAYY
         iNEkM3iV9djixV3rlMGr7TAzsLLv18aTOdSxvUxY=
Date:   Wed, 4 Nov 2020 13:58:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] lan743x: correctly handle chips with internal PHY
Message-ID: <20201104135827.0140aca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104160847.30049-1-TheSven73@gmail.com>
References: <20201104160847.30049-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 11:08:47 -0500 Sven Van Asbroeck wrote:
> Tested-by: Sven Van Asbroeck <TheSven73@gmail.com> # lan7430
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>

Not a big deal but if you have to change the patch could you make sure
your email address is spelled the same in the From line and other tags?
