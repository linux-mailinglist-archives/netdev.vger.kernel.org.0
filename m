Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352C641F586
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 21:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356002AbhJATM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 15:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355581AbhJATMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 15:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E887061A56;
        Fri,  1 Oct 2021 19:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633115470;
        bh=fbYD/QbJuUTkeAvH7kyMCWoqTYT4+uu9wQmX8kV3Qfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=icdDzfvCcN1pOO8ckDAFXp1/UrCkr0Yb3zUznrd7/tZKd0Fye61oP/7SUXLl7Kwsp
         lfjAFYR/4dN0Bx4nDiP2zhRGTXPMSQver0i3/prP0UcOYp0NjRwBKT3NTkBg31s2Bp
         dllQnNFaYpFQQGUGuydTVQWGUdLC67sIpaSoy60FQnki29saeE39HAt6JbmhsqYsEc
         NHQpEjLkEdzbrxvgHA1vdFZxjnb/sFJ92/K571pXSPUCVhk2+ww4Tnl6NByLl6s9gc
         cGIF7MnB4Z3Nlqhlo5T6gsggByUav8OlmKLvsDtspBaH9MvZATmTutf7MMDgXDxeA6
         kvg3MYQAJEbyQ==
Date:   Fri, 1 Oct 2021 12:11:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net 1/1] ptp_pch: Load module automatically if ID
 matches
Message-ID: <20211001121109.64aaac57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001162033.13578-1-andriy.shevchenko@linux.intel.com>
References: <20211001162033.13578-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Oct 2021 19:20:33 +0300 Andy Shevchenko wrote:
> The driver can't be loaded automatically because it misses
> module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
> call to the driver.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Could you reply with a Fixes tag? (no need to resend, I think)
