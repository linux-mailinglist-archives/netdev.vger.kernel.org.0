Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F235D48B584
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244163AbiAKSOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243947AbiAKSOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:14:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB45BC061748;
        Tue, 11 Jan 2022 10:14:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66C4DB81C29;
        Tue, 11 Jan 2022 18:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DA2C36AE9;
        Tue, 11 Jan 2022 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641924859;
        bh=c5WJfVOY6Hdbl57bfmac8NzWCEU/nZ1dXMZn9S6Zdec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YkNjFqr7Fe/JJoXULlk+4YmO8f2Hmd4gBduz+z11XRF6BDpTtKCVVbQI0yD2awn3/
         YkDqS1IDpwjDsxFNDb41xLhrJS9fLtgdL0WUvySGbiolwKKpsjjCmL92st9lOuQjOU
         +3BP7V7IqZ3hrIRF0QglRVitAoA3xES+tepYneQOqyFw2948u2qVkje8rC8QmBctpA
         clJrdPDAuAOgFPSp7pcz7YsydYGImuXzbD1uJGOAeI8RFAckTxtQODq6uOilIGGhHK
         /k6IXGiWAONNzcVvKZfTJWqSSBbsfp6GlDaIoB02fQ1HuCJBbfBxfd+QGiz7gxyc1m
         T9gv8Eeoo8rAQ==
Date:   Tue, 11 Jan 2022 10:14:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after
 clcsock released
Message-ID: <20220111101417.04402570@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 17:38:25 +0800 Wen Gu wrote:
> -	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
> +	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
>  					     optval, optlen);

Please do realign the continuation line when moving the opening bracket.
