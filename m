Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B5AF778
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfIKIKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:10:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39894 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKIKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:10:54 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C70C15565B72;
        Wed, 11 Sep 2019 01:10:52 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:10:50 +0200 (CEST)
Message-Id: <20190911.101050.702538403183431556.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: i2400: fix memory leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910230210.19012-1-navid.emamdoost@gmail.com>
References: <20190910230210.19012-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:10:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Tue, 10 Sep 2019 18:01:40 -0500

> In i2400m_op_rfkill_sw_toggle cmd buffer should be released along with
> skb response.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied.

Good thing nobody uses wimax.
