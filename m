Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9540F57559E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbiGNTFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiGNTFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4773065D4D;
        Thu, 14 Jul 2022 12:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8424B621D9;
        Thu, 14 Jul 2022 19:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CD9C34114;
        Thu, 14 Jul 2022 19:05:07 +0000 (UTC)
Date:   Thu, 14 Jul 2022 15:05:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [for-next][PATCH 03/23] tracing: devlink: Use static array for
 string in devlink_trap_report even
Message-ID: <20220714150506.34bef430@gandalf.local.home>
In-Reply-To: <YtBjKLsoB4e+hSB5@shredder>
References: <20220714164256.403842845@goodmis.org>
        <20220714164328.461963902@goodmis.org>
        <YtBjKLsoB4e+hSB5@shredder>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 21:40:40 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> On the off chance that my tags weren't omitted on purpose:

Ah, I probably pulled it in from my patchwork before you sent the tags. I
usually let my internal patchwork add them for me. So, it was not on
purpose.

It's also a reason I post to the mailing list before I push to linux-next.
In case I missed anything.

> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>

Will add. Thanks!

> 
> s/even/event/ in subject

I'll fix that too.

-- Steve
