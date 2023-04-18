Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DDD6E5E9D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjDRKXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjDRKXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3400A5CC;
        Tue, 18 Apr 2023 03:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B23D628D3;
        Tue, 18 Apr 2023 10:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D843C433EF;
        Tue, 18 Apr 2023 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681813317;
        bh=VK01NxppYEd6O/TlptkpQu2u6bkvFtPkIIp0HezDTYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a19n1QnbI3K2nKTyqND+475xDYcgMrA/KZovcik1asRuqVEPldmLUbRiQJX3YASbj
         OcXxg2Sl1wpUO/47crBUdm9K9TAsIaYq91TigeM3FT2U0rWDWEKTVVSdQxLpuD87Zb
         z5b/yOsPRa8QD7wlp57HHl1ksRJkCY50NCJGg+Xw=
Date:   Tue, 18 Apr 2023 12:21:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, kuniyu@amazon.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5.10 1/5] udp: Call inet6_destroy_sock() in
 setsockopt(IPV6_ADDRFORM).
Message-ID: <2023041845-resize-elude-7fb6@gregkh>
References: <cover.1680589114.git.william.xuanziyang@huawei.com>
 <e553cbe5451685574d097486135b804ab595d344.1680589114.git.william.xuanziyang@huawei.com>
 <2023041820-storable-trimester-e98d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023041820-storable-trimester-e98d@gregkh>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 12:21:21PM +0200, Greg KH wrote:
> On Tue, Apr 04, 2023 at 05:24:28PM +0800, Ziyang Xuan wrote:
> > From: Kuniyuki Iwashima <kuniyu@amazon.com>
> > 
> > commit 21985f43376cee092702d6cb963ff97a9d2ede68 upstream.
> 
> Why is this only relevant for 5.10.y?  What about 5.15.y?
> 
> For obvious reasons, we can not take patches only for older branches as
> that would cause people to have regressions when moving to newer kernel
> releases.  So can you please fix this up by sending a 5.15.y series, and
> this 5.10.y series again, and we can queue them all up at the same time?

Also a 6.1.y series to be complete.

thanks,

greg k-h
