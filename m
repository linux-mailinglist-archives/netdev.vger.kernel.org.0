Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F95813CF
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 15:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbiGZNGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiGZNGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:06:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D2122B17;
        Tue, 26 Jul 2022 06:06:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC99561578;
        Tue, 26 Jul 2022 13:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2161C341CE;
        Tue, 26 Jul 2022 13:06:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eaDqqnQM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658840781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6VDSyYBTm8e/A4njVgolgd/tpxY8z107rsOjb6Yozu8=;
        b=eaDqqnQM0f32PSvYMe/rNVFIjn2r6MRAugemHy3wHfIf+c8oXtPX6blgWPxDfPsWBNhbSz
        LeacXVfzThXQVynB439FepY/nS3x19i4PmMXHyDO+rsz39LVgWMXIAbFsNj3d79b1pXb95
        8QI7KRsPN6cTVrGAFGMZTP8BfRFIwyA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id af4794a3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 13:06:21 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-2ef5380669cso141589497b3.9;
        Tue, 26 Jul 2022 06:06:20 -0700 (PDT)
X-Gm-Message-State: AJIora/Tc5NoZFV+krPP+IbTwe8aivh7Za0v9CZynnxzX+pXnknzAmld
        PsJtoCMVTD4MVA0sV6brv9LJ/7wO+T6PmFNAj3w=
X-Google-Smtp-Source: AGRyM1uEw8B5KufJv5EFdrQLtTqR1WusMhc5HzHbfQxBHMUpbPem1siotpHU/Qv/o6DV+E947ypxXXoLQpK5KFB+Y3I=
X-Received: by 2002:a0d:d597:0:b0:31f:5858:9050 with SMTP id
 x145-20020a0dd597000000b0031f58589050mr244502ywd.341.1658840780279; Tue, 26
 Jul 2022 06:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220726130058.21833-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220726130058.21833-1-lukas.bulwahn@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 26 Jul 2022 15:06:09 +0200
X-Gmail-Original-Message-ID: <CAHmME9ogBc_uX_TutV7ZC=nmhhZEtKLA3ezyx4VFwotietNytQ@mail.gmail.com>
Message-ID: <CAHmME9ogBc_uX_TutV7ZC=nmhhZEtKLA3ezyx4VFwotietNytQ@mail.gmail.com>
Subject: Re: [PATCH] wireguard: selftests: update config fragments
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
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

Hi Lukas,

Thanks for researching this! I'll apply this to my wireguard tree and
send it up to netdev during my next push.

https://git.zx2c4.com/wireguard-linux/commit/?id=6da997932c4d4cb41c4a35d5541d0e4e1154fdb7

Jason
