Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29CC29CC9A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 00:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832959AbgJ0XKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 19:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1832951AbgJ0XKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:10:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C122068E;
        Tue, 27 Oct 2020 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603840207;
        bh=H4OfTR8t2WMJ7J9pBCjsRqC5H+R7MHAnkpmKWl1w4AY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g281NtDRkokh8cagHyNSlpScy4bn6kIp+8FxHnKE0JxMZC/kU0jEN8R8gz+3LFHny
         XEieA9pI6Fltnaa27uIpL5HaI/e96Gd3lDx7NLXljBzP48x6TKnWU1M7Fsi4otrt74
         SX+7ze6AAOfE8BgC/2s96TvvotXnzFW21H/xv5RE=
Date:   Tue, 27 Oct 2020 16:10:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: microchip: Remove unneeded variable ret
Message-ID: <20201027161006.197edf7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201023092107.28065-1-vulab@iscas.ac.cn>
References: <20201023092107.28065-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 09:21:07 +0000 Xu Wang wrote:
> Remove unneeded variable ret used to store return value.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied.
