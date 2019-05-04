Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8366B13734
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfEDEAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:00:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55634 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfEDEAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:00:10 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D73F514D79773;
        Fri,  3 May 2019 21:00:05 -0700 (PDT)
Date:   Sat, 04 May 2019 00:00:01 -0400 (EDT)
Message-Id: <20190504.000001.652024295667504645.davem@davemloft.net>
To:     linux@roeck-us.net
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, garsilva@embeddedor.com
Subject: Re: [PATCH] usbnet: ipheth: Remove unnecessary NULL pointer check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556670933-755-1-git-send-email-linux@roeck-us.net>
References: <1556670933-755-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:00:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue, 30 Apr 2019 17:35:33 -0700

> ipheth_carrier_set() is called from two locations. In
> ipheth_carrier_check_work(), its parameter 'dev' is set with
> container_of(work, ...) and can not be NULL. In ipheth_open(),
> dev is extracted from netdev_priv(net) and dereferenced before
> the call to ipheth_carrier_set(). The NULL pointer check of dev
> in ipheth_carrier_set() is therefore unnecessary and can be removed.
> 
> Cc: Gustavo A. R. Silva <garsilva@embeddedor.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied to net-next.
