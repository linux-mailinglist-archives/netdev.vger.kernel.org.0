Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B11C169D21
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 05:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgBXEoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 23:44:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbgBXEoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 23:44:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44AD814EAC208;
        Sun, 23 Feb 2020 20:44:22 -0800 (PST)
Date:   Sun, 23 Feb 2020 20:44:21 -0800 (PST)
Message-Id: <20200223.204421.1631817429814318053.davem@davemloft.net>
To:     craig@zhatt.com
Cc:     netdev@vger.kernel.org
Subject: Re: Subject: [PATCH net-next] bonding: Fix hashing byte order
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAK0T-BKRWOLR8h7uaFV6pYfkYcG8qb0CrzLXSvcpNWafWcA_dg@mail.gmail.com>
References: <CAK0T-BKRWOLR8h7uaFV6pYfkYcG8qb0CrzLXSvcpNWafWcA_dg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 20:44:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Craig Robson <craig@zhatt.com>
Date: Sun, 23 Feb 2020 08:46:56 -0800

> Change to use host order bytes when hashing IP address.

It's a hash, it doesn't matter really.

Also your submission was missing a proper Signed-off-by: tag.
