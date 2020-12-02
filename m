Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034002CB209
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgLBBF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgLBBF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:05:27 -0500
Date:   Tue, 1 Dec 2020 17:04:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606871086;
        bh=xOhi+r6v9YMsbQQnXoEsnlyPEeLf+FNNf3KINlZMOv8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=akD4POLJ5uNHOYOYg4aCtwDp7V719CQqY7krlAX1rQX9pKACZKhmNlfBGxOh1j8e+
         Pdefk+tJPXYc5iPvxDDfLWmDVmdXxNaOhFTxj+w7GYNGkF/QvYcKE6KsCxeyKge1xv
         guPsb1J12wSreL53y3vSMM5oaCMmS3AgE3/e9ac0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 0/6] s390/ctcm: updates 2020-11-30
Message-ID: <20201201170445.5e67042a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 11:09:44 +0100 Julian Wiedmann wrote:
> Some rare ctcm updates by Sebastian, who cleans up all places where
> in_interrupt() was used to determine the correct GFP_* mask for
> allocations.
> In the first three patches we can get rid of those allocations entirely,
> as they just end up being copied into the skb.

Applied, thanks!
