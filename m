Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB3170CCE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBZXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:52:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgBZXwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 18:52:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64C9C15AD9CDB;
        Wed, 26 Feb 2020 15:52:54 -0800 (PST)
Date:   Wed, 26 Feb 2020 15:52:50 -0800 (PST)
Message-Id: <20200226.155250.1001115281676739073.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        kernel-team@fb.com, kuba@kernel.org
Subject: Re: [PATCH] bnxt_en: add newline to netdev_*() format strings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
References: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 15:52:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Mon, 24 Feb 2020 15:29:09 -0800

> Add missing newlines to netdev_* format strings so the lines
> aren't buffered by the printk subsystem.
> 
> Nitpicked-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied, thank you.
