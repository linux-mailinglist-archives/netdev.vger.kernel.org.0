Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D256D734
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbfGRXVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:21:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbfGRXVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:21:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 069831528C68E;
        Thu, 18 Jul 2019 16:21:18 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:21:16 -0700 (PDT)
Message-Id: <20190718.162116.629841908556075924.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, o.rempel@pengutronix.de,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: ag71xx: fix return value check in ag71xx_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717115225.23047-1-weiyongjun1@huawei.com>
References: <20190717115225.23047-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:21:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit these two ag71xx patches, you use a different subsystem
prefix in the Subject lines, so you should make them consistent.

Using just "ag71xx: " is perfectly fine.

Thank you.
