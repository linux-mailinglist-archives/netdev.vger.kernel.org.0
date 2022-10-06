Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43D35F684C
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiJFNiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiJFNiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:38:02 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B190AA3DC;
        Thu,  6 Oct 2022 06:38:00 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665063476; bh=2eDKvBs8Tw879aV1uJFtRmxtF1Gbbg6ry/7D6Hr123E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rYIUMVxb2i8cqxZl4l9pK8NY2ftwwTU7qQ4/AhPXb0MCbhBcU9BVjvTMzr19RR188
         c7Ufi7ZurX0aOTGjB+iKukHeL3bfXJKrfrCT+HtotvvmoKiT1aasxFq92jz+7MBlEJ
         hfl2193EFSgrocBjPS12kxbMNgn5r0wOnuQ2AUQZSfx+8z1uPz7lek1o310uZS0epN
         xewSVeQFY0ydq+AreRuBDmhF53lrb+7DkcZPNB7ekDL/7eqHI1krXRalXrNjVsB5YY
         XlyOQ07E8w2jegnM42G892HOBZCbRFZI4DfJqpFabTq7Vlj76cWMF2MX5ToSuyx/GS
         MwCHbqc8mgFIA==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/5] treewide: use get_random_{u8,u16}() when possible
In-Reply-To: <20221005214844.2699-3-Jason@zx2c4.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
 <20221005214844.2699-3-Jason@zx2c4.com>
Date:   Thu, 06 Oct 2022 15:37:55 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wn9ddqdo.fsf@toke.dk>
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

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Rather than truncate a 32-bit value to a 16-bit value or an 8-bit value,
> simply use the get_random_{u8,u16}() functions, which are faster than
> wasting the additional bytes from a 32-bit value.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  crypto/testmgr.c                                          | 8 ++++----
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c             | 2 +-
>  drivers/media/test-drivers/vivid/vivid-radio-rx.c         | 4 ++--
>  .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c   | 2 +-
>  drivers/net/hamradio/baycom_epp.c                         | 2 +-
>  drivers/net/hamradio/hdlcdrv.c                            | 2 +-
>  drivers/net/hamradio/yam.c                                | 2 +-
>  drivers/net/wireguard/selftest/allowedips.c               | 4 ++--
>  drivers/scsi/lpfc/lpfc_hbadisc.c                          | 6 +++---
>  lib/test_vmalloc.c                                        | 2 +-
>  net/dccp/ipv4.c                                           | 4 ++--
>  net/ipv4/datagram.c                                       | 2 +-
>  net/ipv4/ip_output.c                                      | 2 +-
>  net/ipv4/tcp_ipv4.c                                       | 4 ++--
>  net/mac80211/scan.c                                       | 2 +-
>  net/netfilter/nf_nat_core.c                               | 4 ++--
>  net/sched/sch_cake.c                                      | 6 +++---
>  net/sched/sch_sfb.c                                       | 2 +-
>  net/sctp/socket.c                                         | 2 +-
>  19 files changed, 31 insertions(+), 31 deletions(-)

For sch_cake:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
