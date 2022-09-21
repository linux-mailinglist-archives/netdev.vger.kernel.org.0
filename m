Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51B15BFC25
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 12:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiIUKSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 06:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIUKSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 06:18:14 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CFC8B2D9;
        Wed, 21 Sep 2022 03:18:11 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1663755488; bh=ze+fPfeNNLOQeMVkhH1Vs5tjhjQPKinp0bPriX2bsaQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fJUzCIud/LgKnYwmZXfZuEW6ehiqAuQQMjAucdbpNVOTHikaNK39jz1uTQdRlsdLB
         p0cT6bkwdCyPWZQ4ppTCkDnDf7lUtJxLID+qv7Ks9QEEVOYXvBtcqGteQltKPlkbtE
         r/RHUTiaAWi9xYZy3+Jp8zs7u0iTQzAz02Ldq+aPNAQvZ1FngOvR4LQ9SDr4f/wQph
         YghkB5Upo/TtGnULBlNTdTvbQGIcUr4Y90Ply8izR4+ZUBetntItBPd5Od36LsPzk5
         UGBQ0cXd+NYt/61k9hMYiTAxfmSWvz3U2bhPZCsCwactR8p6pf74YAZp8hbiEzlUsq
         LXfZBqZITkZQg==
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: Re: [PATCH] ath9k: fix repeated words in comments
In-Reply-To: <20220915030859.45384-1-yuanjilin@cdjrlc.com>
References: <20220915030859.45384-1-yuanjilin@cdjrlc.com>
Date:   Wed, 21 Sep 2022 12:18:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87czbpvxnj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> writes:

> Delete the redundant word 'the'.
>
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Let's merge these, so we don't keep getting identical patches for the
same two typos:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
