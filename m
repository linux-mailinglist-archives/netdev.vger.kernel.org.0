Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C056627A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 06:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiGEEp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 00:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGEEp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 00:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A33511C0D;
        Mon,  4 Jul 2022 21:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F32618DC;
        Tue,  5 Jul 2022 04:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F32C341C7;
        Tue,  5 Jul 2022 04:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656996323;
        bh=4OKa312gSztYB28gDrHucUBNOZKSp1RZDpv9qj0Mfe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5mUMXy9KXKmwGkeJvkLgKzNF4aPIAaf4xqLh40ZsWsH40ynewmYN+nfmer9uYGve
         GxnSVuossYtnyibi/N9Vna6bV4xmz1ehdSy9CrNF27cxUWoA+a+XVOY4Hkhvw413LM
         DNVYZkBh5VYfTbJPLJyvj0QtF6DoNSFKmeiCXtBE=
Date:   Tue, 5 Jul 2022 06:45:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Soumya Negi <soumya.negi97@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot+9d567e08d3970bfd8271@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Test patch for KASAN: global-out-of-bounds Read in
 detach_capi_ctr
Message-ID: <YsPB4Ze6Jw1B9VrM@kroah.com>
References: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
 <20220704112619.GZ16517@kadam>
 <YsLU6XL1HBnQR79P@kroah.com>
 <20220705040430.GA18661@Negi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705040430.GA18661@Negi>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 09:04:30PM -0700, Soumya Negi wrote:
> Thanks for letting me know. Is there a way I can check whether an open
> syzbot bug already has a fix as in this case? Right now I am thinking
> of running the reproducer on linux-next as well before starting on a
> bug.

I have no context at all as to what you are referring to here, sorry.
