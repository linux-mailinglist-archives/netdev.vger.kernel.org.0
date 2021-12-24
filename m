Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449FD47EAD2
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245488AbhLXDW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:22:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51940 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbhLXDW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:22:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E6A61F99
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 03:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA42C36AE8;
        Fri, 24 Dec 2021 03:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640316178;
        bh=MntWcdBzTckhWNozGjROF/2o2kKlse7l5m4m7QEdlMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KXygyhf2/wW4xUwret2gqidyioSSA/tWNdmCduCMeUKpz/MeK6jEmf7v6Y8yhxuTE
         nvQgUEg7aXqllcYHUXmWQkej09jBTFqJt0/dT5Co3eBJC9Xz3Tp3OH57DL9684UHts
         Dur7UJgoHSmPdi2Z56+dnNIG2+wKmly1u6VbhTPJMlgPQrTdE0oFdFGVi28EQmYkgO
         TI4OjiWv8jYh3flN0OUNcMSRVzFDCyZImAn1sIQgG4qW6Or74SGTpcxAW0sIdAv9kG
         qiwj1HBmG7rpx7whiH7K3CH02o0eAAKyFuhYWfx/aoOYk0sJDGH7cG5BJq7uIdGSta
         8CHNSjmGqhdKA==
Date:   Thu, 23 Dec 2021 19:22:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] udp: using datalen to cap ipv6 udp max gso
 segments
Message-ID: <20211223192256.1c91fe7a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223191922.4a5cabc4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211223222441.2975883-1-lixiaoyan@google.com>
        <20211223191922.4a5cabc4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 19:19:22 -0800 Jakub Kicinski wrote:
> On Thu, 23 Dec 2021 22:24:40 +0000 Coco Li wrote:
> > The max number of UDP gso segments is intended to cap to
> > UDP_MAX_SEGMENTS, this is checked in udp_send_skb().
> > 
> > skb->len contains network and transport header len here, we should use
> > only data len instead.
> > 
> > This is the ipv6 counterpart to the below referenced commit,
> > which missed the ipv6 change
> > 
> > Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")  
> 
> I'm gonna replace the Fixes tag with:
> 
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> 
> hope that's okay.

Or I'll fumble the git command and accidentally push as is... Whatever.
