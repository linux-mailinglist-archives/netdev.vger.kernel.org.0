Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8DA62B69C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiKPJd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiKPJdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:33:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28D425FD;
        Wed, 16 Nov 2022 01:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A414B81C21;
        Wed, 16 Nov 2022 09:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED18C433D6;
        Wed, 16 Nov 2022 09:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668591224;
        bh=LJFi6Ma1wzYiDa5KLD8RjmUBaaBhQpd9Xx8w7okLL/0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EJiPSar9fvYC8gxWIGNiU+SsZZ4gALbqU+ctlrwbqFlvFTAg49j5d5rebYCOq7eMh
         gHL2BUnvPCavqP+szIAv9HWDFrFGby4a35IKJ89s9lrBLLUOagDLTxbxbZ5LD5oe1y
         xvJ+DA+yWSohkqAM0Hv6H2gRr6RoBOmkSnb5aV5HpIkCGN5O03cA1DaazSNJZwds4m
         /2QMLb7ywnQtlXMLoLjH2jCCnzUMD5ORDn8ytoMHr1h42COptFk9Q1ap5XVY50G3Rh
         tZcW7hE3wOHMav2vqPQcIfVyXCHn3Zpwij88EGFveOGfPbe0uQM84U98TcfpFsy1/k
         5PaEB2i1656AA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: Fix some error handling path in
 rtw89_core_sta_assoc()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr>
References: <7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166859121959.16887.13694175362892729527.kvalo@kernel.org>
Date:   Wed, 16 Nov 2022 09:33:41 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> 'ret' is not updated after a function call in rtw89_core_sta_assoc().
> This prevent error handling from working.
> 
> Add the missing assignment.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

81c0b8928437 wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

