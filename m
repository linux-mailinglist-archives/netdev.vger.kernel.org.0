Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C45A654
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfF1Vex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:34:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52182 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1Vew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:34:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1FE9613AECA1E;
        Fri, 28 Jun 2019 14:34:52 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:34:51 -0700 (PDT)
Message-Id: <20190628.143451.2154118272310072917.davem@davemloft.net>
To:     christian@brauner.io
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ipv4: enable route flushing in network
 namespaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624132923.16792-1-christian@brauner.io>
References: <20190624132923.16792-1-christian@brauner.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 14:34:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian@brauner.io>
Date: Mon, 24 Jun 2019 15:29:23 +0200

> Tools such as vpnc try to flush routes when run inside network
> namespaces by writing 1 into /proc/sys/net/ipv4/route/flush. This
> currently does not work because flush is not enabled in non-initial
> network namespaces.
> Since routes are per network namespace it is safe to enable
> /proc/sys/net/ipv4/route/flush in there.
> 
> Link: https://github.com/lxc/lxd/issues/4257
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Applied.
