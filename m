Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E06E374BE7
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 01:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhEEXaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 19:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhEEXaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 19:30:02 -0400
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0471C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 16:29:04 -0700 (PDT)
Received: from [209.85.214.169] (helo=mail-pl1-f169.google.com)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.84_2)
        (envelope-from <rsanger@wand.net.nz>)
        id 1leQwu-0000BP-PG
        for netdev@vger.kernel.org; Thu, 06 May 2021 11:29:01 +1200
Received: by mail-pl1-f169.google.com with SMTP id a11so2254984plh.3
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 16:28:58 -0700 (PDT)
X-Gm-Message-State: AOAM532iS7yZUDRMwgEwGc13qbegfjJjGdHSf1CFmMsCa35V2TlMWvMa
        TOxYYjihrh/L2LQBblINio9mxnlT2J2TV8Dtmw8=
X-Google-Smtp-Source: ABdhPJz5BOyWKcXjtCtK7E0iVGG3QJT2muwVlVk68RqqEMxt2+q3D0neBkU2NtBYTV6oh/Z7/ws1Y4RHecixfbpzUcY=
X-Received: by 2002:a17:902:8ec1:b029:e9:998d:91f3 with SMTP id
 x1-20020a1709028ec1b02900e9998d91f3mr29409081plo.59.1620191389429; Tue, 04
 May 2021 22:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
 <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
 <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
 <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com> <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
In-Reply-To: <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
From:   Richard Sanger <rsanger@wand.net.nz>
Date:   Wed, 5 May 2021 17:09:38 +1200
X-Gmail-Original-Message-ID: <CAN6QFNy0QhkgAjRmEhzvPBr=505poc83S7dux2cuRyY26P06cA@mail.gmail.com>
Message-ID: <CAN6QFNy0QhkgAjRmEhzvPBr=505poc83S7dux2cuRyY26P06cA@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Received-SPF: softfail client-ip=209.85.214.169; envelope-from=rsanger@wand.net.nz; helo=mail-pl1-f169.google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However, when skb_tx_timestamp() is called within the packetmmap code path
> skb->tstamp holds a valid time.

Sorry, I've confused a function name here, meant to say:
However, when ***tpacket_get_timestamp()*** is called within the packetmmap
code path skb->tstamp holds a valid time.
