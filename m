Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE05EC70D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiI0O7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiI0O67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A4B4D4F3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 07:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 019AD61A14
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 14:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173BBC433C1;
        Tue, 27 Sep 2022 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664290736;
        bh=45xIoDN/qAv8jmALP4wCeqOlDXNzOuiLYwON3J3fERM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YxowAPzC7rwaAWnnt4QvKWfFm/6QXyStbIKyd3NenMzUhS+hYsJ5oiqcOPbYe+7HP
         TvkKkRrThRMw/clieIIVu+rr2Sdn1P5TBcc/+YZ3M6PEF0qlSwyl6WTHXzy78SqR4e
         In+T9Du5j0WPEWI7UMep/a6S2CeoEZDS1ajt/EbhQsDgJQJl64SWlU7JpLmIkK7rzX
         T4niO/kBMPdnvXXC9YCFnlJkgeBsAvEsvx7xdDYqkkkFVAz1e/sCP0BtFKmozf8nyh
         zZ86jU6XA2sRzHH2FhFyHeECb9bt+steOO76VIbr+JHSbunstZ7hS+X6J1NctU7gF+
         /8Y5qX2TxMdWQ==
Date:   Tue, 27 Sep 2022 07:58:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liu Jian <liujian56@huawei.com>
Cc:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Add helper functions to parse netlink msg
 of ip_tunnel
Message-ID: <20220927075855.7c09921b@kernel.org>
In-Reply-To: <20220926131944.137094-1-liujian56@huawei.com>
References: <20220926131944.137094-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 21:19:42 +0800 Liu Jian wrote:
> Add helper functions to parse netlinkmsg of ip_tunnel
> 
> Liu Jian (2):
>   net: Add helper function to parse netlink msg of ip_tunnel_encap
>   net: Add helper function to parse netlink msg of ip_tunnel_parm
> 
>  include/net/ip_tunnels.h | 66 ++++++++++++++++++++++++++++++++++++++++
>  net/ipv4/ipip.c          | 62 ++-----------------------------------
>  net/ipv6/ip6_tunnel.c    | 37 ++--------------------
>  net/ipv6/sit.c           | 65 ++-------------------------------------

Do they need to be in a header file? Could you put them in
net/ipv4/ip_tunnel.c or net/ipv4/ip_tunnel_core.c instead?
