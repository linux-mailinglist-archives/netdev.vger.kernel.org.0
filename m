Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FA229D6F6
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgJ1WTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731714AbgJ1WRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B0AA21D24;
        Wed, 28 Oct 2020 00:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603845460;
        bh=0zcCDwiBKC7ofVzm4/NFPmdSFJYkgfHmXUEJF+KMr7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=feaYeggrK047irjSAhmMDIkRvp9bJhCRnzJbg0nYzL98Z57xVzKCSyQ8HxPkcpP4e
         /n6a/YHe3l8aCn5o/WsyB4nxWSF6CVkI34y5dO6I8aIuUZVDogJNvhOMlcQOjBEgSJ
         yB+VxFJ1b898d/VkvB8coVRY8lmPeWc80SiP+gPY=
Date:   Tue, 27 Oct 2020 17:37:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yi Li <yili@winhong.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: core: Use skb_is_gso() in skb_checksum_help()
Message-ID: <20201027173739.7144cb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201027055904.2683444-1-yili@winhong.com>
References: <20201026092403.5e0634f3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201027055904.2683444-1-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 13:59:04 +0800 Yi Li wrote:
> No functional changes, just minor refactoring.
> 
> Signed-off-by: Yi Li <yili@winhong.com>

Applied, thanks!
