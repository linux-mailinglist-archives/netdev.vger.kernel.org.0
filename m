Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C963247642
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732343AbgHQTfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgHQP3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0514623B80;
        Mon, 17 Aug 2020 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678165;
        bh=ZR/3Xg4ei8Mp2hzeIeLrWX/F4kbxmqO6zPHu4ugSDJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R5VeWDKm1b0ZZn5KRGEmRUgmEZTIvlxHYP5nYj8NiJ+KHqb4H94KEeggJ19IYPcoL
         uSBTBizhmYJA0no1lqy9JrzTnyKhv/x7wsOCOaW6YnkupgWyQx9+ACz5JbOKgGsqwk
         1LvwZ6WpuyF+s/SecPztnl1Cg+qzZMDvyySA8ORY=
Date:   Mon, 17 Aug 2020 08:29:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Necip Fazil Yildiran <fazilyildiran@gmail.com>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dvyukov@google.com, elver@google.com, andreyknvl@google.com,
        glider@google.com, necip@google.com,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: qrtr: fix usage of idr in port assignment to
 socket
Message-ID: <20200817082923.60131b6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200817073900.3085391-1-fazilyildiran@gmail.com>
References: <20200817073900.3085391-1-fazilyildiran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 07:39:01 +0000 Necip Fazil Yildiran wrote:
> From: Necip Fazil Yildiran <necip@google.com>
> 
> Passing large uint32 sockaddr_qrtr.port numbers for port allocation
> triggers a warning within idr_alloc() since the port number is cast
> to int, and thus interpreted as a negative number. This leads to
> the rejection of such valid port numbers in qrtr_port_assign() as
> idr_alloc() fails.
> 
> To avoid the problem, switch to idr_alloc_u32() instead.
> 
> Fixes: bdabad3e36 ("net: Add Qualcomm IPC router")
> Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
> Signed-off-by: Necip Fazil Yildiran <necip@google.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>

Fixes tag: Fixes: bdabad3e36 ("net: Add Qualcomm IPC router")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
