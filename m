Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9145740DD47
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhIPOyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238898AbhIPOyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675E960F25;
        Thu, 16 Sep 2021 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631803960;
        bh=Wjlhfs8U2Dxgnjewq4iT0dcliXi7nI/xFNo6FsSTDC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qllwg8kiPjebOW0Gjt9OrqqzRStGzSAaXhLPlMN+Hc1ngVw7AOHowbVIU4V+IfrHr
         oD2nJeryl+M51xFZzTZlA3FcvaX69XS8D7dyV8DxiSd4tp/1/8UvElwUw0wpDeA+Xn
         aSkCiE6FSQr33It4RvtKVQeMIdn40e3/Wt5nUxZ7Eou/m+yKY89O+rvJXyJfj6yFHA
         KFWlB4SM4pLTKYN35UFFZV9BxK+kX9PuwLevTnrQpb1jr0WvCTnm51Xpqv0OjbLS2n
         pCA3WqU3QSNW/EjcTSxcTP8Dy4ZXCubwtjB7n4prqE1GX6sKQ2md34T2oNZHjo8h4m
         fS5HUxwpQVnJg==
Date:   Thu, 16 Sep 2021 07:52:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless
 write to ANA_PFC_PFC_CFG
Message-ID: <20210916075239.4ac27011@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916114917.aielkefz5gg7flto@skbuf>
References: <20210916010938.517698-1-colin.foster@in-advantage.com>
        <20210916114917.aielkefz5gg7flto@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 11:49:18 +0000 Vladimir Oltean wrote:
> git format-patch -2 --cover-letter 

Nice instructions, let me toss this version from pw.

FWIW the patchwork checks don't complain about 2-patch series without 
a cover letter [1]. Having cover letters is a good rule of thumb but 
I thought I'd mention that 'cause unlikely anyone would realize otherwise.

[1] https://github.com/kuba-moo/nipa/blob/master/tests/series/cover_letter/test.py
