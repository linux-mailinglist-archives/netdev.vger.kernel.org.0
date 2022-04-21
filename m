Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8015550AB95
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391098AbiDUWmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347687AbiDUWmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:42:14 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D1848E65
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 15:39:23 -0700 (PDT)
Date:   Thu, 21 Apr 2022 22:39:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650580761;
        bh=Yhil5SnZy5w0YFI1CyB509cNQ0BZWHi5ErmFYmrsw9Q=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=eamBUXUYBoTqnQ+ht9RBNFqzzwjqfosV6T5SX/5ajS52XHKblPybywY+xVmD8BoWK
         SB6jrS7WDFnLJtaPZe6MTOFhaFJW0A13KCvxaWiPyizuWh+8fwO/aKq0UlhfMicqQe
         T+Dc9namZOgCb0fDotip028nghFhQlEZxDHlLa7cseD6HgK2jye+UKUSF6iymJbGFy
         x2wwl/qzfjdVcJ4LOMa5dNzcho5b3AhqWVwYrIbA8gLtGBPt0/8A3mRKyHVUfIrYG3
         50hXg/UYe224tWuLi2sN5M9Frb//sGcwM2MtmaRlVpWzPez9DwZ7vI09bt1B/iasPt
         3i9dmvbSxAoHA==
To:     Alexei Starovoitov <ast@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 bpf 00/11] bpf: random unpopular userspace fixes (32 bit et al)
Message-ID: <20220421223201.322686-1-alobakin@pm.me>
In-Reply-To: <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
References: <20220421003152.339542-1-alobakin@pm.me> <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 20 Apr 2022 17:40:34 -0700

> On Wed, Apr 20, 2022 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Again?
>
> -----BEGIN PGP MESSAGE-----
> Version: ProtonMail
>
> wcFMA165ASBBe6s8AQ/8C9y4TqXgASA5xBT7UIf2GyTQRjKWcy/6kT1dkjkF
> FldAOhehhgLYjLJzNAIkecOQfz/XNapW3GdrQDq11pq9Bzs1SJJekGXlHVIW
>
> Sorry I'm tossing the series out of patchwork.

Oh sorry, I was hoping upgrading Bridge would help >_<

Let me know if you're reading this particular message in your inbox
finely. Toke guessed it precisely regarding the per-recipient lists
-- Proton by default saves every address I've ever sent mails to to
Contacts and then tries to fetch PGP public keys for each contact.
Again, for some reason, for a couple addresses, including
ast@kernel.org, it managed to fetch something, but that something
was sorta broken. So at the end I've been having broken PGP for
the address I've never manually set or even wanted PGP.
If it's still messed, I'll contact support then. Sorry again for
this.

Thanks,
Al

