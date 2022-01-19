Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF596493DDF
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355795AbiASP7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356084AbiASP7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:59:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD3EC061574;
        Wed, 19 Jan 2022 07:59:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7184DCE1D3F;
        Wed, 19 Jan 2022 15:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544CBC004E1;
        Wed, 19 Jan 2022 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642607968;
        bh=V7LGtmzqvJJFqa4HA4DOO3BH4xLnT72+9Ue/Qr2CyZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ipn7wi2gM6AxT8HMkfwiBF51Du6zCECt9n+Es4TK6ShL5vt2XPVVEvXbou1gfBMBE
         8JmgWHLHYe2KYpe9ZOcbRzEEFL61z9+t9eIFzUIl2M29hfAqU+5VpehkA1h+gJk5NQ
         L0B/jFgqvtzddIhNxuLC5yiWkARk2XWbLuMkIJY3DUNrC55yOQYVjNfkggLWqQC8jx
         0e+h3CQ1l4TdGV68J2rU+ang+msL+41lGyCyBUc/fx2selJq51r1cgswHgxqxBnKdx
         j2/qoQyKQ1bNI9nSKEpuARdtyGkndNXzzTmRH7AHU90DhgY0yEPjsNDkeARgFzXJzn
         MxKx5pbcxRdXw==
Date:   Wed, 19 Jan 2022 07:59:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     chi.minghao@zte.com.cn, davem@davemloft.net, dsahern@gmail.com,
        dsahern@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, zealci@zte.com.cn
Subject: Re: [PATCH] net/ipv6: remove redundant err variable
Message-ID: <20220119075927.0d2c4a21@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220119055557.931265-1-chi.minghao@zte.com.cn>
References: <20220118192804.1032c172@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220119055557.931265-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 05:55:57 +0000 cgel.zte@gmail.com wrote:
> There are more than 3,000 numbers retrieved by the rules I wrote.
> Of course, many of these 3,000 are false positives, and maybe 
> there are 300 patches.I wrote this rule similar to returnvar.cocci.

Can you start by improving returnvar.cocci so it catches all the cases?
Then make sure your patches build and don't introduce formatting
problems. Then post them.
