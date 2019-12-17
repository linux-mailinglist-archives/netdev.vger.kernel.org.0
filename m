Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78407121FBD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfLQA3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:29:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQA3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:29:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37976155B29AD;
        Mon, 16 Dec 2019 16:29:35 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:29:34 -0800 (PST)
Message-Id: <20191216.162934.587439955378293016.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, gregkh@linuxfoundation.org, allison@lohutok.net,
        rfontana@redhat.com, geert+renesas@glider.be, tglx@linutronix.de,
        yang.wei9@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: caif: replace BUG_ON with recovery code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191215175132.30139-1-pakki001@umn.edu>
References: <20191215175132.30139-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:29:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Sun, 15 Dec 2019 11:51:30 -0600

> In caif_xmit, there is a crash if the ptr dev is NULL. However, by
> returning the error to the callers, the error can be handled. The
> patch fixes this issue.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied to net-next.
