Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0B5767B8
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGOTrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiGOTrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408C776E8A;
        Fri, 15 Jul 2022 12:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911FB611CF;
        Fri, 15 Jul 2022 19:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEA0C34115;
        Fri, 15 Jul 2022 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657914439;
        bh=8LDukI9Pe+Ff4iU7nCkFaoKzBtNpTweyq4UzGkAghH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rdpd7mYmGTbxuSsMJmUIjO2ExfJqFMj+sibOnrJZgqHzG0uOD0all8Noh9ZoxC8U2
         Ha6cStKw2zSAjgDDNgZnXUgoE8fMgvK6JaZcVZhe1vcr6I5rUuhmJ7PWsmQ9+YsqyJ
         79o27cBjhzgNb1Rpshx1c6DjprB1pujSMvzFs+HHyPnxaqEkNxsCyFm663IygM6qK1
         ZcuOyXN6dcNqZwN8+OUi6Tg00HTwYKK7gimfSj/UdebU9nsIS7hBuYdt4ikwX5Uh8f
         M6YcQ55NiiHjJJI87HqxHGQMWZJAqQBTrWOH578h3iTKDUe1XzpUQxkqsfRe89fduW
         Ovem0KCPMXcBQ==
Date:   Fri, 15 Jul 2022 12:47:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
Message-ID: <20220715124717.5472ceb3@kernel.org>
In-Reply-To: <62d1c288.1c69fb81.45988.55fe@mx.google.com>
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
        <20220714220354.795c8992@kernel.org>
        <62d12418.1c69fb81.90737.3a8e@mx.google.com>
        <20220715123743.419537e7@kernel.org>
        <62d1c288.1c69fb81.45988.55fe@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 21:16:46 +0200 Christian Marangi wrote:
> > > Or should I just propose the move and the code split in one series?  
> > 
> > Yup that's what I prefer.
> 
> Ok no problem, if the current merged commit is a problem, np for me with
> a revert! (it was really to prevent sending a bigger series, sorry for
> the mess)

Oh, I didn't realize Dave already merged it. No worries, it's not a big
deal. Would be great to prioritize getting the split done next. If both
are merged for before 5.19 final is cut - it doesn't really matter if
they were one series or two.
