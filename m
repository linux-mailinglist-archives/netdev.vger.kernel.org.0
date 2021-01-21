Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C22FE1CC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbhAUFf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbhAUFec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:34:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 372C72389A;
        Thu, 21 Jan 2021 05:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611207229;
        bh=2UnEvdUH9QbaaFTzFTLIMRUSYEpBIP7F70hOldBeH0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XiYjkSKrSNZ6rKQO2RBKyYOfa3JnsxvYFc+UjqaJuNNr7yyGPvws0/1m/cTO45y8w
         4P0knwYi0H5EvHqELc5xHsr0g//g+3WoDVQaPjO8MqTBC1NauHfNB6KueRf/UBJpGT
         qImcaJxqjv5cHdAKmzWGydoXnrPRaiD+eQ3rEn6OZ7I3CbD/mBsXke+8V5+Xe1GllD
         N1mrJn2qqcmXEwcsjV1+IIIPWyEeG8FPIseF/XhS5J3PvWDLdj88LPLUNsakKh8RrC
         n+38DZF+h1Taws4MHXy4R5JkT5HCNolRjbEfExVNbaiPQfCR7SoNOJE/qSiYdkQ0X3
         yauI0khmuNhpA==
Date:   Wed, 20 Jan 2021 21:33:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, elder@kernel.org, bjorn.andersson@linaro.org,
        agross@kernel.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, robh+dt@kernel.org, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/4] net: ipa: remove a build dependency
Message-ID: <20210120213348.75ca1a16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120212606.12556-1-elder@linaro.org>
References: <20210120212606.12556-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 15:26:02 -0600 Alex Elder wrote:
> (David/Jakub, please take these all through net-next if they are
> acceptable to you, once Rob has acked the binding.  Rob, please ack
> if the binding looks OK to you.)
> 
> Version 3 removes the "Fixes" tag from the first patch, and updates
> the addressee list to include some people I apparently missed.
> 
> Version 2 includes <.../arm-gic.h> rather than <.../irq.h> in the
> example section of the DT binding, to ensure GIC_SPI is defined.
> I verified this passes "make dt_bindings_check".
> 
> The rest of the series is unchanged.  Below is the original cover
> letter.

Hi!

Looks like this series has been impacted by vger's flakiness [1], if 
it doesn't get through and have patchwork checks run within 24 hours,
could you repost?

[1] https://patchwork.kernel.org/project/netdevbpf/list/?series=418685
