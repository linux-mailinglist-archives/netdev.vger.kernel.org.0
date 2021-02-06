Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD7D31205C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 23:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBFW65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 17:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFW64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 17:58:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D464A64E33;
        Sat,  6 Feb 2021 22:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612652296;
        bh=QAqNyRM5hmPHOGZUsUZJhXXvXlIEDMHraTzFBBKjuis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h4VKX6fn6tyC5AJ7Kac2AS8J9yXLhCUapeDEEgbKluLVhJeOKU2gwg6/ZPIOvf3BP
         dq+S09hTNXsM+arUzefBZBV5RnCSXW9DFqhqjQw366VIsDD9gku/JuqSusQY9S8+kI
         2kNhQJ/tpHDNi/zCWpFB5E5LuggNkfL0Dqpg/OWaiFoLahmAPkZU4wqscQygtXKQBk
         /pQT6S50RZvl543XCXbY+9RUGJwnSuEed3IF3sWH4jkW0kcpU+mJ3l9Jy0XEUf+3BZ
         cb1MSx20R/hyI0mAvIAh4bB1bQUMCJwzIn2D6yg1LWYxkKfyL04ZvH/n7EN+qiO0gF
         KYMZl//E87fWw==
Date:   Sat, 6 Feb 2021 14:58:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] net: ipa: a mix of small improvements
Message-ID: <20210206145814.6a25b8dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205221100.1738-1-elder@linaro.org>
References: <20210205221100.1738-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 16:10:53 -0600 Alex Elder wrote:
> Version 2 of this series restructures a couple of the changed
> functions (in patches 1 and 2) to avoid blocks of indented code
> by returning early when possible, as suggested by Jakub.  The
> description of the first patch was changed as a result, to better
> reflect what the updated patch does.  It also fixes one spot I
> identified when updating the code, where gsi_channel_stop() was
> doing the wrong thing on error.

Fixed the repeated word in patch 1 and applied. Thanks!
