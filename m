Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5B39F352
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhFHKTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:19:14 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:46767 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFHKTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 06:19:12 -0400
Received: by mail-lf1-f50.google.com with SMTP id m21so15505773lfg.13;
        Tue, 08 Jun 2021 03:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/kG8V+AHwF7Vw4Oeyk2iREQwi0kZ/IRfBQgI4KKxp6M=;
        b=P6Jh/6syS0z2xae2Z5DjWFQlgwL7X4THFA7MBZaDIJhg5Zv93nuJ/xdLceo/op85MZ
         ctEPcWirnWTaXk2oRlEeuUw5vOB+kxKemXEHv2ndcSpS3TUQmkW2SqePSpUy81oW8HnA
         rpM8A5l6WUpXklLuHFG0JO5Bvs6ytV+FqIVVGL3Eu5nAp7FRKRX9symYSKMuFOiRQmcT
         qf/Ka+GOjHIovV656tjKIFiUnXL6XqWLGoRPNVPuweYeTj1eJtwu6rZPOFkfQymtfqgH
         9IFbG3rxngZURrr7fH3Esc0ena6wAY2VbenbbdkZ00KKudxs04skulCBa6CmkmY+XtdS
         B6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kG8V+AHwF7Vw4Oeyk2iREQwi0kZ/IRfBQgI4KKxp6M=;
        b=QpXN+KX6o0d08vBpTgTPQIAOTCfDEXt80SnD4RFKlaay06gCUilvmCPpaM15lkofwV
         qOqv2FoF+jZ3015c1tDhngiBRGwWkib7DxGIgL8Sv+SXqkE86lS0oTeQVrNRhMYAilTr
         CR1xDSPTfDsS6HFNDxL6ZrX5+WCuJx6GVAEZX4wOap5M2pzttfjmHDL5Xp90H0ZioHGi
         765ovOAD6JlREB/GVXqiqohF72DX2DOKLjhJI8rryvlSaDNLE/tiIbi2Naya6iJsQUvd
         0f4XCSYHMHDudbn9Q22J38ONVFyooqzPe2xcMgZPaF70kibZO0ATmE20DMeONhHpjToL
         d01g==
X-Gm-Message-State: AOAM533UUmbTd6yTUhGHSrsjkuvcNdeNARe5s4MAO62NY4Zqy9hj93Sn
        QdqTj5yR9QnHioOi4V3af0jkewUJiawdaA==
X-Google-Smtp-Source: ABdhPJw+AKbNsLTeVJfThbrF4GRfbCRIxC8oxgrZtZUHtRrtD7Eh1PFM54cR/rdw+rFbNzuAlv6dfQ==
X-Received: by 2002:a05:6512:ace:: with SMTP id n14mr14077603lfu.368.1623147377985;
        Tue, 08 Jun 2021 03:16:17 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id h19sm95405lfj.256.2021.06.08.03.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 03:16:17 -0700 (PDT)
Date:   Tue, 8 Jun 2021 13:16:14 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kadlec@netfilter.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        unixbhaskar@gmail.com, yhs@fb.com, yoshfuji@linux-ipv6.org,
        zhengyongjun3@huawei.com
Subject: Re: [syzbot] general protection fault in kcm_sendmsg
Message-ID: <20210608131614.15ca4340@gmail.com>
In-Reply-To: <000000000000b3f96105c42ef146@google.com>
References: <000000000000b3f96105c42ef146@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Jun 2021 08:46:26 -0700
syzbot <syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1a802423 virtio-net: fix for skb_over_panic inside
> big mode git tree:       bpf
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=159b08afd00000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=65badd5e74ec62cb67dc syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=104624afd00000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e36197d00000
> 
> The issue was bisected to:
> 
> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Apr 21 07:51:08 2021 +0000
> 
>     netfilter: arp_tables: pass table pointer via nf_hook_ops
> 
> bisection log:
> https://syzkaller.appspot.com/x/bisect.txt?x=11739740300000 final
> oops:     https://syzkaller.appspot.com/x/report.txt?x=13739740300000
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=15739740300000
> 

#syz fix: revert "net: kcm: fix memory leak in kcm_sendmsg"



With regards,
Pavel Skripkin
