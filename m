Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15882A5C70
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgKDB5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:57:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgKDB5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:57:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EDD2242B;
        Wed,  4 Nov 2020 01:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604455027;
        bh=uPS4Xl9+xcZPd/vo9gruoedMsKEUB2VJw508sB/x0zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GMKfP/pfP9ZgaNuNcDBV7OBvC938obVcmfjrk39UtKpy7nO8L9ZsScp4N6kkh/63y
         +0f1ydAooIFam270aLgkSOy4iCyfUtBSOEVVByP4HP/Yv0Yex7Td1cWomcsfugEBDk
         spIJQwidh7rmIXS98/Lu/VMl4260qY3fPPa4iYfg=
Date:   Tue, 3 Nov 2020 17:57:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: restrict special reset to IPA v3.5.1
Message-ID: <20201103175706.74fe1426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102173435.5987-1-elder@linaro.org>
References: <20201102173435.5987-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 11:34:35 -0600 Alex Elder wrote:
> With IPA v3.5.1, if IPA aggregation is active at the time an
> underlying GSI channel reset is performed, some special handling
> is required.
> 
> There is logic in ipa_endpoint_reset() that arranges for that
> special handling, but it's done for all hardware versions, not
> just IPA v3.5.1.
> 
> Fix the logic to properly restrict the special behavior.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks!
