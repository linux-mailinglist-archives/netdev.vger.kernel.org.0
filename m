Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854223050EF
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbhA0Eas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhA0C7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 21:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AD6206CB;
        Wed, 27 Jan 2021 02:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611715796;
        bh=yffl5FcVGo56FVQZw5yhSCv1Tihjkpvctyn4u7+SuPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bpDYQpbZZviFNKMGSjIB2xb/IPqopMsmqAylHgfoDVUfOc5sgHt270aTezWu/6Kyv
         C+N9G+874vaT2TnAmuEg/UyaMPS0pVxKcfIVmrvOKDVpSKyl9r0WUpY29K3tG1FcCf
         JC/K5zEpFRu7PudWFmNW03ARPdUM1ejo5mPE5NNp1iho6gUc78ATtlaFylcsa0vrfQ
         DZXEya3gH3weeYBPXkQvkyHKf4DsE2UnsKXRLx4yS7oANUHtmBTPXhxu09A2eV80QJ
         tmH/3GYdAmNxSoBpKGigmN4lckwEkd09XgDBHO4F7ndIlS3NEHzLR3TLVhHUljPeIO
         z3dLM5uu0KZIw==
Date:   Tue, 26 Jan 2021 18:49:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, saeedm@nvidia.com
Subject: Re: [PATCH net-next] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126145929.7404-1-cmi@nvidia.com>
References: <20210126145929.7404-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 22:59:29 +0800 Chris Mi wrote:
> In order to send sampled packets to userspace, NIC driver calls
> psample api directly. But it creates a hard dependency on module
> psample. Introduce psample_ops to remove the hard dependency.
> It is initialized when psample module is loaded and set to NULL
> when the module is unloaded.
> 
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

This adds a bunch of sparse warnings.

MelVidia has some patch checking infra, right? Any reason this was not
run through it?
