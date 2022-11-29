Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E6E63C4EE
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiK2QPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbiK2QPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:15:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B66CCD;
        Tue, 29 Nov 2022 08:15:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEDEAB8169F;
        Tue, 29 Nov 2022 16:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1D3C433C1;
        Tue, 29 Nov 2022 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669738512;
        bh=7+SFe4iBpPQPpkZS2WbJcUsKadar590WDUqsLd4jJpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m/SkbXFyDGDfdXOWx/ncH/41Fc1DwZeb3nirHjJkSWoqzgTV5io44u3LlkSnM5oXP
         Yx32zaM0WAHFwsTcpVwde0JRLeqp2IpP0WbnOvduD4B2fXbJLt4Xbw+G/QAck9Am3R
         DatCvHe6m48MTZgxjKJkHtn63keVecaZrfsXVgblHPSxPApN6bDTjJc6ui4bY2kAJF
         54sUhyWV0q17pCosFwpsgxCgwGcrYcn28/y1/Y3wIJHkIkAdnDH9Jv5HtVRlN0/TIq
         WQOVRi4UB2fDdpbIttQ42W/Il8ZN8b4LXEr8AzN9qO1vTfdcWRiZpyJ0n6DsJvtLYd
         yn5Z0Va7/AwDw==
Date:   Tue, 29 Nov 2022 08:15:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <herbert@gondor.apana.org.au>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <nicolas.dichtel@6wind.com>,
        <razor@blackwall.org>, <mykolal@fb.com>, <ast@kernel.org>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <shuah@kernel.org>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers
 for setting/getting XFRM metadata from TC-BPF
Message-ID: <20221129081510.56b1025e@kernel.org>
In-Reply-To: <20221129095001.GV704954@gauss3.secunet.de>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
        <20221128160501.769892-3-eyal.birger@gmail.com>
        <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
        <20221129095001.GV704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 10:50:01 +0100 Steffen Klassert wrote:
> > Please tag for bpf-next  
> 
> This is a change to xfrm ipsec, so it should go
> through the ipsec-next tree, unless there is
> a good reason for handling that different.

Yeah, this is borderline. Do the patches apply cleanly to Linus's tree?
If so maybe they can be posted as a PR and both trees can pull them in,
avoiding any unnecessary back and forth...
