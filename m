Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3597450CAC4
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbiDWNpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiDWNpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:45:39 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28CA151F5B;
        Sat, 23 Apr 2022 06:42:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KlssS6MyJz4xNl;
        Sat, 23 Apr 2022 23:42:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1650721357;
        bh=3C84ccftDy9PVflkyViujWf+bf2fZBGJWRvoGbxG78Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=E8Qf0rsbg2AmYN3VZ5Qbq04Kd93P+e7QcYX938BlW0MGhPm7LSsGT709miZJvRR4K
         VGur63wHMpRA6g2+DdVY9c9eh7Z1RIDpHE+d5KVLGIw9z6EKB6cEJBHgonac988AfC
         MusaEn47ZdylpoKSs2n1v7EQwmJS3qeh1IZAsUhmQH62RHZ3KUBnQPRuANhw21p2E0
         GBvaOSV3I+fSP/rQHzIMn8OkNCyazaf8XVwl+4G1Y7Iqmit4msjPaMSaQPuu05OIuW
         DDNdQdKQhZROfPopqfJlMnwyPMEwmeFV2uXvxiZjACOMVxJ8XGuPWGDBSdMYHFXWEc
         veJEk/csNuIIw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org
Cc:     x86@kernel.org, linux-alpha@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: unexport csum_and_copy_{from,to}_user
In-Reply-To: <20220421070440.1282704-1-hch@lst.de>
References: <20220421070440.1282704-1-hch@lst.de>
Date:   Sat, 23 Apr 2022 23:42:30 +1000
Message-ID: <87o80r9ard.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:
> csum_and_copy_from_user and csum_and_copy_to_user are exported by
> a few architectures, but not actually used in modular code.  Drop
> the exports.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/alpha/lib/csum_partial_copy.c   | 1 -
>  arch/m68k/lib/checksum.c             | 2 --
>  arch/powerpc/lib/checksum_wrappers.c | 2 --
>  arch/x86/lib/csum-wrappers_64.c      | 2 --
>  4 files changed, 7 deletions(-)

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
