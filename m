Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFBE169657
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 06:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgBWFrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 00:47:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52106 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWFrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 00:47:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45E1E141C8A68;
        Sat, 22 Feb 2020 21:47:10 -0800 (PST)
Date:   Sat, 22 Feb 2020 21:47:09 -0800 (PST)
Message-Id: <20200222.214709.1503060992928233323.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@paul-moore.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        gnault@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net] ipv4: ensure rcu_read_lock() in cipso_v4_error()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221112838.11324-1-mcroce@redhat.com>
References: <20200221112838.11324-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Feb 2020 21:47:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Fri, 21 Feb 2020 12:28:38 +0100

> Similarly to commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in
> ipv4_link_failure()"), __ip_options_compile() must be called under rcu
> protection.
> 
> Fixes: 3da1ed7ac398 ("net: avoid use IPCB in cipso_v4_error")
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied and queued up for -stable, thanks.
