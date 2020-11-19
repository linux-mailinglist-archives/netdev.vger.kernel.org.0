Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7522B89A8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgKSBhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbgKSBhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:37:17 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42353246BC;
        Thu, 19 Nov 2020 01:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605749837;
        bh=hy/0Wyoy2DVKfSDqiEuD9aHC7csSc49sOnRumWXkj3g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NRgV84XANhupC2+3ALv+5ELR1hKQDiXKlA9IlYNm/3Z0sxm2SvMhFtVztJnyl5eWa
         LDICNxKHYlJqf6KmgPL2h6k19ydVKbWxCa7gNbNnOKNJ+ZXXsZwM0rUAVjU4Fl7QYF
         Ry+f+Yyu4p5pxZoN9kRtaijDqnvktZf4NnpMFl1E=
Date:   Wed, 18 Nov 2020 17:37:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Message-ID: <20201118173715.60b5a8f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118153310.112404-1-parri.andrea@gmail.com>
References: <20201118153310.112404-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:33:10 +0100 Andrea Parri (Microsoft) wrote:
> Lack of validation could lead to out-of-bound reads and information
> leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
> allocated sub-channels fits into the expected range.
> 
> Suggested-by: Saruhan Karademir <skarade@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org

Acked-by: Jakub Kicinski <kuba@kernel.org>
