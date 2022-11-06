Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C61061E20D
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 13:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiKFMVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 07:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKFMVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 07:21:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785E4DF37;
        Sun,  6 Nov 2022 04:21:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 158B860C52;
        Sun,  6 Nov 2022 12:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2742DC433C1;
        Sun,  6 Nov 2022 12:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667737288;
        bh=E/orbxfLPMp/6P20BF2Fp01qK5Sll/FGNpdxHcAgJIY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=GDRTFOmuVw9MFaDQyaGRYlx02RJGb1aOA1xPTdpvQKE8D6QZRGlRPKrUSuLZdIpL3
         Yf9taPjAum2DvxrYVqHlEJsoOyA+jKJBkrst/aBEIqXYbVThFWAe3wa4eVxdCebhsF
         cQ7PS4BMsWs4wVbbXkiTa+BWiA8vazNNVxA8k44yBNOVM2PTiiGjeni0Tf3u11Rha8
         LI4m8cP1fQ+m1sQaGDkcMenMZJeUK0255h/1ml3tHBo+c/YfxRIRee6jFwDrrtjGz4
         Jniq7suzny6rx9C/mqEs9x164XuccZXKFk4B0nOzhXShxGJ37jy+cHV2q9kF+uUq3p
         JiPe85v0O11og==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Kang Minchul <tegongkang@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kang Minchul <tegongkang@gmail.com>
Subject: Re: [PATCH v3] selftests/bpf: Fix u32 variable compared with less
 than zero
In-Reply-To: <20221105183656.86077-1-tegongkang@gmail.com>
References: <20221105183656.86077-1-tegongkang@gmail.com>
Date:   Sun, 06 Nov 2022 13:21:25 +0100
Message-ID: <87zgd42rzu.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kang Minchul <tegongkang@gmail.com> writes:

> Variable ret is compared with less than zero even though it was set as u3=
2.
> So u32 to int conversion is needed.
>
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
