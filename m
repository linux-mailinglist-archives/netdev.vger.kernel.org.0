Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA110454B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKTUkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:40:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59824 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKTUkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:40:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAC8614C24B32;
        Wed, 20 Nov 2019 12:40:24 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:40:24 -0800 (PST)
Message-Id: <20191120.124024.1945106179289526336.davem@davemloft.net>
To:     tbogendoerfer@suse.de
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipconfig: Wait for deferred device probes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120160236.4459-1-tbogendoerfer@suse.de>
References: <20191120160236.4459-1-tbogendoerfer@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:40:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date: Wed, 20 Nov 2019 17:02:36 +0100

> If network device drives are using deferred probing, it was possible
> that waiting for devices to show up in ipconfig was already over,
> when the device eventually showed up. By calling wait_for_device_probe()
> we now make sure deferred probing is done before checking for available
> devices.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
 ...
> +		/* make sure deferred device probes are finished */
> +		wait_for_device_probe();
> +

So much nicer, right? :-)

Applied.
