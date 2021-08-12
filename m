Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4669F3EA850
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhHLQO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhHLQNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 12:13:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA5160C40;
        Thu, 12 Aug 2021 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628784734;
        bh=ShLu6Cs04YmBeKmkwQLOjS/QsIIdAUMptYKQV6l+USc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PIbnWDU9+tVkFGSk+SsT8aRzl4TmQ1gsQK0u7VqzJnha39c+PbwnkITtOgXk5nMKq
         jsfD1kCATv5U0JJinwVuWw+EIFDYnMELzvOyaKE17RIyycANwn7b0HVYl9AAg7FI4Y
         wS2CRj+KuRSC3TtcXq+f35/8QT1m6vSivSfudXDRPrSdguVz3rosw2VF39fvXBy1AN
         mxxCGh3Fmh2QerI9ny3lB4LNr74cEp75OciMj+oLx33J3a1B3Azl5nDz5fs10l5mI4
         3JPjQZMSoyyHUN+71RnNBRR8KZyKDhI4LF+VpOc/WyBqKQxtQzBvgi9DINZSR+tPV6
         TSZ/TdQRA7KLg==
Date:   Thu, 12 Aug 2021 09:12:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        richard.laing@alliedtelesis.co.nz, linux-arm-msm@vger.kernel.org
Subject: Re: [RESEND] Conflict between char-misc and netdev
Message-ID: <20210812091212.0034a81c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812140518.GC7897@workstation>
References: <20210812133215.GB7897@workstation>
        <20210812065113.04cc1a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210812140518.GC7897@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 19:35:18 +0530 Manivannan Sadhasivam wrote:
> > About the situation at hand - is the commit buggy? Or is there work
> > that's pending in char-misc that's going to conflict in a major way? 
> > Any chance you could just merge the same patch into mhi and git will 
> > do its magic?  
> 
> I'm not happy with the MHI change and I do have a comment about the
> variable "mru_default". So it'd be good if we revert the commit
> entirely!

Would you mind rendering that comment you're referring to as a commit
message and sending a fix-up or a revert patch against net-next?
I wouldn't be able to do it justice.
