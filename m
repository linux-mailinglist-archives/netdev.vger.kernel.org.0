Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA186488EC8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiAJCzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiAJCzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:55:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1B8C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 18:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF13B811D8
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 02:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D3AC36AEB;
        Mon, 10 Jan 2022 02:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641783304;
        bh=LyOjDhMzwH3uXFbCfzYctyjZB4CtkaIaKVBW5hYxje0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=INyjhkoBZ7Xb6HzMkkpdJyr7yTHFqm63fj7i3WHrkU7gQODZCrsiqraVuP9jO4hgU
         xXN7cPFKLqzpiaUBfHCcCESBboW58prmcYcg91iT8HfQH9A9LQyXWJTYBTVEbCBDId
         FG6TCfGFPLSgYGMorecoU0KRPSRGJcEB32yd9G0Mdsmbt9LMOm0Pc3FmPz1rUe8gD8
         aRYgvT1eJspGgdfBxxdfhaEFmeAsHcnVEhQVx6ATh6fV6eP91Zy2KJRt+4Tsve5zD2
         U2NON1etS4MUq2zD9iiT/J9eGTlN2R4DZN3Ckn6y1slUs/3RzIj3Pj1DxWa/AlLg8r
         2x+g1l+gPIUIQ==
Date:   Sun, 9 Jan 2022 18:55:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 0/8] new Fungible Ethernet driver
Message-ID: <20220109185502.3b83d31f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110015636.245666-1-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 17:56:28 -0800 Dimitris Michailidis wrote:
> v6:
> - When changing queue depth or numbers allocate the new queues
>   before shutting down the existing ones (Jakub)

Thanks!

We've already posted our changes for 5.17 but we can continue the review
of this driver and get it ready for after the merge window. I'll review
this version tomorrow.
