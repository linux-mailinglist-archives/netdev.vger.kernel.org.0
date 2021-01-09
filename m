Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402BC2F03ED
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbhAIVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbhAIVyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:54:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D75EA23AA8;
        Sat,  9 Jan 2021 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610229223;
        bh=RChtS1oTh0rfOykn8XW4E88jDrYi8KI3RLL0HuRlA5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UfYttTUKlCRyptGUtgM8mliNmRdz9VreRoXmYfgj3kG9RMMyha7Nem1jxN5KzTdTt
         a39EQ4zEyFH7JsavKDTg6FJ/arJ3TTQFsJnX8JgZ9vvnvfeAOVwhuqbIDtcQzTcN3E
         L0XcEPVUozxmhe7x552PJU5I1LLheEy+HoBuwpZlb+0WkoI60uQEd0xATbtjuVI7Hr
         fddCfV6nBrF9EWmYTobZq6KJ2i8ufkRZfUFYdALDIisJo9GoOoMR7htrOAl0tzKNRx
         rRw/PIwooulyxd9v9X+t398ryE+z/3MJb6WfA4BEAgq2k4F1lkeznBVM8YwPT342lx
         v4klwYfjHmgdQ==
Date:   Sat, 9 Jan 2021 13:53:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org, agross@kernel.org,
        ohad@wizery.com, evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: support COMPILE_TEST
Message-ID: <20210109135342.2c31836d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107233404.17030-1-elder@linaro.org>
References: <20210107233404.17030-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 17:34:00 -0600 Alex Elder wrote:
> This series adds the IPA driver as a possible target when
> the COMPILE_TEST configuration is enabled.  Two small changes to
> dependent subsystems needed to be made for this to work.
> 
> Version 2 of this series adds one more patch, which adds the
> declation of struct page to "gsi_trans.h".  The Intel kernel test
> robot reported that this was a problem for the alpha build.
> 
> David/Jakub, please take all four of these patches through the
> net-next tree if you find them acceptable.

Applied, thanks a lot for doing this!
