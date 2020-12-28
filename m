Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1B2E6C20
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgL1Wzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbgL1WPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:15:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CA722262;
        Mon, 28 Dec 2020 22:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609193681;
        bh=5WF1F4I/HlY7Pf6X+3LJENgSRWkam7kk8BpzbnWHTCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N9YpxUdfu2p5hleQSG+Zekb4vria/USkss+ALyW3VoWZjSHZE4Rw3RH8Q4dQRrVUs
         tgrR1cTTdxn885bmMB3QOJVC+nuo2wTkzTdW7wbZvhJX88tid6pXaWutcIpcq3gr5F
         lx21KKKVi9awEFG91LPDEXZaz7CD0/OwjOXMI0d1UYqt001OyDYdnzNHIKNcZY9tL7
         e+AuSdlFlmtn3t4+3J/v7f+yhdw45ReJc83cnHpxa33ROyzTP+icdBA8sKtjVOBPFN
         hoFUcgAUHQP2cYPe6iaPxqEYyqzqsAPWAbuY///yU8Bfw+Aik+yTubVpjeW8dRtLqt
         ORXN/xdBnApag==
Date:   Mon, 28 Dec 2020 14:14:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: ipa: fix some new build warnings
Message-ID: <20201228141439.15b83fbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201226213737.338928-1-elder@linaro.org>
References: <20201226213737.338928-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Dec 2020 15:37:35 -0600 Alex Elder wrote:
> I got a super friendly message from the Intel kernel test robot that
> pointed out that two patches I posted last week caused new build
> warnings.  I already had these problems fixed in my own tree but
> the fix was not included in what I sent out last week.
> 
> I regret the error.

If only it could have been caught with COMPILE_TEST.. ;)

Applied, thanks!
