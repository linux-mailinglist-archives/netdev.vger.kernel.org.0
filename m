Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A7C5BDD98
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 08:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiITGr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 02:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiITGrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 02:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B65017A84
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 23:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1847061956
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCE1C433C1;
        Tue, 20 Sep 2022 06:47:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PE4i5qPX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663656471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EeurZ3PP0yarzUoWnYEBHxbncriNVmb1WlKJuqUlFVQ=;
        b=PE4i5qPXgB5uHSr1+BG7XdUNYX8pNHzGH6yJyT5PAYB6U1PpPNu1oqYy/Jx0U3+ebaN3s8
        Vohg8aQM4iwgHqAhM8E6dDM+cCx4VIwe+VZFhj/e22jG4vJZ4WNR000IE5NLLUOe0dYRRc
        CXfM03dh7Hnvz8COr0AClzTxbuSTKjY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 97420aa8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 20 Sep 2022 06:47:50 +0000 (UTC)
Date:   Tue, 20 Sep 2022 08:47:48 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     pablo@netfilter.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] wireguard patches for 6.0-rc6
Message-ID: <YyliFHzqeYKomxwv@zx2c4.com>
References: <20220916143740.831881-1-Jason@zx2c4.com>
 <20220919182053.2936e7e4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220919182053.2936e7e4@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 06:20:53PM -0700, Jakub Kicinski wrote:
> On Fri, 16 Sep 2022 15:37:37 +0100 Jason A. Donenfeld wrote:
> > Sorry we didn't get a chance to talk at Plumbers. I saw some of you very
> > briefly in passing but never had the opportunity to chat. Next time, I
> > hope.
> 
> Indeed!
> 
> > Please pull the following fixes:
> 
> You say pull but you mean apply, right?

Yes, sorry.

Jason
