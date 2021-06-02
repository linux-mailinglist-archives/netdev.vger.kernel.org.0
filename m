Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFEC3987E4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhFBLUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhFBLUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:20:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F442C061574;
        Wed,  2 Jun 2021 04:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HDweTCl+XEUHn4S+CyKOejrxpiweHcZr8IDGuVHWUQs=; b=Tcy9hOUYXzaNYvb838lLrK5nCc
        5O8nyC5DFTersZ93EfzI5GQE21FOEITswYvUc1bzoXzAdmLrF9tATY/XDeKZrK6+Y7uDTo5SwI51V
        FR7b3yUH8ZgB9lTGbgNiLOmPV9WaVtGCr2o1NZ6zmpnEnirvy/vLeqagzG8OwvRtkfqctkQqmBwLF
        6eHNPe1uOWKY0CLOQJHqsjx2ew98SABPi+1IhMLEXUA+Fsr57UhENhx7uAjt2qKyo2SfVW15W8XR7
        BMcLuj4i65zASAENdaHGegVz1dnCwLR8NxGcvdydOTuvbYsXAOwarYwENq71hDSajiOaROsMPsWXk
        bTgtZoLg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1loOsx-00B1wM-Qt; Wed, 02 Jun 2021 11:18:13 +0000
Date:   Wed, 2 Jun 2021 12:18:07 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com>
Cc:     anmol.karan123@gmail.com, bjorn.andersson@linaro.org,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ebiggers@google.com, ebiggers@kernel.org, eric.dumazet@gmail.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        necip@google.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] WARNING in idr_get_next
Message-ID: <YLdo77SkmGLgPUBi@casper.infradead.org>
References: <000000000000c98d7205ae300144@google.com>
 <0000000000003e409f05c3c5f190@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003e409f05c3c5f190@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fixed qrtr: Convert qrtr_ports from IDR to XArray

On Wed, Jun 02, 2021 at 03:30:06AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 43016d02cf6e46edfc4696452251d34bba0c0435
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon May 3 11:51:15 2021 +0000

Your bisect went astray.
