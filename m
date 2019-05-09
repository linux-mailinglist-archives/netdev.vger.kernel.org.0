Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02118E31
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfEIQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:32:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36634 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfEIQck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:32:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5586E14CFAC07;
        Thu,  9 May 2019 09:32:39 -0700 (PDT)
Date:   Thu, 09 May 2019 09:32:38 -0700 (PDT)
Message-Id: <20190509.093238.2091917195965818479.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        mlichvar@redhat.com, jbenc@redhat.com, mkubecek@suse.cz
Subject: Re: [PATCH net] macvlan: disable SIOCSHWTSTAMP in container
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509065408.19444-1-liuhangbin@gmail.com>
References: <20190509065408.19444-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:32:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu,  9 May 2019 14:54:08 +0800

> Miroslav pointed that with NET_ADMIN enabled in container, a normal user
> could be mapped to root and is able to change the real device's rx
> filter via ioctl on macvlan, which would affect the other ptp process on
> host. Fix it by disabling SIOCSHWTSTAMP in container.
> 
> Fixes: 254c0a2bfedb ("macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to real device")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable.
