Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D85F2A5C04
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKDBhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:37:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDBhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:37:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1B7223C7;
        Wed,  4 Nov 2020 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453825;
        bh=qELd+oak9OzROH7b+3q/6L2jVNFEXZoqqfSbtdDbKTA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hkhEDRUR67Q5RN8F+GzqNQqOKvnMNdzgTCm7Orf6+GWW4Qu6lyKKhTjxXwHk9qqZh
         UY6JvR3hAi/aWOkIrEqnta+n5ddb+tU/KtZUh/PRS3Ixs/oCGwQJh4fgiuDK99uAJG
         TDIlAH307KibCZA8+xX3bwvB/0MTZiMZA/yP1FCk=
Date:   Tue, 3 Nov 2020 17:37:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: align number of tx descriptors with
 vendor driver
Message-ID: <20201103173704.3bc28fbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a52a6de4-f792-5038-ae2f-240d3b7860eb@gmail.com>
References: <a52a6de4-f792-5038-ae2f-240d3b7860eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Nov 2020 23:23:52 +0100 Heiner Kallweit wrote:
> Lowest number of tx descriptors used in the vendor drivers is 256 in
> r8169. r8101/r8168/r8125 use 1024 what seems to be the hw limit. Stay
> on the safe side and go with 256, same as number of rx descriptors.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
