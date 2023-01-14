Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0645566A995
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjANGP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjANGP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:15:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75033A87
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B4EFB800E2
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 06:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E845C433EF;
        Sat, 14 Jan 2023 06:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673676925;
        bh=x/QJIytcjokcZouOegpfjzUZfIXv+M01orGSdO4RASo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+5f2fmvwYQ643JwllBsHADSxSFzPr+WIgydlfb3OxQijeHSwrIwys45irNJITZzb
         CuWoKzKlCftZYCZifvEPvB6pDoKWgVNqkBIXYlmcbx3KOhSy17kq/CXPCjQNxkipD5
         8wJxltYqjqf/J5GxbzQBmqucEuVcdKaa87dhGHmCtNk3UMrcxP0UplHQDDHFEe4cgP
         r4YxqvbPoGKlvaCHkpSO/EmTWV9oIxxFnRr2hJnkUdcmxXkuTx7kDLKM3r4oKd8/LB
         5lo8RJ7ZQyrB3L30WRP+v2iLwO9xMkjRAmVwPfgagqtAbV3aSHtfTD74+KgwCmObZ1
         aWjN8EquU4Aqw==
Date:   Fri, 13 Jan 2023 22:15:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv4 net-next] sched: add new attr TCA_EXT_WARN_MSG to
 report tc extact message
Message-ID: <20230113221523.7940698a@kernel.org>
In-Reply-To: <20230113034353.2766735-1-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
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

On Fri, 13 Jan 2023 11:43:53 +0800 Hangbin Liu wrote:
> We will report extack message if there is an error via netlink_ack(). But
> if the rule is not to be exclusively executed by the hardware, extack is not
> passed along and offloading failures don't get logged.

Acked-by: Jakub Kicinski <kuba@kernel.org>
