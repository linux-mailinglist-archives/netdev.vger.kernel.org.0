Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B6583670
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbiG1BiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiG1BiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:38:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265FE4E63F;
        Wed, 27 Jul 2022 18:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D81E3B8224E;
        Thu, 28 Jul 2022 01:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CF9C433C1;
        Thu, 28 Jul 2022 01:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658972293;
        bh=6ld4FOwEHnEforzdyOfL83UeKKCu+vXhy3+jLfQFDBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKdVja3l1daftWBAT/9ZLiv6KliRX1NrbryeA3vT3X+9GARH6uOu4CsSGDvHi2/8P
         NIpfTw1oWSqpCOPch/tSVurILN2haq0jjmz0+zOtATwRtpQecT/WBfjw90Wmpjyjar
         +/FHD5SL+sumvHoh3zkyp8/ElQvQ1xivXWTzan9MAmNRI6zxrVuho2cn+whLNHZx9F
         j+wNM7hKBxpYcfOwOQqwKAmJamHbfX8rZgxctaUeIKrK70fESee+v+Ho19oPzsbCO3
         V01HNJ/KUfLhUAK/FU7rRsSNJtQi2kIY4v8fxdHir+064/fdTSvwnBoRvLVG2b2Wuq
         ouvZ4xubu6LYg==
Date:   Wed, 27 Jul 2022 18:38:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] ipv6/addrconf: fix a null-ptr-deref bug for
 ip6_ptr
Message-ID: <20220727183812.5a448126@kernel.org>
In-Reply-To: <b63eeb55-df38-618a-d7af-91b18f1d6f0f@huawei.com>
References: <20220726115028.3055296-1-william.xuanziyang@huawei.com>
        <CANn89iJNHhq9zbmL2DF-up_hBRHuwkPiNUpMS+LHoumy5ohQZA@mail.gmail.com>
        <48fd2345-ef86-da0d-c471-c576aa93d9f5@kernel.org>
        <b63eeb55-df38-618a-d7af-91b18f1d6f0f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 17:11:14 +0800 Ziyang Xuan (William) wrote:
> > Yes, that is the right Fixes commit.  
> 
> OK

Please repost with that changed.
