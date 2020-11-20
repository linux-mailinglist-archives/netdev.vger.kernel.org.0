Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135D72BB9AF
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgKTXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgKTXGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:06:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1645E2240B;
        Fri, 20 Nov 2020 23:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605913579;
        bh=2G5Jq0IoHwKVB9Apv6O62YHWokfmrqxHPWSl0Jelu/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IShmGnsJJiJRnPNy74jsap9GPoMxgHocCCJ7R8jBXe7/Ma+NAEtBuxiCn/XU29n/5
         13WyuCPS8YjHwTXqRl1W+YAlYPMwYj6qGvlXuEb2Eab0OkMYEalIpEFeEcmA4km3wz
         axCHDrDs9vQguhFYf1YCXUTWFIhGVXwWAWwQ2YAc=
Date:   Fri, 20 Nov 2020 15:06:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <george.cherian@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <saeed@kernel.org>
Subject: Re: [PATCHv3 net-next 0/3] Add devlink and devlink health reporters
 to
Message-ID: <20201120150618.4d1a5b55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120062801.2821502-1-george.cherian@marvell.com>
References: <20201120062801.2821502-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 11:57:58 +0530 George Cherian wrote:
> Add basic devlink and devlink health reporters.
> Devlink health reporters are added for NPA and NIX blocks.
> These reporters report the error count in respective blocks.
> 
> Address Jakub's comment to add devlink support for error reporting.
> https://www.spinics.net/lists/netdev/msg670712.html

This series does not apply to net-next, please rebase and repost.
