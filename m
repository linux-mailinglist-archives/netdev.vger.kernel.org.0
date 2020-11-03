Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25EF2A3A11
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgKCBx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgKCBx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:53:29 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4636221D40;
        Tue,  3 Nov 2020 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604368409;
        bh=HI70QVqc0qzULRHPZIp0qmywEpCumwNM6jH8p1E51Bc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mi9OpNle2AlPBEPtH6pLJEQdGrcdY27MtUpn3kQbBRiYSRnMeRJ+78VaG1XzZbwOE
         C4816HoBjvxiX8Yk+KzudnnSRT5XQAPzI9IvUm3di0nD8rHy0rCA9wh4D/dkIpOQsw
         9du8I1VafO977AWl66MeTPh7SevZD4y8K1oO5zCY=
Date:   Mon, 2 Nov 2020 17:53:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: remove unneeded semicolon
Message-ID: <20201102175327.797a79b7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031153047.2147341-1-trix@redhat.com>
References: <20201031153047.2147341-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 08:30:47 -0700 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied.
