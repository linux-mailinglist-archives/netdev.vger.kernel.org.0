Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B751D1CBB29
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgEHXRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 19:17:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9C562184D;
        Fri,  8 May 2020 23:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588979858;
        bh=HdxMD6V3GovGFdAWvIpqPfwDPjmn/95Q4cBC+m8zd+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FBcm+yB+xlOqGW9vk4JDw/fF5yLyAzv8kq1ucJPN/bNlOkFfwbTnaDzdEfE2TZ2Rv
         L1Y81gTtgmR+WGyZgWnz5fEOLqM6EqMQNca23yOjAdtja74XtLLqYQsTKY8J1qFQTC
         HqBBfQm8xbmKy7jtYrFm37z5u3SqNSq9qWEnOteE=
Date:   Fri, 8 May 2020 16:17:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kelly Littlepage <kelly@klittlepage.com>
Cc:     davem@davemloft.net, edumazet@google.com, iris@onechronos.com,
        kelly@onechronos.com, kuznet@ms2.inr.ac.ru, maloney@google.com,
        netdev@vger.kernel.org, soheil@google.com,
        willemdebruijn.kernel@gmail.com, yoshfuji@linux-ipv6.org,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4] net: tcp: fix rx timestamp behavior for tcp_recvmsg
Message-ID: <20200508161735.5ca945c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MN2PR19MB36463B624F9DF2C29771E147B6A20@MN2PR19MB3646.namprd19.prod.outlook.com>
References: <20200508112920.141e722f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MN2PR19MB36463B624F9DF2C29771E147B6A20@MN2PR19MB3646.namprd19.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 19:58:46 +0000 Kelly Littlepage wrote:
> From: Kelly Littlepage <kelly@onechronos.com>
> 
> The stated intent of the original commit is to is to "return the timestamp
> corresponding to the highest sequence number data returned." The current
> implementation returns the timestamp for the last byte of the last fully
> read skb, which is not necessarily the last byte in the recv buffer. This
> patch converts behavior to the original definition, and to the behavior of
> the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
> SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
> behavior.

Applied, thank you!
