Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699E0493213
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344166AbiASA4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiASA4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:56:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAB9C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 589BC614E4
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 00:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DFFC340E0;
        Wed, 19 Jan 2022 00:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642553771;
        bh=zyUhHL/oIgCKcCE8X4DDyKvgIlk54swrsDs8DN642+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gc7CEzgWmOneZajj36o0WYWcSveCnEPxG/ge1a1P0/cbovIeaTsizBdqD19ozRT8R
         C+ldGgS/PsFDPTvkuVSAWfXvlAN4di1sT7yNyxfXNrwB1qylNrI1BWczzv4nCHKZ+S
         jfpO9bPJFZcPEzvQu0gX818ZDOJe70pg3N/kAUexF8+KM10kub+6bsrdJXuOGwAwIo
         hK3ioOWv0SUqB+cLQDp2n5HMUztMKhMxtA+HqtZ40NibLKdjdXU8jkb3x6DckbAhBM
         D99pXxjb1O4SY6HUVN0Vfrzpkv0Gpi3UF/z/nGS/03nUgN4ScH9Mti/r6i3kU3GFAU
         pSmPLZbWsMkyg==
Date:   Tue, 18 Jan 2022 16:56:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: Re: [net-next PATCH v2] octeontx2-pf: Change receive buffer size
 using ethtool
Message-ID: <20220118165610.138378bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1642520319-27553-1-git-send-email-sbhatta@marvell.com>
References: <1642520319-27553-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 21:08:39 +0530 Subbaraya Sundeep wrote:
> ethtool rx-buf-len is for setting receive buffer size,
> support setting it via ethtool -G parameter and getting
> it via ethtool -g parameter.

LGTM! net-next is currently closed due to the merge window:

http://vger.kernel.org/~davem/net-next.html

so please repost next week and we'll apply it.
