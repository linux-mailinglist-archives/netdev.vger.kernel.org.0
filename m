Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F115A52D976
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbiESPy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240863AbiESPy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:54:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD5A7CDEC;
        Thu, 19 May 2022 08:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9959261B71;
        Thu, 19 May 2022 15:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4EFC34100;
        Thu, 19 May 2022 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652975695;
        bh=x9WlDK0TiaOHlKdYjQ49pDL/7xEBNsmkl6hg7rlF0iE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YbOxHgWsn/oWH62ekzi5bNyTP1I7cOgPgjENbsGju6E7D11gTp6y+JRlRPibR9vJC
         WpyJTLXafs7MiW6v2heZ6aActSrcpqk+rLg+7m4tVGovomneVgEPU1m6+1YftuOdCk
         ARWvHPEUZ0oyExQDBqNgHffhk2qQGjBLW6p32XiY+TxC4d2nwe38qctgOva9scNLB7
         pCTWfOlsoOAgNfT2kY3c4JAp4nna79YAzTuDsVcBfd725Cbhou/Dq51CTM4TnBxjBn
         Gq+sx6EP0uZZfRmbDSok1bNvpQWm7wtOFfMzIYAEobaYZf0U3kP+fsv56HmsBF82Ru
         sWbdJqlkRcC4w==
Date:   Thu, 19 May 2022 08:54:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     <joannelkoong@gmail.com>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kafai@fb.com>,
        <pabeni@redhat.com>, <richard_siegfried@systemli.org>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>,
        <dccp@vger.kernel.org>
Subject: Re: [PATCH net-next v5 1/2] net: Add a second bind table hashed by
 port and address
Message-ID: <20220519085453.1f499514@kernel.org>
In-Reply-To: <20220519075119.87442-1-kuniyu@amazon.co.jp>
References: <20220518231912.2891175-2-joannelkoong@gmail.com>
        <20220519075119.87442-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 16:51:19 +0900 Kuniyuki Iwashima wrote:
> To maintainers:
> lore and patchwork seem to miss this version...?

Yeah :( We're trying to debug with Joanne and the vger admin,
if we can't fix it by the end of the day I'll just merge the
last posting that made it thru, IIRC the patches are identical.

Thanks for the review!
