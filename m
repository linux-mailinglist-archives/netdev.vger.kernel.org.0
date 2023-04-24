Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37AF6EC8CC
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 11:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbjDXJZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 05:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDXJZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 05:25:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289FD2117
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 02:25:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-24736790966so3646714a91.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 02:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682328314; x=1684920314;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=35DRhB75q3wRkebp9DrJb+2dw6nrBa1EQoLcH9Em600=;
        b=BNlwlnuVqgfas/so+5JH2OtAppwOpVA0nv/LhzX7waApxmjwkXkMMACaqFrsKr8PVt
         SLuuW2laKLiaSz4ka3ixztRuwnK5TL+k7M3agtcAHQa0t6ZaVvcX82pfQUPQZQMj7avT
         m7Inxi8adG3ZUVueGfkNz54K1k13bX1230IrX+itNmrOeHzFQAWzf9A19ESD14X3MM9w
         s0JPHVLwHSagHe+ShaZxv7LDLYKZFjlrChKbTYHr+GIJhBnthxZxDJXmOjV4zq4tQcZi
         8TqG2AI2UTNke3z3TgbKer65jqecPvmN42yER8jBrI+c3/gnF9f+YTSIjf0cvD0GNEOz
         wEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682328314; x=1684920314;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35DRhB75q3wRkebp9DrJb+2dw6nrBa1EQoLcH9Em600=;
        b=bh9G3Rj/8YtNEz3JRRFZW2NV/zay28chojvf1ExLe6d2O4j6BDQZOr+MH1rdfIEADJ
         zzaN21E2lyA2e8rrJEE3U9dfiR26oXmxzF1ZIeg4ldpDQHgqBj0Usied1J+9oggVYCNs
         mE34Z3cEdXnIRqqADhyfY7oCl6cKO84q5NXidSDdhoBYzmgyfZVS893KkroukBsHzUbL
         4Stjm3EyqLTRGSOGFmsfhGbdTW0CS9yta6S2wP5daZF2CwqCzjx4+BMLMBK1sMedCbh3
         vDi1B3fj/W+0LlAYBx0E2I7upGgUB7cidc04Je+hlvh4t+xE8WJaBd0TGLpML8oZsvyE
         c5Pg==
X-Gm-Message-State: AAQBX9d5mCidNn2w4WsmbzAIs/9tUiJwQDj7gdZ71L5Fi8MVkaMu/FxJ
        BwRQ5LchFqSlySOkqXKEn0YhOV/qVutGfu9d
X-Google-Smtp-Source: AKy350aK4nmwqgILtsdGLYKD9MJBIiMBQ5N2Spb29aoGzvTkWDGc+sDgnCrMvheVAtpWyzWLwRPqpA==
X-Received: by 2002:a17:90b:310:b0:247:6ead:d0ed with SMTP id ay16-20020a17090b031000b002476eadd0edmr12757044pjb.28.1682328313949;
        Mon, 24 Apr 2023 02:25:13 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902684c00b001a6d08eb054sm6227226pln.78.2023.04.24.02.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 02:25:13 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:25:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: [Question] Any plan to write/update the bridge doc?
Message-ID: <ZEZK9AkChoOF3Lys@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Maybe someone already has asked. The only official Linux bridge document I
got is a very ancient wiki page[1] or the ip link man page[2][3]. As there are
many bridge stp/vlan/multicast paramegers. Should we add a detailed kernel
document about each parameter? The parameter showed in ip link page seems
a little brief.

I'd like to help do this work. But apparently neither my English nor my
understanding of the code is good enough. Anyway, if you want, I can help
write a draft version first and you (bridge maintainers) keep working on this.

[1] https://wiki.linuxfoundation.org/networking/bridge
[2] https://man7.org/linux/man-pages/man8/bridge.8.html
[3] https://man7.org/linux/man-pages/man8/ip-link.8.html

Thanks
Hangbin
