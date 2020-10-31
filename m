Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7788F2A1A87
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 21:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgJaUZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 16:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgJaUZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 16:25:32 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA682072C;
        Sat, 31 Oct 2020 20:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604175932;
        bh=yWDHBhYC9622aeKfnkqffoy81tyIUzEKBKQvJFIrfLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=op3r6uH4tbJifb3/LS3Uxan9giYjgSPBbsMnaJ9jJcMBWu0atQfuhMTjk0IVmVqwV
         AxwNkccknCeq837lhsh7OUxBZHUDPt59VB6DwgM55ne1FL2ZdQHwchrmk2ErI1ZYVP
         yy5FoZ+sooyRYyX5yhmJfYcHFOQF4STSAsikvPYc=
Date:   Sat, 31 Oct 2020 13:25:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: avoid a bogus warning
Message-ID: <20201031132531.1e179ab5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031151524.32132-1-elder@linaro.org>
References: <20201031151524.32132-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 10:15:24 -0500 Alex Elder wrote:
> The previous commit added support for IPA having up to six source
> and destination resources.  But currently nothing uses more than
> four.  (Five of each are used in a newer version of the hardware.)
> 
> I find that in one of my build environments the compiler complains
> about newly-added code in two spots.  Inspection shows that the
> warnings have no merit, but this compiler does not recognize that.
> 
>     ipa_main.c:457:39: warning: array index 5 is past the end of the
>         array (which contains 4 elements) [-Warray-bounds]
>     (and the same warning at line 483)
> 
> We can make this warning go away by changing the number of elements
> in the source and destination resource limit arrays--now rather than
> waiting until we need it to support the newer hardware.  This change
> was coming soon anyway; make it now to get rid of the warning.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks!
