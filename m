Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1FC18E32
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfEIQct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:32:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfEIQct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:32:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1D0B14CFAC07;
        Thu,  9 May 2019 09:32:48 -0700 (PDT)
Date:   Thu, 09 May 2019 09:32:48 -0700 (PDT)
Message-Id: <20190509.093248.252316658138048007.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        mlichvar@redhat.com, jbenc@redhat.com, mkubecek@suse.cz,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net] vlan: disable SIOCSHWTSTAMP in container
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509065507.23991-1-liuhangbin@gmail.com>
References: <20190509065507.23991-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:32:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu,  9 May 2019 14:55:07 +0800

> With NET_ADMIN enabled in container, a normal user could be mapped to
> root and is able to change the real device's rx filter via ioctl on
> vlan, which would affect the other ptp process on host. Fix it by
> disabling SIOCSHWTSTAMP in container.
> 
> Fixes: a6111d3c93d0 ("vlan: Pass SIOC[SG]HWTSTAMP ioctls to real device")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable.
