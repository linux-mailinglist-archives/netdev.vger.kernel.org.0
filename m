Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61AB29F0D9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgJ2QLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJ2QLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 12:11:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0452076E;
        Thu, 29 Oct 2020 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603987899;
        bh=yiyxXNfaHBi2jNfr6DK6HUxcREqq8Y9pcYx+tz4qxC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fhzrcmMACRTv8LOonzcDi0fSniwqcue1DSZbXblSfHWGbvBTonCTPDDVDk4PuBMZZ
         /x6Vq6oAPPbikd7bZ88PReA9FYxw24pM9zQ0f9uqRuVKka4xHJS3VrCgxpZKJBqIxI
         oRVTdmO8mIiTAhGPnNkIzPh36HQFTzeMDjL5bb7w=
Date:   Thu, 29 Oct 2020 09:11:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 0/5] net: ipa: minor bug fixes
Message-ID: <20201029091137.1ea13ecb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028194148.6659-1-elder@linaro.org>
References: <20201028194148.6659-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 14:41:43 -0500 Alex Elder wrote:
> This series fixes several bugs.  They are minor, in that the code
> currently works on supported platforms even without these patches
> applied, but they're bugs nevertheless and should be fixed.

By which you mean "it seems to work just fine most of the time" or "the
current code does not exercise this paths/functionally these bugs don't
matter for current platforms".
