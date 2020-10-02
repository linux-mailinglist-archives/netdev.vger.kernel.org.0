Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB732816D6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbgJBPjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387974AbgJBPjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:39:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F64520795;
        Fri,  2 Oct 2020 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601653193;
        bh=vaZBkeWLMXU07nclgdAmRRBh+eG246QJDsBoZOQcRds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eA3CJRLVIADXFmHYnYJLncFMDX6XKYRRp+d8FI6f/UWbPJS506m8M1H8rnVsVr7im
         UbsTJmdGRa3yxkPcnOGwpZEDUcFOb7TDuioxgzV396ib6DMkEFTwEkgWja5smku2Ia
         7gIL+KUr0TlPaftXiXzfRDuM1ZHAlkk/8Y84KqPg=
Date:   Fri, 2 Oct 2020 08:39:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/5] netlink: compare policy more accurately
Message-ID: <20201002083952.6532f201@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002110205.73a89b98cf10.I78718edf29745b8e5f5ea2d289e59c8884fdd8c7@changeid>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
        <20201002110205.73a89b98cf10.I78718edf29745b8e5f5ea2d289e59c8884fdd8c7@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 11:09:41 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The maxtype is really an integral part of the policy, and while we
> haven't gotten into a situation yet where this happens, it seems
> that some developer might eventually have two places pointing to
> identical policies, with different maxattr to exclude some attrs
> in one of the places.
> 
> Even if not, it's really the right thing to compare both since the
> two data items fundamentally belong together.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
