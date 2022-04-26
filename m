Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178DD50EE8A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 04:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiDZCO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 22:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiDZCOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 22:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C991938D87
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB67B81C01
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4180C385A4;
        Tue, 26 Apr 2022 02:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650939075;
        bh=415QUh6ysu3Xc/7ujLLlCrTXPpKC7HD+24KBWQbT0z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQhgqEH39Dnt28+GEgJb3RW6FgL0wZc9QCRFUi6wB7C1NhuFr5uDdbP8HX/l7BJ/7
         sd1Byao56bQTE3rxzZMCslvXfZobznR4tQa/0iU6BIKFbpGcUbfv4cJjVAkVczqXE6
         OZBNXohi9Jx8HKh52ley/azSVVVq2Kbc3kzUsb2MPhqz0dAYakBOr8xRrrE9WkgybF
         F521jsWXyOMrx0KaK8fkXgy98qzmqjPAgNDWkTyRIeBYbenLoC3jUBOcC6NtEdpdAd
         DkeNFWJmK1Em03fPfsDx6I+k1VdVWSgeG2XS0Bm+kQLeBWXXJ0vyJ6emjqpSont7Ts
         tgxdKVsrdTBkA==
Date:   Mon, 25 Apr 2022 20:11:11 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH iproute2-next v2 2/2] f_flower: Check args with
 num_of_vlans
Message-ID: <20220426021111.GA25966@u2004-local>
References: <20220412100343.27387-1-boris.sukholitko@broadcom.com>
 <20220412100343.27387-3-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412100343.27387-3-boris.sukholitko@broadcom.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 01:03:43PM +0300, Boris Sukholitko wrote:
> Having more than one vlan allows matching on the vlan tag parameters.
> This patch changes vlan key validation to take number of vlan tags into
> account.
> 
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---
>  tc/f_flower.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 

does not apply cleanly to iproute2-next
