Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DC75661AB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 05:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiGEDKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 23:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGEDKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 23:10:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86672E00E;
        Mon,  4 Jul 2022 20:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A82CB810AF;
        Tue,  5 Jul 2022 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8FEC3411E;
        Tue,  5 Jul 2022 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656990610;
        bh=jSL1zYuaa8lHMX+59jw4D5rvzu5VvgC876y6rTNOZaQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KRUAJKgLA6XWmHcpgMAcXktZLAz0PscJ+s5kF954SBJ/IWtSu/YF5ljrsdn4J3fqT
         pazlpRXzoAr7mTuWt3vSyfj03F2mp9CMk6AjWUtc9ZjO2bYTgOP0I+HWpEn3Wc5ESe
         fGOKHJpGYN3EALkZ5VhX9lclG4gMldjzj1CIRwThUCvCl1uSic5YuUR1iGV6g9/I6S
         FEpZcNnsOLWP+SVeCrkgowkb1wPRtxz7212bHiViEtpE2YzjAeWvZSjyztXnw71vaI
         RU8Q7uBGQ52F7ULNtu9JVsZi8V8F9F6Bl+hk7jIS0K92OJWVl8fTCzQNyAgLPtod8y
         12EBZOWgu90sQ==
Date:   Mon, 4 Jul 2022 20:10:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/3] net: tls: Add ARIA-GCM algorithm
Message-ID: <20220704201009.34fb8aa8@kernel.org>
In-Reply-To: <20220704094250.4265-4-ap420073@gmail.com>
References: <20220704094250.4265-1-ap420073@gmail.com>
        <20220704094250.4265-4-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Jul 2022 09:42:50 +0000 Taehee Yoo wrote:
> RFC 6209 describes ARIA for TLS 1.2.
> ARIA-128-GCM and ARIA-256-GCM are defined in RFC 6209.
> 
> This patch would offer performance increment and an opportunity for
> hardware offload.

Is it okay if you send the crypto patches now and the TLS support after
the merge window? They go via different trees and we can't take the TLS
patches until we get the crypto stuff in net-next. We could work
something out and create a stable branch that both Herbert and us would
pull but we're getting close to the merge window, perhaps we can just
wait?
