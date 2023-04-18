Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15826E651D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjDRM5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjDRM5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:57:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BD6C148;
        Tue, 18 Apr 2023 05:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C0AE63482;
        Tue, 18 Apr 2023 12:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58713C4339B;
        Tue, 18 Apr 2023 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822639;
        bh=M5QQFj9XiQRzyv5YIpIgqJ2IsKZ9NFeAZIT7qv7wh98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gv6jhcfBwkEWGJySgpG/pZDMBJMaDM84yvNTKdhvHfQBDRiC5VsisqmSJYP+og9yT
         O8+5zcUr+GlByIGpg7PW568j0FUIy91ZisGVQRK37avECcynn/jJ4jYBJ5MNcZBUda
         qpaisy5chyFoEY1DZIvxPRr2L8P+zG2Ap1UbKa8M=
Date:   Tue, 18 Apr 2023 14:57:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, kuniyu@amazon.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5.10 1/5] udp: Call inet6_destroy_sock() in
 setsockopt(IPV6_ADDRFORM).
Message-ID: <2023041803-thing-phoney-39d0@gregkh>
References: <cover.1680589114.git.william.xuanziyang@huawei.com>
 <e553cbe5451685574d097486135b804ab595d344.1680589114.git.william.xuanziyang@huawei.com>
 <2023041820-storable-trimester-e98d@gregkh>
 <2023041845-resize-elude-7fb6@gregkh>
 <60508ed0-dfe0-5981-6358-f87c860ccc8c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60508ed0-dfe0-5981-6358-f87c860ccc8c@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 08:53:32PM +0800, Ziyang Xuan (William) wrote:
> > On Tue, Apr 18, 2023 at 12:21:21PM +0200, Greg KH wrote:
> >> On Tue, Apr 04, 2023 at 05:24:28PM +0800, Ziyang Xuan wrote:
> >>> From: Kuniyuki Iwashima <kuniyu@amazon.com>
> >>>
> >>> commit 21985f43376cee092702d6cb963ff97a9d2ede68 upstream.
> >>
> >> Why is this only relevant for 5.10.y?  What about 5.15.y?
> >>
> >> For obvious reasons, we can not take patches only for older branches as
> >> that would cause people to have regressions when moving to newer kernel
> >> releases.  So can you please fix this up by sending a 5.15.y series, and
> >> this 5.10.y series again, and we can queue them all up at the same time?
> > 
> > Also a 6.1.y series to be complete.
> > 
> 4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y and 6.1.y are all involved.
> Can I send series for them all together?

Yes please, as 5 different patch series.

thanks,

greg k-h
