Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C956B2BC0
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjCIRMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjCIRMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1944AED687;
        Thu,  9 Mar 2023 09:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A8EBB8202B;
        Thu,  9 Mar 2023 17:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCCFC433EF;
        Thu,  9 Mar 2023 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678381778;
        bh=0Cz7KsUt/fCU6LY87KPK94qpE4MCaZAsPMVhUUTz8Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=scNDY+yGl43XfIEDX8ZUv1HrVuNRggLIov4ya6JlHd0oqqbfVj0FUpYgTIyInYrsd
         kM7ZfOy/JVQFAQiYnSAx6a5GQqaBm3x2sE0OH2KsgBNLNxOKcCdcq6sSlCk4cm8VSv
         SrIRqof5pU2nirXoTrCuVGeXkOyeK/fPWLxWeBQ6+pGdWpaD6s3di0/7ZlqZXAcrou
         Mcct2tvhxACtblEHG2ODNWJ0VTjZGFroeSZRXiqcb0xCx8HdmKCF8wvWZ8s3kyyUi5
         JnvnhesTN/nnD3u1PlrbHO4KIZcVLYVwoE+j5FVknmP3vPbmKMMG01CxDoMwYlbXn+
         VQc9BGV7rK+qQ==
Date:   Thu, 9 Mar 2023 18:09:27 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] connector/cn_proc: Allow non-root users access
Message-ID: <20230309170927.jzeksgqwstd6vunp@wittgenstein>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
 <20230309031953.2350213-5-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230309031953.2350213-5-anjali.k.kulkarni@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 07:19:52PM -0800, Anjali Kulkarni wrote:
> The patch allows non-root users to receive cn proc connector
> notifications, as anyone can normally get process start/exit status from
> /proc. The reason for not allowing non-root users to receive multicast
> messages is long gone, as described in this thread:
> https://linux-kernel.vger.kernel.narkive.com/CpJFcnra/multicast-netlink-for-non-root-process

Sorry that thread is kinda convoluted. Could you please provide a
summary in the commit message and explain why this isn't an issue
anymore?
