Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2177A12878B
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLUFby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:31:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:31:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBCBE153D58BE;
        Fri, 20 Dec 2019 21:31:53 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:31:53 -0800 (PST)
Message-Id: <20191220.213153.1257291319387433154.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: unregister ib devices in reboot_event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219115113.49414-1-kgraul@linux.ibm.com>
References: <20191219115113.49414-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:31:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Thu, 19 Dec 2019 12:51:13 +0100

> In the reboot_event handler, unregister the ib devices and enable
> the IB layer to release the devices before the reboot.
> 
> Fixes: a33a803cfe64 ("net/smc: guarantee removal of link groups in reboot")
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>

Applied.
