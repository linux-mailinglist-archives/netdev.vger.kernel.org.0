Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15DEEE83A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfKDTVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:21:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50326 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDTVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:21:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26491151D4F8B;
        Mon,  4 Nov 2019 11:21:38 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:21:37 -0800 (PST)
Message-Id: <20191104.112137.1866856753932057.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH v2 net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104132914.GA16834@lunn.ch>
References: <20191103.192601.443764119268490765.davem@davemloft.net>
        <20191103.194409.422094551811274424.davem@davemloft.net>
        <20191104132914.GA16834@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:21:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 4 Nov 2019 14:29:14 +0100

> Please try v3 i posted last night, fixing what 0-day found.

Thanks, doing that right now.
