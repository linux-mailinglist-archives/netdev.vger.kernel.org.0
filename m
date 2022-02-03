Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2684A8B14
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345876AbiBCSA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353087AbiBCSAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:00:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B3BC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:00:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08EC0617A7
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 18:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE09C340E8;
        Thu,  3 Feb 2022 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643911232;
        bh=+sLKDr0J8jZsEwDccq1l800Q1/qmusu2nKPaXrRfjBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zMXK0Tvo5vqa8P8CLD59dvx6n1LkxkDg0TPPdbA9ewNd6RgbiMDf+IvohEpu1xGVg
         Cw+tCrstPzJvTWAJzJ9QWjuJh0L2pRjGYFwyowGvsFS+5OGcB9U/mK5D+jeMStosqQ
         +4uo7xe9syqFFtH/1SFH7elhHFGB2VRYdLu4IlQs=
Date:   Thu, 3 Feb 2022 19:00:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jason Xing <kerneljasonxing@gmail.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH v4.19] tcp: fix possible socket leaks in internal pacing
 mode
Message-ID: <YfwYPZeIWjzGulWM@kroah.com>
References: <20220131182603.3804056-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131182603.3804056-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 10:26:03AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This patch is addressing an issue in stable linux-4.19 only.

Now queued up, thanks!

greg k-h
