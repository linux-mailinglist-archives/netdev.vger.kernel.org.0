Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF4A2891E0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390725AbgJITlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbgJITli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:41:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF29E22282;
        Fri,  9 Oct 2020 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602272498;
        bh=mArZadBSjRa/S1vzi4HlQnhoHdryVG+vihr0EWX38gI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dkl2+p0Gsq2V1bACwNaiJSPYlEomhzNrlKp2Dv6B7JChwIdb7GVYJFIUkxZhkxfq9
         Jx6/bbkzvFqqK6oqt6aplcFvZlJuN1LXoI/Bmb4ymshG2wofTibBEFHk/mVgeee/E7
         hnpPfbiVvd+MMHMcAawRcYj0Mjrnc9/lpxFioHUU=
Date:   Fri, 9 Oct 2020 12:41:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: ipa: only clear hardware state if setup
 has completed
Message-ID: <20201009124136.337093ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <65ea5328-9f15-5bb6-80e9-514970cd4380@linaro.org>
References: <20201006213047.31308-1-elder@linaro.org>
        <20201006213047.31308-2-elder@linaro.org>
        <20201009122517.02a53088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <65ea5328-9f15-5bb6-80e9-514970cd4380@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 14:39:45 -0500 Alex Elder wrote:
> > The only call site already checks setup_complete, so this is not needed,
> > no?  
> 
> Wow, you are correct.
> 
> I was mainly focused on the fact that the ipa_modem_crashed()
> call could happen asynchronously, and that it called
> ipa_table_reset() which requires IPA immediate commands.
> I should have followed it back to its callers.
> 
> I agree with you, this is not needed.  The other patch
> is definitely needed though.
> 
> Would you like me to re-post that single patch, or is
> it acceptable as-is?

Please repost, thank you!
