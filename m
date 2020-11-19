Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D4D2B8995
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgKSB1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbgKSB1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:27:35 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3B5246C0;
        Thu, 19 Nov 2020 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605749254;
        bh=6D3h9zJyPvc63AfhEHi1wKuiBsXiz2ShOSDSYpAIaKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I9KRbUaapoMZx3AapnzcTSse5Y5y3cObiBp5eS1imTkV+8i/+D08adwOWU+784sTU
         82AGXdqE/BjQ3xmTQSeI0OtFNcDz11vO2XoTNcWpVUjcoe8b46u7SNfSeOVQnxvQsL
         snCpFHc0rR87YbQY+MGVaMe+7v6R4frIjECqA/Uw=
Date:   Wed, 18 Nov 2020 17:27:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: remove not needed check in
 rtl8169_start_xmit
Message-ID: <20201118172733.5beac078@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6965d665-6c50-90c5-70e6-0bb335d4ea47@gmail.com>
References: <6965d665-6c50-90c5-70e6-0bb335d4ea47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 21:34:09 +0100 Heiner Kallweit wrote:
> In rtl_tx() the released descriptors are zero'ed by
> rtl8169_unmap_tx_skb(). And in the beginning of rtl8169_start_xmit()
> we check that enough descriptors are free, therefore there's no way
> the DescOwn bit can be set here.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
