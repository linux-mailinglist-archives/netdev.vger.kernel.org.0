Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85BB2F84F9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbhAOTAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388178AbhAOTAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 14:00:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C84923A6C;
        Fri, 15 Jan 2021 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610737149;
        bh=SazCWWHvTOjLZ6hZbavd0eyLQqyhV/1N/6DfyhMU1ws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ngb2PbbCWqoTrLKOoBkhJ4UCg2GwTvs30X6EjqBqB8F7Gsdm9XCWdDkfoCqb/Q4DX
         7I0d51UTt+d3Y3DV+4v+tapNjXJOr5hoyrEdmnzInXfe4BtIuF6vo5iZwAFMrn1G5a
         oCwjHx9qa25RMPr/Q6FMUIUquXZwisR4rNzFg9YLUMfc0mx6ImawAdMfXcyvRwbPH5
         9ryRsMOXB4PtMv1+3Ms2Q1uOjMfHr8P3udyk/kAT0IyRkVemV+9zbMUobiD/CAiL4m
         iHhm+MsEWzbOYFpHerNEiW1etYF4aboHf7VgLPR3PmE3jdi5TgGxqt6d55ujFsfNFL
         pG1GB7KcVMzgg==
Date:   Fri, 15 Jan 2021 10:59:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Saeed Mahameed <saeed@kernel.org>, davem@davemloft.net,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI interrupt updates
Message-ID: <20210115105908.64cfabeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7cce0055-3fd3-693b-b663-c8cf5c8b4982@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
        <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
        <20210114180837.793879ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7cce0055-3fd3-693b-b663-c8cf5c8b4982@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 04:42:14 -0600 Alex Elder wrote:
> On 1/14/21 8:08 PM, Jakub Kicinski wrote:
> > Dropped the fixes tags (since its not a series of fixes) and applied.  
> 
> Thanks for applying these.
> 
> Do you only want "Fixes" tags on patches posted for the net
> branch (and not net-next)?
> 
> I think I might have debated sending these as bug fixes but
> decided they weren't serious enough to warrant that.  Anyway
> if I know it's important to *not* use that tag I can avoid
> including it.

The point of the tag is to facilitate backporting. If something is
important enough to back port is should also be important enough 
to go to net, no?
