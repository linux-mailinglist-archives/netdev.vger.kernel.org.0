Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBD8AF77D
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfIKINX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:13:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKINX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:13:23 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15CD615565B7D;
        Wed, 11 Sep 2019 01:13:21 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:13:20 +0200 (CEST)
Message-Id: <20190911.101320.682967997452798874.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: fix memort leak in qrtr_tun_write_iter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911003748.26841-1-navid.emamdoost@gmail.com>
References: <20190911003748.26841-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:13:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Tue, 10 Sep 2019 19:37:45 -0500

> In qrtr_tun_write_iter the allocated kbuf should be release in case of
> error happening.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Shouldn't it also be freed in case of success too?
