Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF26121FBB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfLQA2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:28:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQA2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:28:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7A811557484D;
        Mon, 16 Dec 2019 16:28:29 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:28:29 -0800 (PST)
Message-Id: <20191216.162829.138398136452355108.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fore200e: Fix incorrect checks of NULL pointer
 dereference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191215161451.24221-1-pakki001@umn.edu>
References: <20191215161451.24221-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:28:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Sun, 15 Dec 2019 10:14:51 -0600

> In fore200e_send and fore200e_close, the pointers from the arguments
> are dereferenced in the variable declaration block and then checked
> for NULL. The patch fixes these issues by avoiding NULL pointer
> dereferences.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied to net-next.
