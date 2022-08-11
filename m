Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1290458F81D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 09:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbiHKHHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 03:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbiHKHHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 03:07:06 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7858F94D;
        Thu, 11 Aug 2022 00:07:05 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f22so21766038edc.7;
        Thu, 11 Aug 2022 00:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TDjWinqlF0X8bU7yycHeeQp7mYPb81LIq0/kGr0oCbc=;
        b=N4HMGc6y508GTOW8f5WEgo5tCcgy/kUfPFoMNE2IVGpuUDE4BW17B/jEIm/azAT+eA
         dMLQso7X1/6AvpUOWlsBnD6bQjmK8ndIdMRh/vEkqHVn2BNSdw4qkXBrzSXYnCj7bbTf
         hsNYiS4kqaeo+4Z7vpWR9zzG3lxuLg9EEAiEqqyh4hNH1k5gd9u3Kscqw/bslRQgKgez
         1NPBM/Lp9ZsqalQCg+t73EMsI6CQsJXWAZq/VduEJodVDyyst/ccxiKc9VgQmuj0dHJ8
         SuFwWf2TJTBPOTImi1YbjsdN2YsabaurK3AWCZvt6TmmJbdu8Zm29YNd4rqMtRxCkxA/
         RiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TDjWinqlF0X8bU7yycHeeQp7mYPb81LIq0/kGr0oCbc=;
        b=mMezKjCt84wfEJoY8KOSwnu9USkQoNR4JcZ+pV1FMkBClaf9jtIAxZ0+VUL3VUk1ti
         jyu8qksq78rDK0LkiUcFJn9HzWo0NFMARtgqeOrM+bonxFlJgyf6tnMAmIK7De19Su/L
         SOTjqdiBbdERFV26/6P9V2eh5CPV42PtEisIPHm2aUs0JSSZibXF7Z6YBktbk64Yk4SF
         aoDZ0pLYZK1I/EoUC9ZkP3idFZmig7YDMHIY1ZwhzuOXIqRiNj+WGA2jvugQilp2kHpA
         y3PDJjmSnjT07DuD/gK11pmWMn0f606K/ooxS/oRAoubACj9SeFLGa+SPBpKw8uhNjS3
         CIoA==
X-Gm-Message-State: ACgBeo0Dga2chp+VZFaAuYodNt3pZBxY6azlMZLRp2MhZkurEd6gvDGm
        lckOaQrk28qIHajl3kpXcl0Xeg7XG2H0OdIpYig=
X-Google-Smtp-Source: AA6agR504tQLMZmgqBnlH3VKpLQzvBnzTTvoGiDy9cIvo61T3Jdr6d+rggCBWlhWqqHUAc31RHf5ywfQ8AQXyazgPrw=
X-Received: by 2002:a05:6402:3697:b0:443:1c6:acc3 with SMTP id
 ej23-20020a056402369700b0044301c6acc3mr1318466edb.421.1660201624083; Thu, 11
 Aug 2022 00:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220810190624.10748-1-daniel@iogearbox.net> <20220810205357.304ade32@kernel.org>
 <20220810211857.51884269@kernel.org>
In-Reply-To: <20220810211857.51884269@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 11 Aug 2022 00:06:52 -0700
Message-ID: <CAADnVQK589CZN1Q9w8huJqkEyEed+ZMTWqcpA1Rm2CjN3a4XoQ@mail.gmail.com>
Subject: Re: pull-request: bpf 2022-08-10
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
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

On Wed, Aug 10, 2022 at 9:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 10 Aug 2022 20:53:57 -0700 Jakub Kicinski wrote:
> > On Wed, 10 Aug 2022 21:06:24 +0200 Daniel Borkmann wrote:
> > > The following pull-request contains BPF updates for your *net* tree.
> >
> > Could you follow up before we send the PR to Linus if this is legit?
> >
> > kernel/bpf/syscall.c:5089:5: warning: no previous prototype for function 'kern_sys_bpf' [-Wmissing-prototypes]
> > int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
> >     ^
> > kernel/bpf/syscall.c:5089:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
> > int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
>
> Looking at the code it seems intentional, even if questionable.
> I wish BPF didn't have all these W=1 warnings, I always worry
> we'll end up letting an real one in since the CI only compares
> counts and the counts seem to fluctuate.

Yeah. It is intentional.
We used all sorts of hacks to shut up this pointless warning.
Just grep for __diag_ignore_all("-Wmissing-prototypes
in two files already.
Here I've opted for the explicit hack and the comment.
Pushed this fix to bpf tree:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=4e4588f1c4d2e67c993208f0550ef3fae33abce4

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
