Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D72FD2B0
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfKOCFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:05:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOCFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:05:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D06014B79F63;
        Thu, 14 Nov 2019 18:05:35 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:05:34 -0800 (PST)
Message-Id: <20191114.180534.798049573672936806.davem@davemloft.net>
To:     uli+renesas@fpond.eu
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com,
        geert@glider.be
Subject: Re: [PATCH v4] ravb: implement MTU change while device is up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114014949.31057-1-uli+renesas@fpond.eu>
References: <20191114014949.31057-1-uli+renesas@fpond.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:05:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ulrich Hecht <uli+renesas@fpond.eu>
Date: Thu, 14 Nov 2019 02:49:49 +0100

> Pre-allocates buffers sufficient for the maximum supported MTU (2026) in
> order to eliminate the possibility of resource exhaustion when changing the
> MTU while the device is up.
> 
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Applied.
