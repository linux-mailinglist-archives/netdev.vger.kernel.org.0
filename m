Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A205C311F34
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhBFRtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhBFRtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:49:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AA2B64DAE;
        Sat,  6 Feb 2021 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612633706;
        bh=vt0lYTZQeLxfEwtnZuuCfvpP0A+4PAc5EFfUtygp9Bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jPkKCGLm6YwPtnCKrRQoUT7mJScyCz3lNCEVjDQ/j3aU9agDV9XypCveltZBD0AR/
         uxL2XleYI9aUrI9wqpqYiQ0mJEqCeNMTIrC/1hTgFsvEc9n4UBZaOQHpKRBPGLbdGk
         FGg2LkYLj1FHmIBvwqvMdOkAj0Oj7AW+GnEbx0b2OdCgJZHaDOIqpP+8ndxO1tB3tV
         CBvBqkWyC9l/HOfdeUSTaPjW8ocEUvPupyWtDZbJVa3LfLpD/OE4InUbIwRs6D9fut
         K6ZgiLkRlHbaVCwXmtB0YxoQTlM04+dTryMcFQLHw0Bc+Fu7OMPFzuITPOh7nyLRHy
         soV991guaICQg==
Date:   Sat, 6 Feb 2021 09:48:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>,
        maciej.fijalkowski@intel.com, madalin.bucur@oss.nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] dpaa_eth: A050385 erratum workaround fixes
 under XDP
Message-ID: <20210206094825.277fcac5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1612456902.git.camelia.groza@nxp.com>
References: <cover.1612456902.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Feb 2021 18:49:25 +0200 Camelia Groza wrote:
> This series addresses issue with the current workaround for the A050385
> erratum in XDP scenarios.
> 
> The first patch makes sure the xdp_frame structure stored at the start of
> new buffers isn't overwritten.
> 
> The second patch decreases the required data alignment value, thus
> preventing unnecessary realignments.
> 
> The third patch moves the data in place to align it, instead of allocating
> a new buffer for each frame that breaks the alignment rules, thus bringing
> an up to 40% performance increase. With this change, the impact of the
> erratum workaround is reduced in many cases to a single digit decrease, and
> to lower double digits in single flow scenarios.

Looks like reply bot got moody.

Applied, thanks everyone!
