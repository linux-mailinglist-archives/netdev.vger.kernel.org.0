Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EEF615815
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 03:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiKBCo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 22:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 22:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4161BEAF;
        Tue,  1 Nov 2022 19:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D214F617A9;
        Wed,  2 Nov 2022 02:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F702C4347C;
        Wed,  2 Nov 2022 02:44:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QABkUn6/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667357091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UBDll3aYfc54ok2vGI+aLXjCxJBzqPNfmky2K1csXd8=;
        b=QABkUn6/Oy6XT6TEVj0zIC+t0OIaIi74m1DlLjhBC2UUC0vf6H2NixR2DkmiZJFVpxxB0L
        it7OVWJtXOS5RpjPqRhvapbKSIjYp27zXwKIO9++vCWDVWdw+cB63qydiMMkhDgmRIbXhp
        Cd+/vmigoMADd0ec/gewUBqXPVU+gc4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2def14c2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 2 Nov 2022 02:44:50 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id f68so8296788vkc.8;
        Tue, 01 Nov 2022 19:44:50 -0700 (PDT)
X-Gm-Message-State: ACrzQf0zrW+nRYlzNBxRQTKtZVOvNSLWwybUNrAQ2gKD18blH/2WGsPc
        5hUG8VBoCOYe6p5/CUuB/wmI8v5N85y+SzWWmbU=
X-Google-Smtp-Source: AMsMyM5cezv5iqW1JPV8jCiRJLT4Lvoir0toUoTZ05yCdVMedc+j+TrGJp9Ae/LrfSxffD6LPAGtAhZZex7Oy/jHgtU=
X-Received: by 2002:a05:6122:318:b0:3b8:394d:e5ab with SMTP id
 c24-20020a056122031800b003b8394de5abmr7431793vko.37.1667357089200; Tue, 01
 Nov 2022 19:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221026123216.1575440-1-Jason@zx2c4.com>
In-Reply-To: <20221026123216.1575440-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Nov 2022 03:44:38 +0100
X-Gmail-Original-Message-ID: <CAHmME9phbAJEbogBVZqmmb+44_V--rG_L5hAZCWeJVJy6-W7ag@mail.gmail.com>
Message-ID: <CAHmME9phbAJEbogBVZqmmb+44_V--rG_L5hAZCWeJVJy6-W7ag@mail.gmail.com>
Subject: Re: [PATCH] ipvs: use explicitly signed chars
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

On Wed, Oct 26, 2022 at 2:34 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The `char` type with no explicit sign is sometimes signed and sometimes
> unsigned. This code will break on platforms such as arm, where char is
> unsigned. So mark it here as explicitly signed, so that the
> todrop_counter decrement and subsequent comparison is correct.
>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Wondering if you planned on taking this into nf.git for 6.1?

Thanks,
Jason
