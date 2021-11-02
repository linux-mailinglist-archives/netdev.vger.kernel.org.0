Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C044435CB
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhKBSmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235570AbhKBSmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 14:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 375A161050;
        Tue,  2 Nov 2021 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635878370;
        bh=YEObLt7jY0LqfQBFqsvRjLzfumI/etAH2kD07ysL+rc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aMLQRCDhNEiGarPy5vWOiDWPm/d1oWIkif+FfgFCvjD5n1jTpwdi0RMZtF3s8kIfw
         Zf6IxDNMMxM5PwyOfT+Alo5n/Z7/Y35BP0enIUViNejG6gdPnHhCXaGZu5XgIljpOF
         ou+V1QkT1tLVWGfZUP8tNPLI/FkNwXiQ0SYPYRE6JRupRw4rflH+naee+I44SJT1nF
         qCfiJD5xeKcPLqjGm+e7Qln+t8WM+BbgVEena3olhuUJGMHtJ1e5eLj6j+lOdEnqL+
         9MDpiJf2inzsUpIQX515JiqIuwNsuuwAWDBjSPpgwmFsSsTmOtMdFX5TTDi1rs/eRr
         0ZvkcfcpWMjHg==
Date:   Tue, 2 Nov 2021 11:39:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20211102113926.005879ff@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211029182008.382113-1-cpp.code.lv@gmail.com>
References: <20211029182008.382113-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Oct 2021 11:20:08 -0700 Toms Atteka wrote:
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
> 
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>

Hi! This patch didn't get reviewed in time for the v5.16 merge window,
please continue the work but you'll have to repost in two weeks after
v5.16-rc1 has been cut. If you repost before that point please use RFC
designation.
