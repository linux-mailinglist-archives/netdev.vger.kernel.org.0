Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B060B5A8B80
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiIACc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiIACc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:32:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B4F10B977;
        Wed, 31 Aug 2022 19:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61B0FB823D7;
        Thu,  1 Sep 2022 02:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B80C433D6;
        Thu,  1 Sep 2022 02:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661999545;
        bh=Wo+cd7YaxoFEzv0hwwL0+sQCFGZpFUxzmmXrZaQIp8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LIeBodWdGoc9jrikwuCSxAZ1dIfIMByrDe0vpaoAjTuyQx4K0cK1uSQElTCWCJ6oW
         K2deUIeqhvFYIKKgBQWSxurDakPV3akQ/x9Yh4R2LHe89KBVOuOJ31OMy9WnZ4ADlM
         0/69/9IidQzrjqkoV8XIJ5lR3Wz5tb3Xefag8xqDXu59vZ3UcJMUtlRjvCiAHwmR7o
         NBKPg1bM9gNZ0hE0ng83flAsKBr6MvBJRaOevVNq1vZPx33dvGrGj3HLMNBydnt0RW
         w8+xCqBEoqeXQK87pK6hw+bzyJDc9TKp0VyMeWRpSf4SdKnsOvhbXGlgj/97Nf/M6G
         rJnZw4XPXNjnA==
Date:   Wed, 31 Aug 2022 19:32:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li zeming <zeming@nfschina.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: Use SPDX-license-identifier and remove the
 License description
Message-ID: <20220831193223.153911e4@kernel.org>
In-Reply-To: <20220830015054.3366-1-zeming@nfschina.com>
References: <20220830015054.3366-1-zeming@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 09:50:54 +0800 Li zeming wrote:
> Add the SPDX-license-identifier license agreement to more clearly
> express the content of the license representative.

> - *  This source is covered by the GNU GPL, the same as all kernel sources.

Is the kernel code covered by GPL-2-or-later by default or GPL-2?
IIRC Linus was not a fan of GPL-3, and my reading of the first few
paragraphs of license-rules.rst is that default is indeed just 2.0.

Could you find a reference to some document or discussion which would
support that "the same as all kernel sources" means 2-or-later, and add
it to the patch description?
