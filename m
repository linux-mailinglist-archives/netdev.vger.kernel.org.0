Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738532B0C43
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgKLSFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgKLSFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 13:05:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11D5822201;
        Thu, 12 Nov 2020 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605204345;
        bh=NN2RmnkMHYhHjjqXsr30dnhfEfppsmxzdtW1JJjpc/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=chT6NP6nq7GUq+nivv771+cevAkixfBFyKimC5yrhTUEFUylO3CSzcV1jLITUkXdM
         v+erJvpwrl650PstwPfnPN0CHZ/dE0vXZbAyyqDS5BgNCRmFQ+AbPmApjRyJz7+UqU
         nZmn3PBXwE4X8W9t7d2bgIjcEBb6OmKrvTSH6ucw=
Date:   Thu, 12 Nov 2020 10:05:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] lan743x: fix use of uninitialized variable
Message-ID: <20201112100539.172ed3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112152513.1941-1-TheSven73@gmail.com>
References: <20201112152513.1941-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 10:25:13 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> When no devicetree is present, the driver will use an
> uninitialized variable.
> 
> Fix by initializing this variable.
> 
> Fixes: 902a66e08cea ("lan743x: correctly handle chips with internal PHY")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Applied, thanks!
