Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94014BAF96
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 03:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiBRCUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 21:20:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiBRCUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 21:20:34 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C7ADFDF;
        Thu, 17 Feb 2022 18:20:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so11085482pja.3;
        Thu, 17 Feb 2022 18:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BHlQovhPaEzi97IY+ABf4T2RqabnT6QetVG5WEfgQH8=;
        b=N0E6IoJxWravhlHwNTnrup2degfqSPqoBpLFBR4QPQN3RQ8k7yu1pUUByC/Yf5OAjE
         nD39mQy8JKcOXEVWhgevRWNwJVdE9+E+jxxLxb6e8CW1RHWr7KQecFqE6jtdnhleop1c
         1yOiTvQt2MnQVqcxAPWYzyFLhNUW8kG1N4k5Nr+ZK8VQNEPc4d05sYGa0g7gt5AFJiUp
         tL9AE90gyWMHeUNRLN4MxOLKWYgEp/V5Ad8zO1xNs8CJRrEfk3F7joUKYi2b5DGUfbEh
         irzGfGJcjLAeX+Z9NrTAUSkPTgaOp/CHml4/+a7FsA5ZuCZApPTwdJR2ZRH7I9dGdxkD
         GJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHlQovhPaEzi97IY+ABf4T2RqabnT6QetVG5WEfgQH8=;
        b=REvPtAjqApoQbd+bAF9am5TGbVcp7862OZIqg1VwZrX1bbtzET1E/gDopMrJHBzlpt
         VJxboLdKwnd9dkhRhvsvvmn9DVP0TBPGAIv59HHy0R681XRvNU1/N0jThhkegHgMdRDS
         BNteCxl3rTttgUttfxwlN3QvChhC8ZGJT2DEYTffZSAnzO8Pzyy4JeUQvMgUvlAANHHs
         J4jRwEYDahxc78kJfU9mQMYCP3316NylZbmLrXtjYvXcPccBTKrrAsaUhZmPwM7tiJW0
         C7G2deUjsTP0g2qO5jyJgEkJIa45toaF8Yq7wYTMQajHFPsYIWdduf2qdwM3Uo5QY8Kn
         5VqA==
X-Gm-Message-State: AOAM53135mpn+kTUN1AUQ1wXNDeaiJbW0T+QOY07S3KMzn5xJySVHEmm
        dw5t0dvyAqKqXI3y20AonWSovbWgAy88rNyNOxbGfiNoOqY=
X-Google-Smtp-Source: ABdhPJyoStnCRZtIZxnCUY/psIdLZPChThCqfpGL7mS206zfGonE+8f27NF/AY9Dt/veoRBdIMFyGXmZqp6QzXcPomg=
X-Received: by 2002:a17:90a:b017:b0:1b9:485b:3005 with SMTP id
 x23-20020a17090ab01700b001b9485b3005mr10316361pjq.33.1645150818325; Thu, 17
 Feb 2022 18:20:18 -0800 (PST)
MIME-Version: 1.0
References: <20220217232027.29831-1-daniel@iogearbox.net> <164514875640.23246.1698080683417187339.git-patchwork-notify@kernel.org>
 <20220217174650.5bcea25a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217174650.5bcea25a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Feb 2022 18:20:07 -0800
Message-ID: <CAADnVQLK-Y+eTBrqTjKoSE2FHf2U0yDWJ1PXG1=_MAb9WnkFYg@mail.gmail.com>
Subject: confused pw-bot. Re: pull-request: bpf-next 2022-02-17
To:     Jakub Kicinski <kuba@kernel.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Thu, Feb 17, 2022 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 18 Feb 2022 01:45:56 +0000 patchwork-bot+netdevbpf@kernel.org
> wrote:
> > Hello:
> >
> > This pull request was applied to bpf/bpf.git (master)
>
> :/ gave me a scare. No, it's not pushed, yet, still building.

Wow. pw-bot gots things completely wrong :)

It replied to Daniel's bpf-next PR with:
"
This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

Here is the summary with links:
  - pull-request: bpf-next 2022-02-17
    https://git.kernel.org/bpf/bpf/c/7a2fb9128515
"
that link points to my bpf PR that Jakub landed 8 hours earlier
into net tree.

I ffwded bpf tree half an hour ago.
I guess that's what confused the bot.

Konstanin, please take a look.
