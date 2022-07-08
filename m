Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A656AF88
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbiGHA42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiGHA41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:56:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156A570E75;
        Thu,  7 Jul 2022 17:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E9AB823CC;
        Fri,  8 Jul 2022 00:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CCC341C0;
        Fri,  8 Jul 2022 00:56:23 +0000 (UTC)
Date:   Thu, 7 Jul 2022 20:56:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] neighbor: tracing: Have neigh_create event use
 __string()
Message-ID: <20220707205622.78f4fe2e@gandalf.local.home>
In-Reply-To: <20220707172101.25ae51c8@kernel.org>
References: <20220705183741.35387e3f@rorschach.local.home>
        <20220707172101.25ae51c8@kernel.org>
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

On Thu, 7 Jul 2022 17:21:01 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> > 
> > [ This is simpler logic than the fib* events, so I figured just
> >   convert to __string() instead of a static __array() ]  
> 
> This one is also going via your tree?

Yep, I can pull it in too.

-- Steve
