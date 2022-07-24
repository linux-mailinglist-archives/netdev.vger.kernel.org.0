Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5857F3AF
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 09:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbiGXH0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 03:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiGXH0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 03:26:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FDF183AD;
        Sun, 24 Jul 2022 00:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D336BB80D55;
        Sun, 24 Jul 2022 07:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4006C3411E;
        Sun, 24 Jul 2022 07:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658647561;
        bh=Emejayh0Y4QHcbVh21R49rZQWuW3RtQHlzxgRGGnYlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UpeBt++h5Jf5aldtILQikJ6NslggjmLlP7G6nVodzhaRZ3yYtcCfMrOSnCmsgnWV3
         +r/d2XJy08+7drQxUJJ1nKzaxX2d+EAHOVBPYKANhufeyXhlKhCt2j2///+BXFKCzC
         zmvt44hvqbRLHQvFeVrE9K9+eei7036EA8mDdUrE=
Date:   Sun, 24 Jul 2022 09:21:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dipanjan Das <mail.dipanjan.das@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sashal@kernel.org, edumazet@google.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Subject: Re: general protection fault in sock_def_error_report
Message-ID: <Ytzy9IjGXziLaVV0@kroah.com>
References: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 03:07:09PM -0700, Dipanjan Das wrote:
> Hi,
> 
> We would like to report the following bug which has been found by our
> modified version of syzkaller.

Do you have a fix for this issue?  Without that, it's a bit harder as:

> ======================================================
> description: general protection fault in sock_def_error_report
> affected file: net/core/sock.c
> kernel version: 5.4.206

You are using a very old kernel version, and we have loads of other
syzbot-reported issues to resolve that trigger on newer kernels.

thanks,

greg k-h
