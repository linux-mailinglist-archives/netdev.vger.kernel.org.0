Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A3487BB9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiAGSEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:04:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55302 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240374AbiAGSEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 13:04:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE3361F68
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 18:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1EEC36AE0;
        Fri,  7 Jan 2022 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641578639;
        bh=qjja5Xsmo3f2j7pLiwF0rbZ3KJ0KMnNV4nJifdgKb04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pP+hiSKj+ME0j58iq8zUeeY+AoVfob1su3xjpv+6904nXQvT7AMi9SehmO3ynqvjt
         nZXHdUheIleh3RyPBpHVB0FMTy8IXGZYia/ZIhe5djDKz/HuP2FpLduNZFDnz9kw20
         b2utwpYfLowvlBYR0HJ0kNB0FpQAT3oQMhp/tw7GfARK6gkht3Y8gx8MXn6hTY1jkO
         L+tGKQALfGRlPSN3X7drcrxReo0ilhSmUeHk65RmkBe8b4Xq8+r141rd4xxRtRB8S9
         kNjnqcDAXR7QTVRIZDFqLdCsIwnW+ilDwJk33ziIcuiLV/nN+IccZvA1/DrOcL1jBk
         Cs+KMtMa1ehhw==
Date:   Fri, 7 Jan 2022 10:03:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] ptp: don't include ptp_clock_kernel.h in spi.h
Message-ID: <20220107100357.19749708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Ydh842WVE/QeNwtg@sirena.org.uk>
References: <20220107155645.806985-1-kuba@kernel.org>
        <Ydhj3QP2VxXIWfZq@sirena.org.uk>
        <20220107085127.6cfaed55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Ydh842WVE/QeNwtg@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 17:48:19 +0000 Mark Brown wrote:
> > Will this patch make 5.17?  
> 
> If there's no problem with testing it should do.

Thanks!

> I'm not sure what the rush is though?  It's just a cleanup and this
> is the Friday before the merge window.

Not rush, but PTP pulls in a lot of networking headers, would be great
if we didn't have to rebuild spi code over and over in the next cycle.
