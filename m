Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A83437A8B
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhJVQFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhJVQFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:05:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0953D60F46;
        Fri, 22 Oct 2021 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634918596;
        bh=6zX2Hn1/g0oyiV2docTO/Wjj9BBrROj9YimITRXXi/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O+tSwsMniCnO7OTNkih+fjAJLbg1YesPWEMyPZDKZj+AyFCW7t3d6bD0wDvdLJBCJ
         8ae1wHhHHkUpq+nsItF6VAsrmYL1VLyIdb4Zw20lywOLQeRmlIQ7JsRl8mRZm1KuwV
         QCdIYFlnfoQkwAqPtmWbOA+NyXRvcZ/dYqnmTZt//KGGnMpvXsKQ9tAlR7JMqoVqPt
         3ye5HLxoF3Vm2cC/0HkLuHyWGyH6jOopj3Fnz17bhjCifalaJNvDNPklB+BAA6noTk
         MkwXN4XXPvSvRPyy3G+kyokN3dYuQcLXhlhXC/RPpdFT6qpcPNHKMEjMNswkdoteMR
         y1jmRXfMKczPg==
Date:   Fri, 22 Oct 2021 09:03:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v4 05/14] net: phy: add qca8081 ethernet phy driver
Message-ID: <20211022090315.67e8bf8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211022120624.18069-6-luoj@codeaurora.org>
References: <20211022120624.18069-1-luoj@codeaurora.org>
        <20211022120624.18069-6-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 20:06:15 +0800 Luo Jie wrote:
> qca8081 is a single port ethernet phy chip that supports
> 10/100/1000/2500 Mbps mode.
> 
> Add the basic phy driver features, and reuse the at803x
> phy driver functions.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Does not apply cleanly to net-next/master. Please rebase and repost.
