Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AEA60B8FB
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiJXT7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiJXT7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:59:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279AA1A39B;
        Mon, 24 Oct 2022 11:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82619B811B1;
        Mon, 24 Oct 2022 18:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC00C433C1;
        Mon, 24 Oct 2022 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666635672;
        bh=Sm3Otxq+YEJ8aZhxWt0m0arM/JhdPmMSj+3nytYHJPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XMQN1c1X9aQsv7zPPFiwCfUdRS+ReNyCJNH65bDglHa1ChMUK2NsdLVnef1opyJqp
         F0HIR01kOpsK6ipb7wzZ2cxeaFUeIyWQo1Lgn/8/u0SJba+SzqdVOPOK+2UwIFdIRK
         MPxrW1/zqkspUvvHt52N7LfCAsJSLItB3GtL+266XpQSLlh6y2AZ82sAle/kyuLTDq
         IN+BpZhooTGioB1fi8MqB0M8MWqFDfj7S0XBkL41DEgZfh6MCIQtowJ46VvG/O6h5y
         /2cJrI9juzr44zVDDQW2TuMz3qU6wqfxDwgO3SogjbP96vhwElUakGQs6YEuJYhCSV
         jWoyHMbWpOEJg==
Date:   Mon, 24 Oct 2022 11:21:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221024112111.6d8b9c40@kernel.org>
In-Reply-To: <CAADnVQKUSfGUM5WBsbAN00rDO9hKHnMFdEin7MbW4an03W3jGg@mail.gmail.com>
References: <20221004072522.319cd826@kernel.org>
        <Yz1SSlzZQhVtl1oS@krava>
        <20221005084442.48cb27f1@kernel.org>
        <20221005091801.38cc8732@kernel.org>
        <Yz3kHX4hh8soRjGE@krava>
        <20221013080517.621b8d83@kernel.org>
        <Y0iNVwxTJmrddRuv@krava>
        <CAEf4Bzbow+8-f4rg2LRRRUD+=1wbv1MjpAh-P4=smUPtrzfZ3Q@mail.gmail.com>
        <Y0kF/radV0cg4JYk@krava>
        <CAEf4BzZm2ViaHKiR+4pmWj6yzcPy23q-g_e+cJ90sXuDzkLmSw@mail.gmail.com>
        <Y1MQVbq2rjH/zPi2@krava>
        <20221021223612.42ba3122@kernel.org>
        <CAADnVQKUSfGUM5WBsbAN00rDO9hKHnMFdEin7MbW4an03W3jGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Oct 2022 18:18:49 -0700 Alexei Starovoitov wrote:
> > If you mean the warning from the subject then those do seem to be gone.
> > But if I'm completely honest I don't remember how I triggered them in
> > the first place :S There weren't there on every build for me.
> >
> > The objtool warning is still here:
> >
> > $ make PAHOLE=~/pahole O=build_allmodconfig/ -j 60 >/tmp/stdout 2>/tmp/stderr; \
> >     cat /tmp/stderr
> >
> > vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> > vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0  
> 
> The effect of the compiler bug was addressed by this fix:
> https://lore.kernel.org/all/20221018075934.574415-1-jolsa@kernel.org/
> 
> It's in the bpf tree, but the warning will stay.
> While the compiler is broken the objtool should keep complaining.

Thanks! I'll stop tracking it
