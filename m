Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3472CF0C06
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbfKFC3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:29:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFC3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:29:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AFB8E1510455C;
        Tue,  5 Nov 2019 18:29:02 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:29:02 -0800 (PST)
Message-Id: <20191105.182902.2184407275523396678.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add pci reset handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572934755-21576-1-git-send-email-vishal@chelsio.com>
References: <1572934755-21576-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:29:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Tue,  5 Nov 2019 11:49:15 +0530

> This patch implements reset_prepare and reset_done, which are used
> for handling FLR.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied.
