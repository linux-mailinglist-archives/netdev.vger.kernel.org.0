Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09353FA6FB
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhH1RW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:22:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhH1RW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 13:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h5lKgS/NcVoyPDzovo8eWrWUMUPw6tKFiyp5C9nPI/s=; b=tjjqGNTTMM7NFgBxI8Cexm4Xdt
        W8q1S0HrEVm/OpheldRpgESNNeMD6sHIGbVW6L4Qcl3kBhHBiDyRigZ84Xahk/po3JvfUOOS14Tok
        ByuHxdQnAq4SwHXEr3Vrc8TtGMV9yqw4gX0mBXtdxxAIMUbZ2U79sxPfVr/RHXmU0L7w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mK21N-004J4k-7t; Sat, 28 Aug 2021 19:21:33 +0200
Date:   Sat, 28 Aug 2021 19:21:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shjy180909@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com
Subject: Re: [PATCH net-next] net: bridge: use mld2r_ngrec instead of
 icmpv6_dataun
Message-ID: <YSpwnTf/fzUwcKxV@lunn.ch>
References: <20210828084307.70316-1-shjy180909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828084307.70316-1-shjy180909@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 28, 2021 at 08:43:07AM +0000, shjy180909@gmail.com wrote:
> From: MichelleJin <shjy180909@gmail.com>
> 
> using icmp6h->mld2r_ngrec instead of icmp6h->icmp6_dataun.un_data16[1].

Please could you expand the commit message to explain why?  I can see
what the patch does by reading it, but i have no idea why?

     Andrew
