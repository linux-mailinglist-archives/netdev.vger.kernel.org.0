Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1DF2861DF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgJGPMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgJGPMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:12:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0EE920797;
        Wed,  7 Oct 2020 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602083543;
        bh=F8eVxUt5lLcTLeJO5wEXTXEkhSN4v6PrI7JZGKenC0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1GEwBplnwqrcNHu5Sar+cwyUYHEnrS7htKz8iewmRZDb0IH/GaETf1fSbnFxPFHa+
         rX7QUEJraoBx7JVMTTj+dIZjmXBAbbmiJbJYurOF2GfTya8n9/z5E9HjgumWgHk86a
         CjKXGwQtYG0AyQCjhLzaaJ0VW96j+MHbpACHlBSQ=
Date:   Wed, 7 Oct 2020 08:12:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY
 attr
Message-ID: <20201007081221.6370d585@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
References: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 12:53:50 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The ETHTOOL_A_STRSET_COUNTS_ONLY flag attribute was previously
> not allowed to be used, but now due to the policy size reduction
> we would access the tb[] array out of bounds since we tried to
> check for the attribute despite it not being accepted.
> 
> Fix both issues by adding it correctly to the appropriate policy.
> 
> Fixes: ff419afa4310 ("ethtool: trim policy tables")
> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
