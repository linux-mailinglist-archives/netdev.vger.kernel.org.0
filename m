Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941A263C43B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiK2Pzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiK2Pzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:55:52 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB5762E9F9;
        Tue, 29 Nov 2022 07:55:49 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2ATFtYEL030062;
        Tue, 29 Nov 2022 16:55:34 +0100
Date:   Tue, 29 Nov 2022 16:55:34 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     JunASAKA <JunASAKA@zzy040330.moe>
Cc:     rtl8821cerfe2@gmail.com, Jes.Sorensen@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: reply to Bitterblue Smith  (was [PATCH] drivers: rewrite and
 remove a superfluous parameter.)
Message-ID: <20221129155534.GC29574@1wt.eu>
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
 <20221129152212.382062-1-JunASAKA@zzy040330.moe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129152212.382062-1-JunASAKA@zzy040330.moe>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Nov 29, 2022 at 11:22:12PM +0800, JunASAKA wrote:
> 	I think you're right and I am comparing those sorces. But the realtek official driver 
> is far different from the one in rtl8xxxu module. I think it's difficult for me to do it, but
> I am trying my best.

Would you please preserve the original subject from the thread
of messages you are responding to instead of replacing it with a
useless "reply to Bitterblue Smith" which nobody knows what it's
about and which doesn't bring anything to the discussion since it's
written in your message who you're responding to ? It's the third
such message you send to the list, at first I tagged them as spam
until I saw some responses. Most readers will likely do the same,
and even by doing this the best you're doing is to train anti-spam
systems to learn these as valid messages (which they do not look
like).

Thanks in advance,
Willy
