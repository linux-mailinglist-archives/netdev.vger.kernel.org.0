Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AFC43D92B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhJ1CJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhJ1CJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 22:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A43FF60E09;
        Thu, 28 Oct 2021 02:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635386837;
        bh=9sRzcYzl1Jwg5itW1Bu9y5K9LH4cTWi/7CCb3gUl85I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oN4Wqaf7QwWtEJWOn4M11/SNv/Cnw5kVEmAqOrte7GBbK8laPFaPAoVyThNlsPLKx
         fHhr1C70bUv9iXwjMFCk/sc5AGcicTamLwwsVSQyV8udb6NT03Th7HL8hofLxXBOOM
         9L4kJqRTc0aP2BOm7y4tfkMFzLMwMUYDo9B77t/hYFSUp5zkBMG69oTR0Nvm4H62hv
         s7pGiqyNK3kU/BIFYHlpN3B/VtGi9KevEQof/KrY5DD3eoil6Q7sMuqbFiL+NUILdJ
         IaRtct5EnU0pZxi5/kWZVcwE2trXg97mGc1jEr7rqTfVVo4HnXp43nPRUOvsasnBP4
         tSOhAi7x0B8KA==
Date:   Wed, 27 Oct 2021 19:07:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptp: Document the PTP_CLK_MAGIC ioctl number
Message-ID: <20211027190716.4429def0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211024163831.10200-1-rdunlap@infradead.org>
References: <20211024163831.10200-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Oct 2021 09:38:31 -0700 Randy Dunlap wrote:
> Add PTP_CLK_MAGIC to the userspace-api/ioctl/ioctl-number.rst
> documentation file.
> 
> Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks.
