Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE551379A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfEDFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:40:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:40:19 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 821A614DA6494;
        Fri,  3 May 2019 22:40:14 -0700 (PDT)
Date:   Sat, 04 May 2019 01:40:10 -0400 (EDT)
Message-Id: <20190504.014010.1890791222224399323.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     nikolay@cumulusnetworks.com, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH net-next] ipmr: Do not define MAXVIFS twice
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502222326.2298-1-dsahern@kernel.org>
References: <20190502222326.2298-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 22:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  2 May 2019 15:23:26 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> b70432f7319eb refactored mroute code to make it common between ipv4
> and ipv6. In the process, MAXVIFS got defined a second time: the
> first is in the uapi file linux/mroute.h. A second one was created
> presumably for IPv6 but it is not needed. Remove it and have
> mroute_base.h include the uapi file directly since it is shared.
> 
> include/linux/mroute.h can not be included in mroute_base.h because
> it contains a reference to mr_mfc which is defined in mroute_base.h.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
