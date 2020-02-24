Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6816B277
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBXVcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:32:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgBXVcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:32:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EB49121A82F8;
        Mon, 24 Feb 2020 13:32:07 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:32:06 -0800 (PST)
Message-Id: <20200224.133206.190541701903608398.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com, eli@mellanox.com
Subject: Re: [PATCH net-next v8 0/2] Bare UDP L3 Encapsulation Module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1582518033.git.martin.varghese@nokia.com>
References: <cover.1582518033.git.martin.varghese@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:32:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Mon, 24 Feb 2020 10:56:56 +0530

> There are various L3 encapsulation standards using UDP being discussed to
> leverage the UDP based load balancing capability of different networks.
> MPLSoUDP (__ https://tools.ietf.org/html/rfc7510) is one among them.
> 
> The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> a UDP tunnel.
 ...

Series applied, thanks.
