Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A32115E4C
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfLGTwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:52:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:52:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F27615420D23;
        Sat,  7 Dec 2019 11:52:39 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:52:38 -0800 (PST)
Message-Id: <20191207.115238.784174182997766329.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, mostrows@earthlink.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pppoe: remove redundant BUG_ON() check in pppoe_pernet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205230450.8614-1-pakki001@umn.edu>
References: <20191205230450.8614-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 11:52:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Thu,  5 Dec 2019 17:04:49 -0600

> Passing NULL to pppoe_pernet causes a crash via BUG_ON.
> Dereferencing net in net_generici() also has the same effect. This patch
> removes the redundant BUG_ON check on the same parameter.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied.
