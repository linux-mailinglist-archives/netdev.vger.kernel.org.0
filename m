Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0716A513C
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 03:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjB1Cd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 21:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjB1Cdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 21:33:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA140212A;
        Mon, 27 Feb 2023 18:33:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 850EDB80DA9;
        Tue, 28 Feb 2023 02:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13BBC433EF;
        Tue, 28 Feb 2023 02:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677551631;
        bh=p9MnJLALjiAb0WzYLv062jQYB+MMJnehQOB2xpAqptI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P1sw0c3w83X8wXJxQkSDbdnCQbLE9mLfwVr5Z1PTjjFIq10eQsq6HOT22pGWf65xV
         w1G6IZMzyJgQWQYXdtrWjePl22hgBCiVEqHU/cwRQcufTUweZ5tWrwMWCJbDe8YC5Z
         cCsZ83kIpkz01NLrM3uTEguHsFGUyicSxGbaNPkQS6gGLdpWdofPKdbLhOzyekJJZt
         6AcE3V2WzTfr7reFZF3j1zxUnPiuXcx84J7sEnSvrxZtiMwYMmlvMgSU8CAmpNu1G2
         c5hE7gtHIe9qAKXReoh5EXSuaMGtIzWp4h98nIMN/f0NWeJI95e9abtRI0WhAS0gIG
         fC5/CuuaTrriA==
Date:   Mon, 27 Feb 2023 18:33:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, ralf@linux-mips.org, edumazet@google.com,
        pabeni@redhat.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH net-next] net: rose: Remove NULL check before dev_{put,
 hold}
Message-ID: <20230227183349.68409721@kernel.org>
In-Reply-To: <20230228005217.105058-1-yang.lee@linux.alibaba.com>
References: <20230228005217.105058-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 08:52:17 +0800 Yang Li wrote:
> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold},
> remove it to silence the warning=EF=BC=9A
>=20
> ./net/rose/rose_route.c:619:2-10: WARNING: NULL check before dev_{put, ho=
ld} functions is not needed.

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
