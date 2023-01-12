Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FB966692D
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 04:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbjALDEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 22:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjALDEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 22:04:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2049F485BE;
        Wed, 11 Jan 2023 19:04:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pFnsf-00084U-Eo; Thu, 12 Jan 2023 04:03:53 +0100
Date:   Thu, 12 Jan 2023 04:03:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Deslandes <qde@naccy.de>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <20230112030353.GK27644@breakpoint.cc>
References: <20221224000402.476079-1-qde@naccy.de>
 <20221227182242.ozkc6u2lbwneoi4r@macbook-pro-6.dhcp.thefacebook.com>
 <cf6f7e30-9b0e-497b-87d4-df450949cd32@naccy.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf6f7e30-9b0e-497b-87d4-df450949cd32@naccy.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Deslandes <qde@naccy.de> wrote:
> That sounds interesting. If my understanding is correct, Florian's
> work doesn't yet allow for userspace-generated programs to be attached,
> which will be required for bpfilter.

Yes, but I started working on the attachment side.  It doesn't depend
on the nf-bpf generator patch set.

I think I can share PoC/RFC draft next week.
