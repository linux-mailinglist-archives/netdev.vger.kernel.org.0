Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66D699B5E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBPRgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBPRgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:36:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A47A5FC;
        Thu, 16 Feb 2023 09:36:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C867DB8269E;
        Thu, 16 Feb 2023 17:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003C7C4339C;
        Thu, 16 Feb 2023 17:36:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FbSYtnfd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1676568963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nupc2Boja2s159BTvtDdO8txkGAiP415J/fsW21RyxU=;
        b=FbSYtnfd1equ6R3hPhQVpZgaPGS+Jo0zPo6tcvNRrM1i6r1iah6KHGdBw7FirPriFnJUG5
        rsA7r8jhY+kWLa0AjwsM0zF7oQqpK58ObSeovyy3GVlnwyG5IcKDJDPBvQdbqUixF2yTfz
        kyB/3fe6/x0rP9Rap+t2UKShRc/L+RA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8693d9b8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 16 Feb 2023 17:36:03 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5339759be1cso21286407b3.3;
        Thu, 16 Feb 2023 09:36:03 -0800 (PST)
X-Gm-Message-State: AO0yUKX5Nl/Aix5obivKNlpkMyRkzzs7NgRjos+Cb9An2h/aXyOLmf4x
        p3iur36XwkhmFmWFIWZrHYugPzwaEQap+KCUAyg=
X-Google-Smtp-Source: AK7set+1vP4FdPPp3fMdTEs+rNjKskk4N0/rkQasYQmIbx7TzNsmrkfsDQ/q0lhyuqJnW4iNpmOiO3BeI1jG4xtQst0=
X-Received: by 2002:a81:6789:0:b0:533:18a7:3e49 with SMTP id
 b131-20020a816789000000b0053318a73e49mr544218ywc.173.1676568962422; Thu, 16
 Feb 2023 09:36:02 -0800 (PST)
MIME-Version: 1.0
References: <83474b0e-9e44-642f-10c9-2e0ff94b06ca@gmail.com>
In-Reply-To: <83474b0e-9e44-642f-10c9-2e0ff94b06ca@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 16 Feb 2023 18:35:51 +0100
X-Gmail-Original-Message-ID: <CAHmME9rMyYn4_HhUXVxOpbumPXu7eHNQA-r8nR=neKSAFxa-JA@mail.gmail.com>
Message-ID: <CAHmME9rMyYn4_HhUXVxOpbumPXu7eHNQA-r8nR=neKSAFxa-JA@mail.gmail.com>
Subject: Re: [Patch] [testing][wireguard] Remove unneeded version.h include
 pointed out by 'make versioncheck'
To:     Jesper Juhl <jesperjuhl76@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
        Shuah Khan <shuah@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No idea if this is something intended for me to apply or if it's an
automated email. Fix the formatting, resend, and then maybe I'll apply
it?
