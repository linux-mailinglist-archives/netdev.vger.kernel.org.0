Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4272550254
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384001AbiFRDFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383943AbiFRDFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B96CAAA;
        Fri, 17 Jun 2022 20:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095D361F7C;
        Sat, 18 Jun 2022 03:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFD5C3411C;
        Sat, 18 Jun 2022 03:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655521506;
        bh=Z2xIoPA5yC3Q85E7Ikorw1miHTExfmuiClGfAhd9tKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UZYm4Jms+HU+qkczGsb6+A59uGJ/Sg0+VOKUINsCQC/lpjfD8XSHfw4DMW+bTZXWK
         d/jH0oJ7KTnqG108HiZvs2DN+JdMfjdSLrl0VZeHpM8E89FUhXX5xBHa2Igm6Noruz
         55Vr5SWZTkEPv4gXDDExjyxR5JMY6gINREjvEL3/Cja6aZkSjvVGMP6WZ112BTz/Bn
         SZZ+2VzGKZ8DTsvyW7NFRF+eKPbuKvXTatVc4agOsiDds7mZAU7s2/2C63aj4LHk4L
         y7AuKM0hTkMbOXIPNZ8b8asXCHwEOqsmD5grEpiY6TaAyYmtFKNhh9tcAHIVMhwL3y
         p1cjpao6kH4IA==
Date:   Fri, 17 Jun 2022 20:05:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/8] net: tcp: add skb drop reasons to tcp
 state change
Message-ID: <20220617200504.25d85ee4@kernel.org>
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 18:05:06 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In this series patches, skb drop reasons are add to code path of TCP
> state change, which we have not done before. It is hard to pass these
> reasons from the function to its caller, where skb is dropped. In order
> to do this, we have to make some functions return skb drop reasons, or
> pass the pointer of 'reason' to these function as an new function
> argument.

Does not cleanly apply to net-next, reportedly.
