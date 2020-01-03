Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD2612F228
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgACAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:23:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgACAXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:23:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3C891572092B;
        Thu,  2 Jan 2020 16:23:36 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:23:36 -0800 (PST)
Message-Id: <20200102.162336.1124963074467938993.davem@davemloft.net>
To:     ben@decadent.org.uk
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: Remove unnecessary dependencies on I2C
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191231165908.GA329936@decadent.org.uk>
References: <20191231165908.GA329936@decadent.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:23:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 31 Dec 2019 16:59:08 +0000

> Only the SFC4000 code, now moved to sfc-falcon, needed I2C.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Applied.
