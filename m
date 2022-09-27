Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D9C5EC6FB
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiI0OzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiI0Oyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:54:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B7F9B85B;
        Tue, 27 Sep 2022 07:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACBC1B81A2A;
        Tue, 27 Sep 2022 14:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C84C433C1;
        Tue, 27 Sep 2022 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664290378;
        bh=gL5DTXZ10yHU7rt50ir/1T4fgZwq8KALXAqCFoMoXvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DfmaLOTjSCueMk8vj8P3tF5m1OhySsU040EJXkuPeT0+H4D5Mf6NunlveL9naEYB6
         HdeZRfJw7YWi3G6dWRtaxSsZhfVUgxvxR3JGnvxom5k9U8otbBPeOgYqR8wm6L1ez0
         Tdqbjr9UlJruwb2wl0FjZKTc4pIS9Oggv3dhIqdYwl78lSTkouY40eLCWOJ6LdJxNl
         KNzoKy457Sa2Jgfr5L6NbBl3ka0/noNCfEcs2U9XhRKbXIBv63ZG5R22lJBLtivFjG
         udrfUQTHiaj+Tvwuy2ECeeFXzb473euK/zl0l2RXbkrigwXTZjFphXcbRjKMvcEOEv
         Xo5tmDHL71ZAQ==
Date:   Tue, 27 Sep 2022 07:52:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     ruanjinjie <ruanjinjie@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <linmq006@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net: i82596: Add __init/__exit annotations to
 module init/exit funcs
Message-ID: <20220927075257.11594332@kernel.org>
In-Reply-To: <20220926115456.1331889-1-ruanjinjie@huawei.com>
References: <20220926115456.1331889-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 19:54:56 +0800 ruanjinjie wrote:
> Add missing __init/__exit annotations to module init/exit funcs

How many of these do you have? Do you use a tool to find the cases 
where the annotations can be used?

Please read Documentation/process/researcher-guidelines.rst
and make sure you comply with what is expected in the commit message.
