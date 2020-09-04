Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C02525E3E1
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgIDWr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgIDWrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 18:47:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003242083B;
        Fri,  4 Sep 2020 22:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599259644;
        bh=u6J3DgjT+O5HOvU/ydCD5ZEhsKGITO9uxKB9GZ+dMUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JZ85c/9zdMMDrYyVxsJbPij+TIBZkCTl48wBC8p26VBWRWhv2EDhfpm5QjqG0Q6UC
         kFDrUACOQkfQ0R3PEdQsdV/Rcw3zenHl1ztKm1W6vh5ryNdgazhaZ0Uf8IZLfLUg86
         cSv+qYgiWEpEpg3f8T+eukazUgZOxOBC47GkvChM=
Date:   Fri, 4 Sep 2020 15:47:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 0/2] ionic: add devlink dev flash support
Message-ID: <20200904154722.280d44e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f6c0abae-a5ca-2bbb-35da-5b5480c1ebe7@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
        <20200904080130.53a66f32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f6c0abae-a5ca-2bbb-35da-5b5480c1ebe7@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 11:20:11 -0700 Shannon Nelson wrote:
> It's probably related to this discussion:
> https://lore.kernel.org/linux-sparse/ecdd10cb-0022-8f8a-ec36-9d51b3ae85ee@pensando.io/
> 
> I thought we'd worked out our struct alignment issues, but I'll see if I 
> can carve out some time to take another look at that.

Cool, could perhaps be something with union handling in sprase I see
that there were some changes in sparse.git recently regarding unions -
maybe it's fixed already.
