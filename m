Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09FC3E5032
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 02:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhHJADu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 20:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhHJADu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 20:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF00C60FDA;
        Tue, 10 Aug 2021 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628553809;
        bh=a6rovIfbzdSFQISXrhsG9la9OKvP+OeufxDLopFx9ps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mftm4HszSg8GNnEpR4/M4zsZemIBmO2/jrPUj4uLq0L/KpmkaNNBW7fnNZA6gRjdY
         cssVKb3g4YsVxxiDpgT1CtUiWvTjH+btkRwhSvlMoAVvmMRgcwxyddaPnFg7ZN5Efa
         VLPP1Wo2w9kRqV6ZV3oSVcxZfYvJNFJNPN+QWkwN8UQblSSPNrbjc9UNz2QPxtzHeP
         x2yTSqMv0SP3sjxMZytXH5Gqlghp2J8PLO26sikswylm9MQ7flxkWFDltax6R0snmJ
         5tFyuGnjKkrOTA6oYCm0pTLzDxrUvJeZKd+DkvEO9dA0vpKRSLZxoxUIXjagY87aA0
         u2uPjXrhB34XA==
Date:   Mon, 9 Aug 2021 17:03:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ben Hutchings <ben.hutchings@mind.be>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        marex@denx.de, Tristram.Ha@microchip.com
Subject: Re: [PATCH net 0/7] ksz8795 VLAN fixes
Message-ID: <20210809170328.37f39c5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809225753.GA17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 00:57:54 +0200 Ben Hutchings wrote:
> This series fixes a number of bugs in the ksz8795 driver that affect
> VLAN filtering, tag insertion, and tag removal.
> 
> I've tested these on the KSZ8795CLXD evaluation board, and checked the
> register usage against the datasheets for the other supported chips.

Let's remember to CC authors of patches under Fixes, adding them now.
