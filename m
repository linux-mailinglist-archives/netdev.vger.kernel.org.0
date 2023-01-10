Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AAE664789
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjAJRir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjAJRim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:38:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58F33D1ED
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6406FB818EE
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 17:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E79C433EF;
        Tue, 10 Jan 2023 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673372319;
        bh=hpsVBrD2AP6bjxiM2ZbRE9luOTFspUQUx1MaG7WIPCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jykFf+tbdmO338vQq8tUZeI7n7xU+3wN0r7IxaV5/xK+0QEqHN7RJvEqkaQczXYhu
         yZPne/CrdbBru6nzrpKLCQcm0svnaos8FIyjAHuBmjkR9hmz11C1laHWFC4cqVJLmM
         VNBWzH+oV/BsukL17Sxm8A+bxlUq8c+qz5wEw0UkZ6lqTi4yoskNKcXh/i7iuJnszJ
         YHcrbr2NedLFQ0K4VPmU21N8m/spNlBvWI6WQR+L2ADVaXBDBDhnSYJGFBpi30+9cj
         F03kkNvjS91tJL8TxCnnH/7pbBVzVPoWtbnOJ8MzQ7FbfJJ27U3t+t3iItTi0vOC0f
         DTM4kQctTK4SA==
Date:   Tue, 10 Jan 2023 09:38:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv3 net-next] sched: multicast sched extack messages
Message-ID: <20230110093837.7c10cb0e@kernel.org>
In-Reply-To: <Y707Pa+U7LiJBER/@Laptop-X1>
References: <20230104091608.1154183-1-liuhangbin@gmail.com>
        <20230104200113.08112895@kernel.org>
        <Y7ail5Ta+OgMXCeh@Laptop-X1>
        <CAM0EoMkw8GA=KA_FXV8v4a-RKYCibK64ngp9hRQeT1UzXY4LCg@mail.gmail.com>
        <20230109114306.07d81e76@kernel.org>
        <Y707Pa+U7LiJBER/@Laptop-X1>
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

On Tue, 10 Jan 2023 18:17:33 +0800 Hangbin Liu wrote:
> > > Jakub, would  using specific attributes restricted to
> > > just QDISC/FILTER/ACTION work for you?  
> > 
> > Yes, specific attr to wrap the extack seems acceptable.  
> 
> Looks we go back to the TCA_NTF_WARN_MSG approach[1], right?
> 
> [1] https://lore.kernel.org/all/Y3OJucOnuGrBvwYM@Laptop-X1/

Yes :) 
