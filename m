Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB94652D57
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLUHhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLUHhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:37:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB413B1C2;
        Tue, 20 Dec 2022 23:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E4586127D;
        Wed, 21 Dec 2022 07:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D487C433EF;
        Wed, 21 Dec 2022 07:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671608238;
        bh=3yfMgw+PQQ42Se7/IHoqWZt4LsTgn8jUBoQAaa2937o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vNb32GPpeB0LKGJop7iSiFWvICvnGNAs0Ttd7rCgxYP7nd1hIBkhex1xZd2x+mvkI
         Un6nbY0msoYjX/jOzl/kywALbyGXbduflx8l4u/QgXNz4ELq4gyFh5AkmfRnwezsow
         drP4K5xKgyeayv2I2FMjlKpmoNgMG21lQv7jwQUA=
Date:   Wed, 21 Dec 2022 08:37:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com, liuhangbin@gmail.com,
        linux-kernel@vger.kernel.org, joneslee@google.com
Subject: Re: kernel BUG in __skb_gso_segment
Message-ID: <Y6K3q6Bo3wwC57bK@kroah.com>
References: <82b18028-7246-9af9-c992-528a0e77f6ba@linaro.org>
 <CAF=yD-KEwVnH6PRyxbJZt4iGfKasadYwU_6_V+hHW2s+ZqFNcw@mail.gmail.com>
 <a13f83f3-737d-1bfe-c9ef-031a6cd4d131@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13f83f3-737d-1bfe-c9ef-031a6cd4d131@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 09:28:16AM +0200, Tudor Ambarus wrote:
> Hi,
> 
> I added Greg KH to the thread, maybe he can shed some light on whether
> new support can be marked as fixes and backported to stable. The rules
> on what kind of patches are accepted into the -stable tree don't mention
> new support:
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

As you say, we don't take new features into older kernels.  Unless they
fix a reported problem, if so, submit the git ids to us and we will be
glad to review them.

thanks,

greg k-h
