Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5C22AFB1C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKKWIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgKKWIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:08:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85ADA2087D;
        Wed, 11 Nov 2020 22:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605132515;
        bh=1qnSQ1GSe5S57VzPYzkVYhQ8+cEdxNtHkv3n8f7R87k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=seNdpfTXQlNz7qBG2QtmW+E8IE+t0a/mxRMAJ4scqw/Ojw+RJFhEzdIm6GOg15ths
         e/klqrbj618rN4CRAo3TzdnIcR1NuIoWvrAzo3//Lw1tWU8ivAkbYSRh6ifiV1COjY
         vkLB1DxZ0ST0JvMM5/oOw74BOGn1PYzyTkobNK/k=
Date:   Wed, 11 Nov 2020 14:08:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: little fixes
Message-ID: <20201111140833.6acdf83e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109165635.5449-1-elder@linaro.org>
References: <20201109165635.5449-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 10:56:31 -0600 Alex Elder wrote:
> This series adds a few small fixes to the IPA code.
> 
> The first patch appeared in a different form in June, and got some
> pushback from David because he felt a problem that can be caught at
> build time *should* be caught at build time.
>   https://lore.kernel.org/netdev/20200610195332.2612233-1-elder@linaro.org/
> I agree with that, but in this case the "problem" was never actually
> a problem.  There's a little more explanation on the patch, but
> basically now we remove the BUILD_BUG_ON() call entirely.
> 
> The second deletes a line of code that isn't needed.
> 
> The third converts a warning message to be a debug, as requested by
> Stephen Boyd.
> 
> And the last one just gets rid of an error message that would be
> output after a different message had already reported a problem.

Applied, thanks!
