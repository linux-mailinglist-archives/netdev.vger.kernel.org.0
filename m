Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86656BEE58
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCQQbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCQQbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:31:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F214B2886D;
        Fri, 17 Mar 2023 09:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27C2DB82641;
        Fri, 17 Mar 2023 16:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FCCC433EF;
        Fri, 17 Mar 2023 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679070690;
        bh=sdGXfHkOqQCaXHYmjVfgZIb18IR0moDxC7j/QqRSEqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xb39oSxm3sFYVVPupiH9yCoxew9J6Tcaj53Wn0R8RfdeRAVCUv5Pv81phZfgK67dH
         Ql3RsW9gh0K7FbM3i8K+SnCYzod5yrKxaWVeXFx23toOn6fJFH/P2BDbNlwg7XcRer
         6JJu/BWkESRrDTt1O/8IlGvaam92/i4h0GVQuJulG4TtYpZEEjH34AihA2AeVmbYTT
         PAyGHGbuSlH0PqBKPR+5k5dHH/A6suzEgEtfsEfb0LxA7kkd9rCNKlYwC6n4u5Ct2P
         47n3/EDSFsesiElHbnDeYmjzMReI8j5v+qAkHSgQy6qwJrYOd4UOJ7rwpbtnB9dIvk
         uF5tLH3DESgEg==
Date:   Fri, 17 Mar 2023 09:31:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for v6.3-rc3
Message-ID: <20230317093129.697d2d6d@kernel.org>
In-Reply-To: <20230317053152.2232639-1-kuba@kernel.org>
References: <20230317053152.2232639-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 22:31:52 -0700 Jakub Kicinski wrote:
> Hi Linus!
> 
> A little more changes than usual, but it's pretty normal for us
> that the rc3/rc4 PRs are oversized as people start testing in
> earnest. Possibly an extra boost from people deploying the 6.1 LTS
> but that's more of an unscientific hunch.

Sorry, please drop this one if it's not a hassle. I'll send a v2.
More patches went in overnight..
