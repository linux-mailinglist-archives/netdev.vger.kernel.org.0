Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC549BAF7
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241414AbiAYSHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiAYSGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:06:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B38C061753
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 10:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1228B61518
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 18:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F2CC340E0;
        Tue, 25 Jan 2022 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643134010;
        bh=pGmHSreaw+K+mCVIrpn0Tq464ZP2iaRHxtgPr7CmaCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kgWCVf80MRBGtlHCNTbhah2VxDLzmFbKx5OSztJJg9Op06hLDpAWNAeWvvJLpRsF/
         LF9IzeyY66yllnrV+Ai2FNO40TrGvDFvCCARpM4MON3OeMSny6/mpRiAPeNHiZUTgy
         zoEZoAH3gWGvo/My/Ry5VJPix4w6Krtos3kcxL5RKezFlGSIi1yTyoy4pb7ZH8hoXG
         DMDMsU114v2by6v9q2F/pqMtCCYzv25XRSb+dZUbNqiCjRCSnsKjdP+9nTDnUQ3Pmj
         nW4QRKcwXilioGQ+6eKjleLLqXqYQX8j2tKptI6bvp5Q7pjxl8bxiwaHLwKOZQE8Lk
         dhUO/uVUqIVug==
Date:   Tue, 25 Jan 2022 10:06:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] ipv4: get rid of fib_info_hash_{alloc|free}
Message-ID: <20220125100649.5ba2344b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124173115.3061285-1-eric.dumazet@gmail.com>
References: <20220124173115.3061285-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 09:31:15 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use kvzalloc()/kvfree() instead of hand coded functions.

Applied, thanks, ca73b68aca4a ("ipv4: get rid of
fib_info_hash_{alloc|free}") in net-next.
