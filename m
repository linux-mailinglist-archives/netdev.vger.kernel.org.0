Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D6465BDB
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 02:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350879AbhLBB56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 20:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349793AbhLBB54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 20:57:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC857C061763;
        Wed,  1 Dec 2021 17:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 460FACE1FD1;
        Thu,  2 Dec 2021 01:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22357C00446;
        Thu,  2 Dec 2021 01:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638410067;
        bh=YLkA1iytx0pxU4Vxr1Ocrq6jxlv07BZX8Hl/kYb6J2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V+dHpF2jeImd2TPGj7rwptGtXFwkgvKsIA1yY51qbHTbmyxOwwgIiCNNA4gXnnGcN
         k6QN1uxIctaQ/YS9eT6k8Z1JCuMuUnP8pESf1Yy47v2Rd3/wB64PyxlKNqyYAzD0VO
         AC227o09m+5Q3GEe7kQGvuqypErIj/XRaSiWUolcEpm9DvfNKQ8AnYQ9HDhIZjE+tn
         W/eBA5RSNorncThkrsiGvBsubxVMF8Ptv69xITO1IgfEm/7mPxlQtOVrGQt6j9W/IV
         PwaHMWSWT29SmqOjwYEm3hzt4Jg93AUubea+FqzHOo2Hz7HI/qI+/5rvNtFY2zpURj
         l/YvpAaPmdNmw==
Date:   Wed, 1 Dec 2021 17:54:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     <davem@davemloft.net>, <shuah@kernel.org>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] selftest: net: Correct case name
Message-ID: <20211201175426.2e86322f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 19:10:23 +0800 Li Zhijian wrote:
> ipv6_addr_bind/ipv4_addr_bind are function name.
> 
> Fixes: 34d0302ab86 ("selftests: Add ipv6 address bind tests to fcnal-test")
> Fixes: 75b2b2b3db4 ("selftests: Add ipv4 address bind tests to fcnal-test")
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

Please send this patch separately from patches 2 and 3. This one is 
a fix (AFAIU) and needs to be applied to a different tree. Patches 2 
and 3 look like improvements / cleanups.
