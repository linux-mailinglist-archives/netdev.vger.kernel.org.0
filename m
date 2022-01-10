Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D220488FEB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbiAJFxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238848AbiAJFxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 00:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76CC06173F;
        Sun,  9 Jan 2022 21:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F14E560CA5;
        Mon, 10 Jan 2022 05:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1785BC36AE9;
        Mon, 10 Jan 2022 05:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641793984;
        bh=fXJXNXzrmlPOyKKygtvqZLNE6jha6xQbUhNH22X9/5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BPGsITuJuQn6mNm4GVHjXTu27Xkpx2j0+xHZgPDV8WO2npWWmJ5gJHNZ1Wan8aC0H
         XDM8HC0sds9WiCSn+74Ay5Kj/MIqkr03bYrYRP0UCOe30hajRicjVGzGS5X39D0lTy
         HJOz5tH8i5ILeBYhx+TQKH1e14DSY1NynEj7g6p+Rhh/sbMKxLKOrRIMUXedAEGcel
         UIY0d3OMzHLlLCB9ua+KZTbjw17p5i4BNVx4qWf8rfNw/+XOX4waxBnQGi5/959sXR
         ulLPcdCaT/yICVAo/KJEO7+rDYdXK1UiY4ScNp1W7FtCkSiUEF3/+1s6etx1QRnXlu
         unZ2gjCLvKMeg==
Date:   Sun, 9 Jan 2022 21:53:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
Message-ID: <20220109215302.2d8367c5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CABBYNZKpYuW6+iZJomaykGLT6gF2NBjTxjw-27vBZRY89P3xgw@mail.gmail.com>
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
        <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
        <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CABBYNZJ3LRwt=CmnR4U1Kqk5Ggr8snN_2X_uTex+YUX9GJCkuw@mail.gmail.com>
        <20220109185654.69cbca57@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CABBYNZKpYuW6+iZJomaykGLT6gF2NBjTxjw-27vBZRY89P3xgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 9 Jan 2022 19:57:20 -0800 Luiz Augusto von Dentz wrote:
> On Sun, Jan 9, 2022 at 6:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Im planning to send a new pull request later today, that should
> > > address the warning and also takes cares of sort hash since that has
> > > been fixup in place.  
> >
> > But I already pulled..  
> 
> Nevermind then, shall I send the warning fix directly to net-next
> then?

Maybe send it in a week or so with other fixes which accumulate
up to that point?

> Or you actually pulled the head of bluetooth-next not tag?

I pulled the tag.
