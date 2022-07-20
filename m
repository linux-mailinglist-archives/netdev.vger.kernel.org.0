Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9AA57AF8E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 05:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237206AbiGTDmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 23:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbiGTDmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 23:42:22 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF61568DD7;
        Tue, 19 Jul 2022 20:42:21 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m16so22121304edb.11;
        Tue, 19 Jul 2022 20:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0OoNPUELJ/dSSGDR8KkMHB3StJZhXQRZj0KnIM+IGw=;
        b=VIIQ8U7Ufmij10zNk1oSmGlrHgsRYf6ziCUT9ukZw+92okO4rvvYurKnINAnisfPY8
         0ZkRGXTuG3TZHqpSf+Yb24NFQXc8FKn5Yxr5ToqW5YOisen5BM0jA4BkAi1nEOVboUKv
         CDfQmgyb70nB7SuzyrdRXuN2GJCqDLO6aUZcpq3HBbTRCxqXxa8lu8BbRI4xBXn/OEYu
         HEoXkWjXalBSN8lDiD3yOZBi7uIf94FxDvs8CxhGKaqEtV5KNYKeMh20OD7SruiqZfU8
         flVsia8L19D9lubBjfV23ssib4wBRc2c8/ypUmwnkqumwe/EroUmngt1LYe1Q4djaioR
         aZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0OoNPUELJ/dSSGDR8KkMHB3StJZhXQRZj0KnIM+IGw=;
        b=2d+M7zLKRo7kNI+id1MJBKMTxeG5vuzBRn0TBZikSgWrgKtYIk6dNlTKI/0n4jFTw0
         8bgj2J+m7eEr3KME8Uehk1Qbx6pIzvgz7TgzjTn0EsLJsjPizYkRfht4H2LoPkeOiLv4
         R2otr9alBPUSDGMuQIafZevHWzcbCts+QsMNCiyizgztHz9SZCa54DAzMqyG600pI8AL
         97+l0g7kQ/pan0Tk6OTQh8UzD1v3imkF95LyBAfDz6kyh8a1ceIOzXn6/LaXcUMX70/J
         oaf/VseAhQbIp5ZICCn2a4D6N11dg82yTzRsygno6LC0EdE9ntUsCNEgc6H5NpP+qF5/
         +Hlg==
X-Gm-Message-State: AJIora/84UyPDRFsLe2FfZ+HoMlipYBSCGfv6pUfZyE08gb8O/99U971
        412GAUqSxejL1TrzcTIDaKqJ1qsuk55Ra2DS5lywjewQ
X-Google-Smtp-Source: AGRyM1uInEkRlcwDbWJT8P/mXmZxsWQh0YNxSyLjjh0wFjK/WSWbHSm7Fqm00GFFtN9vBjiFWwqgLZGh7Zw4p11lHJM=
X-Received: by 2002:aa7:d053:0:b0:43a:a164:2c3 with SMTP id
 n19-20020aa7d053000000b0043aa16402c3mr47940490edo.333.1658288540354; Tue, 19
 Jul 2022 20:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220720115956.3c27492f@canb.auug.org.au>
In-Reply-To: <20220720115956.3c27492f@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Jul 2022 20:42:09 -0700
Message-ID: <CAADnVQ+xFuff3TRhzrPWkJD+MA16MdRvcprcniX4yzxL5Z+=UA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 7:00 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> ld: warning: discarding dynamic section .glink
> ld: warning: discarding dynamic section .plt
> ld: linkage table error against `bpf_trampoline_unlink_cgroup_shim'
> ld: stubs don't match calculated size
> ld: can not build stubs: bad value
> ld: kernel/bpf/cgroup.o: in function `.bpf_cgroup_link_release.part.0':
> cgroup.c:(.text+0x2fc4): undefined reference to `.bpf_trampoline_unlink_cgroup_shim'
> ld: kernel/bpf/cgroup.o: in function `.cgroup_bpf_release':
> cgroup.c:(.text+0x33b0): undefined reference to `.bpf_trampoline_unlink_cgroup_shim'
> ld: cgroup.c:(.text+0x33c0): undefined reference to `.bpf_trampoline_unlink_cgroup_shim'
>
> Caused by commit
>
>   3908fcddc65d ("bpf: fix lsm_cgroup build errors on esoteric configs")
>
> I have reverted that commit for today.

Argh.

Stan,

please take a look.
