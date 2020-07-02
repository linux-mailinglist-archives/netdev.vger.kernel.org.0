Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4985F2129DC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgGBQjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGBQjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:39:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A02120720;
        Thu,  2 Jul 2020 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593707975;
        bh=HWN/yqk5Ex0xJFUSdo2sZyCd+/YimAHDEXMuBIcwq7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oQ+/obvsGGbuQoGX31BWvtSE55THsK+cPBABgpjT1c3zYGgTq9CPxtR4gVkeRWWcG
         Xx2qJL8lBCdkRCBhKBvx1F4Eo5AlmZP6aRCJT3cetHsDz0FlTK5ba3lesbU7+cNw/j
         xHLe93t03YpsO0zuQb3nNneTtcuUY6nJ+SBh1TiE=
Date:   Thu, 2 Jul 2020 09:39:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <aelior@marvell.com>, <irusskikh@marvell.com>,
        <mkalderon@marvell.com>
Subject: Re: [PATCH net 1/1] qed: Populate nvm-file attributes while reading
 nvm config partition.
Message-ID: <20200702093933.042c930b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593701075-14566-1-git-send-email-skalluru@marvell.com>
References: <1593701075-14566-1-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 20:14:35 +0530 Sudarsana Reddy Kalluru wrote:
> NVM config file address will be modified when the MBI image is upgraded.
> Driver would return stale config values if user reads the nvm-config
> (via ethtool -d) in this state. The fix is to re-populate nvm attribute
> info while reading the nvm config values/partition.
> 
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Could you provide a Fixes tag?
