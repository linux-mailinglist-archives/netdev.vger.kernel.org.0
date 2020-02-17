Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10D8160849
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQCoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:44:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgBQCoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:44:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA20B153C695C;
        Sun, 16 Feb 2020 18:44:43 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:44:43 -0800 (PST)
Message-Id: <20200216.184443.782357344949548902.davem@davemloft.net>
To:     danielwa@cisco.com
Cc:     zbr@ioremap.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212192901.6402-1-danielwa@cisco.com>
References: <20200212192901.6402-1-danielwa@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:44:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is a netlink based facility, therefore please you should add filtering
capabilities to the netlink configuration and communications path.

Module parameters are quite verboten.
