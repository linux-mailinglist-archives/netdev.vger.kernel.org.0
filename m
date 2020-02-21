Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3B168967
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgBUVhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:37:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgBUVhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 16:37:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 169961581622B;
        Fri, 21 Feb 2020 13:37:18 -0800 (PST)
Date:   Fri, 21 Feb 2020 13:37:15 -0800 (PST)
Message-Id: <20200221.133715.1137875747860387598.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/2] ptp: Add a ptp clock driver for IDT
 82P33 SMU.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582315431-16027-1-git-send-email-min.li.xe@renesas.com>
References: <1582315431-16027-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 13:37:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


When you post a new version of any patch, you must repost the entire patch
series, not just the patches which are changing.

Thank you.
