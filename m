Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E40F392392
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhE0AIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234961AbhE0AIa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:08:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB4EA613BE;
        Thu, 27 May 2021 00:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622073991;
        bh=8NhwXlSg8UPnsQu77o9LoXYEgrvPG79K+CwgTqUQ7C0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fWMno5OAx2Kn5nTNTJ9ud27nOEn5EGkqCi45QLgl1WRRLVaylyFA/ui1jf48TUHRX
         ZxzT/N/DSvxIpBoj5Cn+sfiR2GftgSyrWyHwbtiLz58nWcqU0baMW1QHIKvGiCz+sK
         Unse8p7MrW7iA/jCB62pfdIRrwu0siXaVuhIX935IwxczeNYRj4FPK49LJ32PQDS5h
         EwG9v7PJSvrsvcOKQz9mWL5Ili4QLpdQz3Yr6Nqx/c5pd7/IBJOnB3NJjcHCZwWM1z
         sfqFAq80WghpyblVX29acG4K1PpuVlSojJMRYDfoG9aOEbKgRuuVP/OWi0t2i1e4xb
         YF5+7Wf5Y2qQA==
Date:   Wed, 26 May 2021 17:06:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <george.cherian@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 1/5] octeontx2-af: add support for custom KPU
 entries
Message-ID: <20210526170630.1732c4b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526155656.2689892-2-george.cherian@marvell.com>
References: <20210526155656.2689892-1-george.cherian@marvell.com>
        <20210526155656.2689892-2-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 21:26:52 +0530 George Cherian wrote:
> From: Stanislaw Kardach <skardach@marvell.com>
> 
> Add ability to load a set of custom KPU entries. This
> allows for flexible support for custom protocol parsing.
> 
> AF driver will attempt to load the profile and verify if it can fit
> hardware capabilities. If not, it will revert to the built-in profile.
> 
> Next it will replace the first KPU_MAX_CST_LT (2) entries in each KPU
> in default profile with entries read from the profile image.
> The built-in profile should always contain KPU_MAX_CSR_LT first no-match
> entries and AF driver will disable those in the KPU unless custom
> profile is loaded.
> 
> Profile file contains also a list of default protocol overrides to
> allow for custom protocols to be used there.
> 
> Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
> Signed-off-by: George Cherian <george.cherian@marvell.com>

This one does not build.
