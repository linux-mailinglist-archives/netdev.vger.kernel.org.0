Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD42A3A17
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgKCByD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbgKCByD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:54:03 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4FD721D40;
        Tue,  3 Nov 2020 01:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604368442;
        bh=jTBDUd/sABFOHCwWC8ddceR41OFXoed4AKLUR43RnR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c/VPqWr1so++LBT2aQNBLfFBJC2xvJ5MUBk8EHbGHVIycwsTz0zSf3Xjm3ZT9hFkh
         Y1G8HH5DoMob2JqVu3v4PtMLQY0c+mouLtL6DJ98t2ureB3Eh1dRi9wq8QlfoDIDFL
         L0knRnde3ib4xNTg4qmorG3LibljefWk6KvFF7cs=
Date:   Mon, 2 Nov 2020 17:54:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: remove unneeded semicolon
Message-ID: <20201102175401.091b384e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101140720.2280013-1-trix@redhat.com>
References: <20201101140720.2280013-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 06:07:20 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied..
