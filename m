Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC99599F22
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 18:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350962AbiHSP71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350828AbiHSP5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:57:49 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEF7108B11;
        Fri, 19 Aug 2022 08:51:55 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 27JFoLs62790716;
        Fri, 19 Aug 2022 17:50:21 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 27JFoLs62790716
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1660924221;
        bh=QplMSTV2SCiraGoyFJdZ9D1otqNUvkjIiL0MWjlYKyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LnzCSfk+z2E0XjtdqfHLhC8nL1RHxVAL7rdJ9UWkO5QMYQMPJl6ehcxOEHX2awiGS
         0BfbCPMTGa1DwKZf0o6CJbH6bHkQ8mtn9diW8zf8+qB1sk9EYW9xVdVqNdr82SpFTq
         MUgbWBa4OE/IKSSTuhzKr3ePp/iKkJ+pU7QveqZQ=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 27JFoKJD2790715;
        Fri, 19 Aug 2022 17:50:20 +0200
Date:   Fri, 19 Aug 2022 17:50:20 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Thomas Osterried <thomas@osterried.de>
Cc:     netdev@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-hams@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Bernard Pidoux <f6bvp@free.fr>
Subject: Re: [PATCH net-next 1/1] MAINTAINERS: update amateur radio status.
Message-ID: <Yv+xPBPpxDOSxny7@electric-eye.fr.zoreil.com>
References: <Yv6fCCB3vW++EGaP@electric-eye.fr.zoreil.com>
 <Yv9NOmXjRLf6WSCB@x-berg.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv9NOmXjRLf6WSCB@x-berg.in-berlin.de>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Osterried <thomas@osterried.de> :
[...]
> I disagree.

There's no tag for "Organically Maintained" :o)

I issued 'git log -- net/ax24 net/netrom net/rose' and wandered through the
linux-ham archive.

"Odd Fixes" in Ralf's statement as "scattered, occasional, infrequent"
- thank you wiktionary ! - changes seemed to describe the current state more
accurately than plain "Maintained".

> I hoped Ralf will come back and waited with my offer to do the maintainership.
>
> A question for the process: What needs to be done to get listet as maintainer?

Someone sends a patch, there's no obvious consensus against the victim (was
there ever ?) as he is usually known for some decent track of work or
unformal, de-facto maintainership and he get listed within a few days.

-- 
Ueimor
