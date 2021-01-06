Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289C52EB6D5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbhAFAZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:25:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55012 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbhAFAZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:25:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4C5834CBCE1FD;
        Tue,  5 Jan 2021 16:24:32 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:24:30 -0800 (PST)
Message-Id: <20210105.162430.1685774840599177546.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: suggest L2 discards be counted towards
 rx_dropped
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201231033753.1568393-1-kuba@kernel.org>
References: <20201231033753.1568393-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:24:32 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 30 Dec 2020 19:37:53 -0800

> From the existing definitions it's unclear which stat to
> use to report filtering based on L2 dst addr in old
> broadcast-medium Ethernet.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied.
