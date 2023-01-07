Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1227E660AAB
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 01:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbjAGAO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 19:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjAGAOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 19:14:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C984D59FA0;
        Fri,  6 Jan 2023 16:14:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83052B81DD9;
        Sat,  7 Jan 2023 00:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93BEC433F0;
        Sat,  7 Jan 2023 00:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673050492;
        bh=AGCCM9sKkfh6uDabKtnebePzzSyj20r4VcPavQ7lAvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fzD8WGkYtyO8yHkmZAnOVXOo+OH10YaXJEjY/PtvcN9z3PRfJvlgFW5BoU1+Ipiyj
         qDQhiiYZK/1o/NayOKHeGwD+PMj9BN2lVVpg3I/NRMAs6Qz4iifv9NrOsywHCpRVx4
         DXwL9iwPALkwms+KmvEYHN2yUCKUsWtTmQL5YPduru2oSL6dSS8MOBl1WOeJiGfEAo
         SgCsLVi4ic8nEVSx5T1ZERoGMm9+Ws0bgHuL5GhSy1XseJ00IAccT1BSt7Pe6OoF/Q
         3EambGDcBbw7RskCAGbVy2lgGCu7gtD+F6z5h5n2wvorqZsJYQaUuViH6t+SKkegrZ
         sl4vNcE7jWErw==
Date:   Fri, 6 Jan 2023 16:14:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org
Subject: Re: [PATCH net v2] af_unix: selftest: Fix the size of the parameter
 to connect()
Message-ID: <20230106161450.1d5579bf@kernel.org>
In-Reply-To: <b80ffedf-3f53-08f7-baf0-db0450b8853f@alu.unizg.hr>
References: <bd7ff00a-6892-fd56-b3ca-4b3feb6121d8@alu.unizg.hr>
        <20230106175828.13333-1-kuniyu@amazon.com>
        <b80ffedf-3f53-08f7-baf0-db0450b8853f@alu.unizg.hr>
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

On Fri, 6 Jan 2023 20:28:33 +0100 Mirsad Goran Todorovac wrote:
> The patch is generated against the "vanilla" torvalds mainline tree 6.2-rc2.
> (Tested to apply against net.git tree.)

This kind of info belongs outside of the commit message (under the 
--- line).

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Cc: Florian Westphal <fw@strlen.de>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> 

no new line here

> ---

still doesn't apply, probably because there are two email footers
