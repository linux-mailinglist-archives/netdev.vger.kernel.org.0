Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89333188F03
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCQUdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgCQUdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 16:33:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EEF120714;
        Tue, 17 Mar 2020 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584477202;
        bh=SBirQIgSTkDDRTJ9ebrw89489K3e9v1vfS6OKHS+JxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Egv8ylqGhMe8c3oxOHBRyizr/gMjVOVsHo9ffAQ5oHapF09sSnnjrnXeYQybZHQ/K
         uj0/UXQvBckchK7RRJfXmG/b98L2e1nmeBKuh/3rhkoPjJV8EyyZZ2N7uc5qS/57GX
         q5jcpcBCoiBOcip/aeeu70/epgRcpPSXZ3ebxzcw=
Date:   Tue, 17 Mar 2020 13:33:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Yang <jianyang.kernel@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next 0/5] selftests: expand txtimestamp with new
 features
Message-ID: <20200317133320.2df0d2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317192509.150725-1-jianyang.kernel@gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 12:25:04 -0700 Jian Yang wrote:
> From: Jian Yang <jianyang@google.com>
> 
> Current txtimestamp selftest issues requests with no delay, or fixed 50
> usec delay. Nsec granularity is useful to measure fine-grained latency.
> A configurable delay is useful to simulate the case with cold
> cachelines.
> 
> This patchset adds new flags and features to the txtimestamp selftest,
> including:
> - Printing in nsec (-N)
> - Polling interval (-b, -S)
> - Using epoll (-E, -e)
> - Printing statistics
> - Running individual tests in txtimestamp.sh

Is there any chance we could move/integrate the txtimestamp test into
net/?  It's the only test under networking/

I feel like I already asked about this, but can't find the email now.
