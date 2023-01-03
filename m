Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EFB65BF24
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 12:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjACLjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 06:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbjACLiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 06:38:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA587DEC;
        Tue,  3 Jan 2023 03:38:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pCfcm-0003Qp-Vs; Tue, 03 Jan 2023 12:38:33 +0100
Date:   Tue, 3 Jan 2023 12:38:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Quentin Deslandes <qde@naccy.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Kernel Team <kernel-team@meta.com>, fw@strlen.de
Subject: Re: [PATCH bpf-next v3 00/16] bpfilter
Message-ID: <20230103113832.GA13151@breakpoint.cc>
References: <20221224000402.476079-1-qde@naccy.de>
 <20221227182242.ozkc6u2lbwneoi4r@macbook-pro-6.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227182242.ozkc6u2lbwneoi4r@macbook-pro-6.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> codegen and attach to Florian's bpf hooks exactly at netfilter.
> See
> https://git.breakpoint.cc/cgit/fw/nf-next.git/commit/?h=nf_hook_jit_bpf_29&id=0c1ec06503cb8a142d3ad9f760b72d94ea0091fa

FWIW I plan to submit this patchset for 6.2.
