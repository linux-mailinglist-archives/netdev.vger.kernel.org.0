Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7746DBD3C
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 23:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDHViJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 17:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHViI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 17:38:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FBF44A9;
        Sat,  8 Apr 2023 14:38:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1plGG3-00013w-US; Sat, 08 Apr 2023 23:38:03 +0200
Date:   Sat, 8 Apr 2023 23:38:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next 6/6] bpf: add test_run support for netfilter
 program type
Message-ID: <20230408213803.GA9679@breakpoint.cc>
References: <20230405161116.13565-1-fw@strlen.de>
 <20230405161116.13565-7-fw@strlen.de>
 <20230407013638.iels3lvezufbrenr@dhcp-172-26-102-232.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407013638.iels3lvezufbrenr@dhcp-172-26-102-232.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >  static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
> > diff --git a/tools/testing/selftests/bpf/verifier/netfilter.c b/tools/testing/selftests/bpf/verifier/netfilter.c
> > new file mode 100644
> > index 000000000000..deeb87afdf50
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/verifier/netfilter.c
> > @@ -0,0 +1,23 @@
> > +{
> > +	"netfilter, accept all",

[..]

> We're adding all new asm tests to test_progs now instead of test_verifier. See progs/verifier_*.c.

Thanks for the pointer, I'll have a look at this for v2.
