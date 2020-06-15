Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010B21F9D7A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbgFOQbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgFOQbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 12:31:02 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23C682078A;
        Mon, 15 Jun 2020 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592238661;
        bh=dt6Smj2v6rFPNWxnYG+VQojJH4NZgvIIyNZ/NqsFy+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pmQGnaa0/VkgldMO4bmYVvGcjzl5kIabCgXXGNOI1QE0z5Cl/P3Gwxikh4vEBCJow
         rTke57RGgkD1OpiRHFExh/CJjndMPbWXvOXXmWlpqO5NtiEpcnn+NdKkimuZT5Iaus
         ONVgHSwi8wpLGXu5DsSM8ytoaMwyj9Jmly32KKQk=
Date:   Mon, 15 Jun 2020 09:30:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miao-chen Chou <mcchou@chromium.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 6/7] Bluetooth: Notify adv monitor removed event
Message-ID: <20200615093059.6c390dcf@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200612164243.v4.6.If1a82f71eb63f969de3d5a5da03c2908b58a721a@changeid>
References: <20200612164243.v4.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
        <20200612164243.v4.6.If1a82f71eb63f969de3d5a5da03c2908b58a721a@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 16:45:55 -0700 Miao-chen Chou wrote:
> This notifies management sockets on MGMT_EV_ADV_MONITOR_REMOVED event.
> 
> The following test was performed.
> - Start two btmgmt consoles, issue a btmgmt advmon-remove command on one
> console and observe a MGMT_EV_ADV_MONITOR_REMOVED event on the other.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>


net/bluetooth/mgmt.c:4047:54: warning: incorrect type in argument 3 (different base types)
net/bluetooth/mgmt.c:4047:54:    expected unsigned short [usertype] handle
net/bluetooth/mgmt.c:4047:54:    got restricted __le16 [usertype] monitor_handle
