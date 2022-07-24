Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0857F798
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiGXXNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiGXXM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53F10FDC;
        Sun, 24 Jul 2022 16:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D0560AC5;
        Sun, 24 Jul 2022 23:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6132C3411E;
        Sun, 24 Jul 2022 23:12:52 +0000 (UTC)
Date:   Sun, 24 Jul 2022 19:12:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: Re: [for-next][PATCH 17/23] batman-adv: tracing: Use the new
 __vstring() helper
Message-ID: <20220724191250.2097b8eb@rorschach.local.home>
In-Reply-To: <8828005.nfsgNN4c79@sven-l14>
References: <20220714164256.403842845@goodmis.org>
        <20220714164331.060725040@goodmis.org>
        <8828005.nfsgNN4c79@sven-l14>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jul 2022 23:31:01 +0200
Sven Eckelmann <sven@narfation.org> wrote:

> On Thursday, 14 July 2022 18:43:13 CEST Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Instead of open coding a __dynamic_array() with a fixed length (which
> > defeats the purpose of the dynamic array in the first place).  
> 
> Please also make sure to remove the define of BATADV_MAX_MSG_LEN

I usually do not like to rebase my for-next and just add on a patch to
do something like this, but for this series I'll make an exception.

-- Steve
