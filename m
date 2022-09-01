Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F6B5AA091
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiIAT74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiIAT7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:59:54 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5448D62DF
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 12:59:51 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d16so35697ils.8
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 12:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ekynf+/BSh/SSLKbRbwHtlCTZ6yGYWXyonn9Bv5B8Bc=;
        b=SkX7tOUcaATU7cJVXxyr9eimSNbrsSgQAivI4QMSQOiXuRj0XvDIl716g23uG0rDBK
         Tot2KOcKVaz1Vmkf7Hc+ulgsBCzQAMBZGsOtL4BeJnulNeN3CPqgwNKhR8tqsN/cS2DM
         Gdf2rNbG+qQ8jgS0bMS8rXzrp9Sxryg8iog8jquadAF9DwPm8RByST8m/5Ul7r20LYSF
         nZHXj8ufx6beh6I0LRKXT8IqeD9m2kEmqA2LUC9a0i64fHo31b2zGDnHE+p12smhriLi
         A6ZzOgIUwbSnX1iiWZ7LuUV/9bRKXEuZQ6uj7ZBs8XLkY5d4WLeVeTRlMrRrBI5ahNsR
         Egpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ekynf+/BSh/SSLKbRbwHtlCTZ6yGYWXyonn9Bv5B8Bc=;
        b=A8zAVwzxzEkAACsBDOH1VtsyHVeq09ee2I60N5rb7WYrnF/mIoA1C+Ncy8gtC6ULLs
         ORfuemznO21XKljvnd32LORNg6e93oPtYeZUJ7u1YjAFYwBRzJNsmTO7Vd9ig3WEZLlW
         i/xtxIA+q4FPxD3Ev01XcFVOUIQ78cesI0KHVS4NGqzXmKqG52dmSMn4Crdbkh/J4TUr
         IFupLDqlrcfyA8tVlPkMc/eDTZL/ndCp0goqiEgcovMShTvVCDQo7B46zs1eoscwp1FL
         SM7z+hnnnysRPEhMMTSY3P6Vlbe2mVKJRiFFAqeXnBoeP+wo5xtvfW7mTbr0Vgzv7d4F
         yjHA==
X-Gm-Message-State: ACgBeo0m4BoMiz/yYpd710qa3vwrYZpBNi9UkdYfrDakQ7pMQPVUQ4Ev
        oJCe6cZYk3Q6ft5CuMfQKnf18QuhTWJ3jtiSJsWVJg==
X-Google-Smtp-Source: AA6agR49NPfEJI4FfVSTP4h6PGe2YxY4wjxg6NOvPXrQ5XwPJyXndWzskiAsxBlViqFWenXpXCk7Z0ld77R3caQiLEQ=
X-Received: by 2002:a92:da0d:0:b0:2eb:3361:c58c with SMTP id
 z13-20020a92da0d000000b002eb3361c58cmr8430258ilm.247.1662062390589; Thu, 01
 Sep 2022 12:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220901105512.177ed27d@canb.auug.org.au>
In-Reply-To: <20220901105512.177ed27d@canb.auug.org.au>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Thu, 1 Sep 2022 12:59:14 -0700
Message-ID: <CAJHvVciosP4fJ-uP-NknAcfoYt0awd5KzDwmG+d+zRiyps5mAA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 5:55 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   tools/testing/selftests/net/.gitignore
>
> between commit:
>
>   5a3a59981027 ("selftests: net: sort .gitignore file")
>
> from the net tree and commits:
>
>   c35ecb95c448 ("selftests/net: Add test for timing a bind request to a port with a populated bhash entry")
>   1be9ac87a75a ("selftests/net: Add sk_bind_sendto_listen and sk_connect_zero_addr")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks Stephen, and sorry for the trouble.

For what it's worth, I talked about the potential for conflicts with
Jakub in this thread [1]. For next time, is calling it out in the
commit message explicitly the right thing to do?

[1]: https://patchwork.kernel.org/project/netdevbpf/patch/20220819190558.477166-1-axelrasmussen@google.com/

>
> --
> Cheers,
> Stephen Rothwell
>
> diff --cc tools/testing/selftests/net/.gitignore
> index de7d5cc15f85,bec5cf96984c..000000000000
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@@ -1,15 -1,7 +1,16 @@@
>   # SPDX-License-Identifier: GPL-2.0-only
> ++bind_bhash
>  +cmsg_sender
>  +fin_ack_lat
>  +gro
>  +hwtstamp_config
>  +ioam6_parser
>  +ip_defrag
>   ipsec
>  +ipv6_flowlabel
>  +ipv6_flowlabel_mgr
>   msg_zerocopy
>  -socket
>  +nettest
>   psock_fanout
>   psock_snd
>   psock_tpacket
> @@@ -20,23 -11,35 +21,25 @@@ reuseport_bp
>   reuseport_bpf_cpu
>   reuseport_bpf_numa
>   reuseport_dualstack
>  -reuseaddr_conflict
>  -tcp_mmap
>  -udpgso
>  -udpgso_bench_rx
>  -udpgso_bench_tx
>  -tcp_inq
>  -tls
>  -txring_overwrite
>  -ip_defrag
>  -ipv6_flowlabel
>  -ipv6_flowlabel_mgr
>  -so_txtime
>  -tcp_fastopen_backup_key
>  -nettest
>  -fin_ack_lat
>  -reuseaddr_ports_exhausted
>  -hwtstamp_config
>   rxtimestamp
> - socket
>  -timestamping
>  -txtimestamp
> ++sk_bind_sendto_listen
> ++sk_connect_zero_addr
>   so_netns_cookie
>  +so_txtime
> ++socket
>  +stress_reuseport_listen
>  +tap
>  +tcp_fastopen_backup_key
>  +tcp_inq
>  +tcp_mmap
>   test_unix_oob
>  -gro
>  -ioam6_parser
>  +timestamping
>  +tls
>   toeplitz
>   tun
>  -cmsg_sender
>  +txring_overwrite
>  +txtimestamp
>  +udpgso
>  +udpgso_bench_rx
>  +udpgso_bench_tx
>   unix_connect
>  -tap
>  -bind_bhash
>  -sk_bind_sendto_listen
>  -sk_connect_zero_addr
