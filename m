Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005247F16A
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 00:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhLXXEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 18:04:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59238 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhLXXEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 18:04:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2534B80FAE
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 23:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B352C36AE8;
        Fri, 24 Dec 2021 23:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640387069;
        bh=Cctr2zUHKKM3Mb/kCeLwb5tRVn2nH1jqg+/qwO3N0g0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PJfWKl8dgB/xhqvzN1r890IuvHFt1WyJfzXfA8LJg8bT6Pu1v0NG31nqzTxHAyls5
         Lat+atHThuh8chCmfzuGNKcSCjIboEbB3vJ5dGaRdNfc3RMB6o1OVdPAVD2CmaZzZt
         CtAPSdvV66ceGHUUh/wUY1dmWEXgTmn3V9fW6ubOQkdIuu6yjbMwim52DPUxQiNYzW
         sEtDD3nZphDUsXBz0LJWdGnmfYLipqBz1qjBWQlQBFsTtmmJGteuY8whh9lkyIwWOE
         O3R7lv7sTTCgaJ0JzdQUVLUOQ5gN+ZQj1RP9J8Kmob34Lyuv85dl9f53+RQpTaSX38
         EmsDhqpdoU46g==
Date:   Fri, 24 Dec 2021 15:04:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, colin.king@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: smc911x: Fix wrong check for irq
Message-ID: <20211224150425.3c21994f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224051254.1565040-1-jiasheng@iscas.ac.cn>
References: <20211224051254.1565040-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 13:12:54 +0800 Jiasheng Jiang wrote:
> Because ndev->irq is unsigned

It's not..
