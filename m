Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD8A56C347
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiGHW3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbiGHW3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:29:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BB213B448;
        Fri,  8 Jul 2022 15:29:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dn9so34609126ejc.7;
        Fri, 08 Jul 2022 15:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Wt1t+gGbbDZ9PHq/lAlWLmts02V8uVl3YQUMJTQPTw=;
        b=Ff/t2k+V3YD7+eZxVQHpBBBvVb92DnA6vEVVaEQ98rhdkrE9UuP/24tFeks3vlerLj
         bZclV4xkP66nqZPvec0tiMa+qP08FIlvuLlvwFD4iL3BkLVH2bN3RKf8M8OLyPrT7/n0
         TwodjpKKeCivvvFTgZQOws9ZfE0fyeP7qkd+wJ5r2Fynh3VhdsYGg9vKOeeSAntsxJYu
         ON2kUFgOaO2IMt9NNnxCnstr5oVzp/6lY7a4fYBnRzR+DK2PUY0Vd3unAHrvwYU1nHxy
         pzILOl81zrbqOfRn/+/sf/EKCxUmuNMt4STX0dYKEnGuodQaOUybfasE0hq0Cc6cucoP
         7cKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Wt1t+gGbbDZ9PHq/lAlWLmts02V8uVl3YQUMJTQPTw=;
        b=ZVZDzHGb0q5lmE6KewHSAagHYRKB7UCEbICa8jNZ7b+MDna3E/gDOtvfNjTX94SfDs
         +/5G2V14aHtoHQanquQmwOenQ0WSPFCEqgxCL5eaLiGkF5dnfKofdCGuJGkJ43riOmVi
         lnBOTagfxTAFr+A2Iy+WRukvkE7fQyTn9VEB2mr0s5TMZf3DrQS0nxjUWQOy6xTF0L7h
         rcKugZTPw5itZkj6goN/xoZj02a7jlMAbUlEnKmbGD7jAb6dV8pxvSCYshMLLivd6sDr
         3Sx8bmqlbgXlFLpKoVjG7YKI8LShYC78TrUQizGjLXjDjW/gB6plgmrbjV5OPvgxYWsf
         IVXA==
X-Gm-Message-State: AJIora9N71SI49/lW5lQ8O4AjcZSwsIJuYPYRNwuTL54xzP1fD92Wy7v
        hy2nMwBKZGMaaEJdebzOQISalRoYrPKTTlyPR18=
X-Google-Smtp-Source: AGRyM1tGmOwYacc977nCBMDQs0faZ/lMDSsiUOkwt61kpjiUxDXrzb9CBsWtQkROdOXgQJuXBg2es+mW0W307QqADeU=
X-Received: by 2002:a17:907:75f3:b0:72b:1cde:2a00 with SMTP id
 jz19-20020a17090775f300b0072b1cde2a00mr5790980ejc.147.1657319342393; Fri, 08
 Jul 2022 15:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com> <20220707222519.movgavbpbptncuu6@skbuf>
In-Reply-To: <20220707222519.movgavbpbptncuu6@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 9 Jul 2022 00:28:51 +0200
Message-ID: <CAFBinCAcRDQQ51DUKr7K4Vtf3z61JTiNiB9saeKVsHs8qRJpXQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] selftests: forwarding: Install two missing tests
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, Jul 8, 2022 at 12:25 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> Hi Martin,
>
> On Thu, Jul 07, 2022 at 03:55:30PM +0200, Martin Blumenstingl wrote:
> > For some distributions (e.g. OpenWrt) we don't want to rely on rsync
> > to copy the tests to the target as some extra dependencies need to be
> > installed. The Makefile in tools/testing/selftests/net/forwarding
> > already installs most of the tests.
> >
> > This series adds the two missing tests to the list of installed tests.
> > That way a downstream distribution can build a package using this
> > Makefile (and add dependencies there as needed).
>
> Just for future reference, the netdev process is to mark patch sets such
> as this one with "PATCH net" since they fix a packaging problem with an
> rc kernel. There's more information about this in
> Documentation/process/maintainer-netdev.rst.
noted

> Do we need to create a Makefile for the selftests symlinked by DSA in
> tools/testing/selftests/drivers/net/dsa/, for the symlinks to be
> installed, or how do you see this?
Yes, we should have a Makefile there as well (IMO). I'll send a patch for this.

> The reason why I created the symlinks was to make use of the custom
> forwarding.config provided there, and also to reduce the clutter a bit
> and only focus on the selftests I felt were relevant for DSA for now.
Makes sense, I'll make sure that this one is installed by the Makefile as well


Best regards,
Martin
