Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C493B23AC
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFWWtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 18:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFWWtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 18:49:16 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB3AC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:46:58 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id c22so3433451qtn.1
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=baLWTJJOD9KKn4tbADk0l8SSVLIOO1E6adwsQz9cQtk=;
        b=2P0QI+RvSARusDodtiS4LFDZvpm98ftfqZzlAvFmDeDEsWTR/41vPw2g5Li9BurLDS
         KwtT+bk42gIoYWMCp6i2fLUoA7jI5XzJ0AGqnE/GtiO6/pXG+cxm0cCSXaa2xqH5sJkW
         AzeSidNkqXfR4TdG0IL0yPw3nX/RyN7EjBZxCifIUKVJTFQeE+3tPkq9BBau39uHPrqp
         tNQ93P1uB0t6SJjoMcFYIZxxTtZlmEJzXl2NUlZDA5nO0XiAwULd5DuKO2SXdOqWYk1v
         rADERDLB7AWdggMHeLv6rediDUNjHjVoNQ13YpBJLtVJrYHiRIinfWB+4U0Zk2YhB4WO
         cGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=baLWTJJOD9KKn4tbADk0l8SSVLIOO1E6adwsQz9cQtk=;
        b=uHl+uZ96qJvmZ+A2s/Hxt/w5ym0bqNwwAe2K47LsDey4eTmnHNYBUfhJRKxibUsR09
         MQXhTtxKaAIIhdd8Ipv2OXogM+SIkOlGDKyHVHu+Re2nSwr0gt2HuJvkvItp2lBHHLZG
         6/8YJdyYRvFAwRNtTyCe+duqUjUR7YZedNS9RGdD3nA4f8PE988cXRqdD0e6QbC7iazW
         fcgTFNFTxM4CNOHXyAkTSptIj1LcCP+z64PNDn7TQsNaIrfqvhtFjEuKV4YbJkGS36MC
         J6NfkJ7PbiJNGWKE+o6dNqqF3igl9uPxQ08+ZoqkPM9n0fxhaCzHafoj60y9tMpnhaqT
         NSAQ==
X-Gm-Message-State: AOAM531BPxJHLc2Gsjbz09azgJVTzYsPIyjm1bvmKPg2jvKJ2bnlSSrm
        vPH9jrrdh5qoHvmrctdZ1s+KXJp4GDA0TQulg6OM2Q==
X-Google-Smtp-Source: ABdhPJyDaVuIlMDJXtFMt64IfujIqi5BMZ+bhCdX3D/i+ZNuIXsAQQjFbyaLX2q5i1c7no1NEFTYdQt0F/BZmf/DLJc=
X-Received: by 2002:ac8:57d2:: with SMTP id w18mr2192305qta.306.1624488417307;
 Wed, 23 Jun 2021 15:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210624082911.5d013e8c@canb.auug.org.au>
In-Reply-To: <20210624082911.5d013e8c@canb.auug.org.au>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 24 Jun 2021 00:46:48 +0200
Message-ID: <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

czw., 24 cze 2021 o 00:29 Stephen Rothwell <sfr@canb.auug.org.au> napisa=C5=
=82(a):
>
> Hi all,
>
> Today's linux-next build (x86_64 modules_install) failed like this:
>
> depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: Assertion=
 `is < stack_size' failed.
>
> Caused by commit
>
> 62a6ef6a996f ("net: mdiobus: Introduce fwnode_mdbiobus_register()")
>
> (I bisected to there and tested the commit before.)
>
> The actual build is an x86_64 allmodconfig, followed by a
> modules_install.  This happens in my cross build environment as well as
> a native build.
>
> $ gcc --version
> gcc (Debian 10.2.1-6) 10.2.1 20210110
> $ ld --version
> GNU ld (GNU Binutils for Debian) 2.35.2
> $ /sbin/depmod --version
> kmod version 28
> -ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL
>
> I have no idea why that commit should caused this failure.

Thank you for letting us know. Not sure if related, but I just found
out that this code won't compile for the !CONFIG_FWNODE_MDIO. Below
one-liner fixes it:

--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct mii_bus =
*bus,
         * This way, we don't have to keep compat bits around in drivers.
         */

-       return mdiobus_register(mdio);
+       return mdiobus_register(bus);
 }
 #endif

I'm curious if this is the case. Tomorrow I'll resubmit with above, so
I'd appreciate recheck.

Thanks,
Marcin
