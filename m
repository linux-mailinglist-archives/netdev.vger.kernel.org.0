Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B43D6E9EAA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbjDTWR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjDTWRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:17:55 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5A02689;
        Thu, 20 Apr 2023 15:17:54 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682029072; bh=E54QoxkAa+Pj7RKVni728J5N8i4GxDR5LFh2/Yh/N0Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VkcPOMxBDenERilgPM+aJWWZv54NkMI7SGAbLL6/wRdd99Zp2qNjuhDs35gGFZ1q9
         lLzZ9f2wH2eru/gNTjJspSDQJMC0EjxxNVVToDZF175vxSghkTrgq+n+8Fp7hOTG0i
         BMxeC+w5ll1LRD9818aetZmnDWQIC8a9FKUBktgdvA+kLTcrxxnZTMhrQh3VSKTzVS
         L/vqpaFHSL6EmQcqzY9lw86XWsG+P1vdS6RHrj/cqAi/Y/KvH6FgZYgoeQ8jmQkh5x
         k6LinnufXcGVXQrhjVPixXQdyh6FZijx7Fu3omUaIcgrUIT/Gp3M9iPOzYBrXFwBt5
         wofdlmCWKJ0nw==
To:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>,
        Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
In-Reply-To: <20230420204316.30475-1-ps.report@gmx.net>
References: <20230420204316.30475-1-ps.report@gmx.net>
Date:   Fri, 21 Apr 2023 00:17:52 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wn26ryen.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> writes:

> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> calculation (do not overflow the shift for the second register/queues
> above five, use the register layout described in the comments above
> ath9k_hw_verify_hang() instead).
>
> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
>
> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F017=
7FB722F4@seqtechllc.com/
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>

Thanks for writing up the patch!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
