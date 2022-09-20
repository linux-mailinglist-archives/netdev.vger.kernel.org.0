Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670465BF17F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiITXrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiITXre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD08027DFE;
        Tue, 20 Sep 2022 16:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4915862E9B;
        Tue, 20 Sep 2022 23:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681D4C433D6;
        Tue, 20 Sep 2022 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663717652;
        bh=7B66HfNp0wPQB5A6vT6O62g8aAJgYt8bYjvlRjBMk6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fFVoFbmDNNBul1CLGQBrbPtOnM7wYvkmqqOOvBbrhNcsVxj2LSCyedDx3gSmp/Ndm
         eSOSbNQR/78vhHtx7I85JpOgQPEJ8Bcg/UP/Ws6VnFSXtALmjlpQbvpg6lUO4Yx0n8
         oRIYLRgGaGHyWmdSXvG5EHi9ZAU5jEaIDa+2ao3Kp2aQOF6MVbjmbPKcTSd9OAvY8i
         B5A4gp0WoIZ3tvoWV48Kh1rYFKn6yP0bHiHmT0FsgASARnbnhZLpoNErKC1HJ5tUWt
         LpdgYpMQtkAcF49B9ghax175ZWeKtOUYXFN92SRLfcAmKtjA/Wf97lwOPiCPIzd92L
         doSXsDFf5jsmg==
Date:   Tue, 20 Sep 2022 16:47:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li zeming <zeming@nfschina.com>
Cc:     aelior@marvell.com, manishc@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux: qed: Remove unnecessary =?UTF-8?B?4oCYTlVMTA==?=
 =?UTF-8?B?4oCZ?= values values from Pointer
Message-ID: <20220920164731.49856668@kernel.org>
In-Reply-To: <20220919020614.3615-1-zeming@nfschina.com>
References: <20220919020614.3615-1-zeming@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Sep 2022 10:06:14 +0800 Li zeming wrote:
> The pointer p_ret is first assigned and finally used as the return value
> of the function.

This patch doesn't make anything substantially better.
