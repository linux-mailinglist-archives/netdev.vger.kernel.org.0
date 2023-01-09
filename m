Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5526630B9
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjAITnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbjAITnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:43:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F5F77D18
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C5B7B80E00
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5090DC433EF;
        Mon,  9 Jan 2023 19:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673293387;
        bh=rKRsKGZ5mi7jnepcGflrOmKHPucbDqYbcgVTvz4DPVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=poNBbVjPKSguu4whkDl7lAoRl43W1WxDIhj48P09zwCD6cVT72wbC6A2Mzts36o4Q
         AL+Ippm/woKM6vEI+mVUPiuGU8aoYhIy+PSFRA2nXrawLF1yVaOKC7KbbmrJlwnIXW
         FjN+N4rOjTOLI2UUlFAhuH0KIfKis22tUYmYFOV8KgAdO/gPuoLOiBVEhpMV1tj5mb
         33L8d7rBAB/iXCuhU53e40hlmv/6J+376V9OnECtGlWZsfCxWWXn+MxeUoSW8BO+ur
         ERd2aLg94PcSkcSx9FZ4gi4kmgQ41/oaxpJqRyTT23TIMAC38ZhXvAeHCbCTgE6YcG
         kAtMwRBYQEIpA==
Date:   Mon, 9 Jan 2023 11:43:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv3 net-next] sched: multicast sched extack messages
Message-ID: <20230109114306.07d81e76@kernel.org>
In-Reply-To: <CAM0EoMkw8GA=KA_FXV8v4a-RKYCibK64ngp9hRQeT1UzXY4LCg@mail.gmail.com>
References: <20230104091608.1154183-1-liuhangbin@gmail.com>
        <20230104200113.08112895@kernel.org>
        <Y7ail5Ta+OgMXCeh@Laptop-X1>
        <CAM0EoMkw8GA=KA_FXV8v4a-RKYCibK64ngp9hRQeT1UzXY4LCg@mail.gmail.com>
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

On Mon, 9 Jan 2023 10:56:00 -0500 Jamal Hadi Salim wrote:
> IMO the feature is useful. The idea of using a single tool to get the
> details improves the operational experience.
> And in this case this is a valid event (someone tried to add an entry to
> hardware and s/ware and it worked for
> one and not the other).
> I think Jakub's objection is in the approach.

Right.

> Jakub, would  using specific attributes restricted to
> just QDISC/FILTER/ACTION work for you?

Yes, specific attr to wrap the extack seems acceptable.
