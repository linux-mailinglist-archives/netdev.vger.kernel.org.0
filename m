Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760BD59AD63
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 13:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbiHTLAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 07:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345679AbiHTLAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 07:00:54 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFAF57216;
        Sat, 20 Aug 2022 04:00:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x23so6074792pll.7;
        Sat, 20 Aug 2022 04:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8wuUIWdis+xT0hudag4a14ELVYJVIG+o6tLrSegrIoA=;
        b=j61CLE6fa59pokGfGnMEauJKsM2LM5X8woqRtjVW9NTQ6Y5kpAiWTx96vf7d8dGckw
         fVo50+VzyS011jwN0OAUbTQRCkqSNls3M0X4N9RiXxlf4W4YutQxMT3ZcBdP5cIHGJUc
         8x1JZqcFS7bb/HVnfV/WinwjjsqIJVCjcPRwJE7Wz+R/lOhhOdv0ojp9M4dyFuh5BZzQ
         C2zBeoXohSc3s/zmDdjcg75DRwMWeLCvUfp/PTXXfxTZ2cCOAXOa0NlhiYeiLyEOHPe4
         PDpUKpNCpaRDzu5xzQ5N/WUf6d32QF9drhjvaJLcpwQL0nW2X8iHYD4CgdVCdOMbj47W
         8Y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8wuUIWdis+xT0hudag4a14ELVYJVIG+o6tLrSegrIoA=;
        b=wVZVmRT1fwLmhlI4vVW/qdZEftjXNVS+j5XxuPO/0bopENMckTNv+qxEM9h7F9ixms
         fbD4Zoxvvp/n/qC/Sxl0Mhher5JtO9dsl8kCbLpJAG6esU6TE1Bc+v2152FR0Dk2aUmb
         1xEvGyzOlDHPQpFp0dyjccO1EOzPSnIUNq3Tj7Q65/dzLKK7isKX4SyEGo9PoAyLp6kk
         xzId1rx8A9IB/XXiD4ZsbKgMbIeoO/GCm9aTS4zlzboxOS8UGU8DOttu5mi5E7bcr4is
         FWh3yKeskCg4pNaVndhDwgyHa0r/+9P5lMn7o3HIK5jqdNCnoQaNzATLqqAOi9tsdTft
         Fq7Q==
X-Gm-Message-State: ACgBeo2kzpvwOyu4I9Lfbsj/bg6rv4xddV3vHKNLSvsAw0c/RcFvZuPi
        QXEWBylJdg1KbUX3xvHIETIgvbG6+9yd5l3h144=
X-Google-Smtp-Source: AA6agR69UjJy0KLH6Ee1SUGZ54BK+5j1ORpgxDR23VFhE+9QTX6186pijxlgLD6bPlh46L9BskLrEeHeRs7o0KEUU3I=
X-Received: by 2002:a17:902:da8f:b0:16f:6b6:eed7 with SMTP id
 j15-20020a170902da8f00b0016f06b6eed7mr11456056plx.85.1660993253488; Sat, 20
 Aug 2022 04:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com>
 <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
 <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com>
 <20220818165838.GM25951@gate.crashing.org> <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com>
 <20220819152157.GO25951@gate.crashing.org>
In-Reply-To: <20220819152157.GO25951@gate.crashing.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sat, 20 Aug 2022 19:00:41 +0800
Message-ID: <CADxym3Y-=6pRP=CunxRomfwXf58k0LyLm510WGtzsBnzjqdD4g@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
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

Hello,
On Fri, Aug 19, 2022 at 11:24 PM Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> Hi!
>
> On Fri, Aug 19, 2022 at 10:55:42PM +0800, Menglong Dong wrote:
> > Thanks for your explanation about the usage of 'noinline' and 'no_icf'!
> > I think 'noclone' seems enough in this case? As the function
> > 'kfree_skb_reason' we talk about is a global function, I think that the
> > compiler has no reason to make it inline, or be merged with another
> > function.
>
> Whether something is inlined is decided per instance (except for
> always_inline and noinline functions).  Of course the function body has
> to be available for anything to be inlined, so barring LTO this can only
> happen for function uses in the same source file.  Not very likely
> indeed, but not entirely impossible either.
>

I understand it now, the global function is indeed possible to be
made inline by the compiler, and 'noinline' seems necessary
here too.

Maybe I can add a new compiler attribute like this:

/*
 * Used by functions that use '__builtin_return_address'. These function
 * don't want to be splited or made inline, which can make
 * the '__builtin_return_address' got unexpected address.
 */
#define __fix_address noinline __noclone

> A function can be merged if there is another function that does exactly
> the same thing.  This is unlikely with functions that do some serious
> work of course, but it is likely with stub-like functions.
>

I understand how 'icf'(Identical Code Folding) works now. In the case
we talk about, It seems fine even if the function is merged. The only
effect of 'icf' is the change of function name, which doesn't affect
the result of '__builtin_return_address(0)'.

Thanks!
Menglong Dong

> gl;hf,
>
>
> Segher
