Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4542645B1D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiLGNjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLGNjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:39:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6453A5AE21;
        Wed,  7 Dec 2022 05:39:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DE7AB81DF3;
        Wed,  7 Dec 2022 13:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387A1C433C1;
        Wed,  7 Dec 2022 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670420343;
        bh=THbZ8IgZvMyeGTlqZD3RV5aR1dEbLMrqvq10ss0fGek=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=apBquIb+u3nlJdKnc5/rvbDXQuAg9XLOAAAr6stvNYlt3N8BlJ5KXGtGKiRdoGxp2
         82KixJb7gFcq7/CQYbhl8LlFEyRAv67NgGdHX7s87urGZsGQ0fVklj6cEZkLOLo1oC
         y0ofh2Rpr+vhcmfIcfRaZMD6ZkAH1fvYRY2EsieokVY8tQNEbQ0dpnI0dqvu9QeFgG
         KwklsDURNJEXNS6sRpwh7euh3PZclIpZpmqyQN8yo9nfmxGQv9SvbzJtK5PYPZUHfO
         XoKt7uabzsrkOhdsU4kq1AAWlL6zdF7+h6cYXjYaqsTzicnMIXau7DOH6GYJkvcc6V
         shn71OLZG0Sdg==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 06/15] selftests/xsk: add debug option for
 creating netdevs
In-Reply-To: <20221206090826.2957-7-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-7-magnus.karlsson@gmail.com>
Date:   Wed, 07 Dec 2022 14:39:00 +0100
Message-ID: <871qpbuydn.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Add a new option to the test_xsk.sh script that only creates the two
> veth netdevs and the extra namespace, then exits without running any
> tests. The failed test can then be executed in the debugger without
> having to create the netdevs and namespace manually. For ease-of-use,
> the veth netdevs to use are printed so they can be copied into the
> debugger.
>
> Here is an example how to use it:
>
>> sudo ./test_xsk.sh -d
>
> veth10 veth11
>
>> gdb xskxceiver
>
> In gdb:
>
> run -i veth10 -i veth11
>
> And now the test cases can be dugged with gdb.

Nit: "debugged"
