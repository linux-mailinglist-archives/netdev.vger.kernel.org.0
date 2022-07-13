Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AA0573C9E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbiGMSji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiGMSji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08E4201AE
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 11:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40BCF61D17
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 18:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CE5C34114;
        Wed, 13 Jul 2022 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657737576;
        bh=XYDJUuSaSUwLcmwnWJhQXxwgLBGdAsqHXN0rjjiXhJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s61YsKkG/wFCh6gK7btqRkk2TLPRBePWywX1ulHWgj/Lm/VtJ7je+sAl9abTZsKWs
         4ZnL7hwviO3glsr633OyZQy4OucUn5SDVwuM/0Qk27psvBvYWtsGPYnhc+GIg8WgjC
         CSMg56dOdLGr5nZ+JITuWI2d03SzOB0E/X74WgCdAAO9Gjo4RolUCXK1RXw6a0mu/a
         5kcQMsN/GYwIUmR0Os61sElx1mubztMJyzYoDHXzX7yBOD763yjRF84JAcyHAMhutL
         zwq9WISWyrU2XzdMJH8Vy6KZ18mG1VL/10gcdU2kxogvpC+YFQbEqtxSdA7ZWQmzEL
         G7R1UzYBVYqjw==
Date:   Wed, 13 Jul 2022 11:39:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
Message-ID: <20220713113935.7a572178@kernel.org>
In-Reply-To: <20220713124435.GA51741@debian>
References: <20220627085219.GA9597@debian>
        <7be18dc0-4d2c-283d-eedb-123ab99197d3@kernel.org>
        <77c9a31ba08bcc472617c08c0542cd82f7959a58.camel@redhat.com>
        <20220713124435.GA51741@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 14:45:11 +0200 Richard Gobert wrote:
> On Wed, Jul 06, 2022 at 06:21:05PM +0200, Paolo Abeni wrote:
> > I think your reasoning is correct, and I'm now ok with the patch. Jakub
> > noted it does not apply cleanly, so a repost will be needed.
> > Additionally it would be great to include some self-tests.  
> 
> Will include self-tests and submit V2.
> The patch applies cleanly in my local setup. Do you have an idea as to why
> this might happen? I missed the email where Jakub mentioned this.

Jakub noted it in a private conversation with Paolo :)

If it does indeed apply cleanly to net-next [1] please repost with the
tree name explicitly stated in the subject line, ie. [PATCH net-next]
to make sure our bots don't make any mistakes in tree selection for
testing.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
