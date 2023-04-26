Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F726EFB4E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjDZTrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbjDZTrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:47:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B1A2D49
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC9C63889
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94967C433D2;
        Wed, 26 Apr 2023 19:47:15 +0000 (UTC)
Date:   Wed, 26 Apr 2023 15:47:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230426154713.6706865f@gandalf.local.home>
In-Reply-To: <20230426194301.mtw2d5ooi3ywtxad@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
        <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
        <20230412095534.dh2iitmi3j5i74sv@skbuf>
        <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
        <20230421124708.tznoutsymiirqja2@skbuf>
        <20230424182554.642bc0fc@rorschach.local.home>
        <20230426191336.kucul56wa4p7topa@skbuf>
        <20230426152345.327a429d@gandalf.local.home>
        <20230426194301.mtw2d5ooi3ywtxad@skbuf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 22:43:01 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Instead of living in fear that this might happen, I think what would be
> the most productive thing to do would be to just create a proper API in
> the next kernel development cycle to expose just that information, and
> point other people to that other API, and keep the trace events just for
> debugging.

I also want to add that if a tool does use a trace event that was not your
intention, you can then fix the tool to do it properly.

I had this with powertop. It had hardcoded events (did not use
libtraceevent) and when I modified the layout, it broke, and Linus reverted
my changes. After fixing powertop to do things properly, I was able to get
my changes back in.

So even if you do break user space, you can still fix it later.

-- Steve
