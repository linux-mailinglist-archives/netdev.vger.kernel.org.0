Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9387C71C
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfGaPoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:44:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39384 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaPoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:44:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3D3B12B8A0F9;
        Wed, 31 Jul 2019 08:44:19 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:44:19 -0700 (PDT)
Message-Id: <20190731.084419.1246206004220408916.davem@davemloft.net>
To:     dingxiang@cmss.chinamobile.com
Cc:     christopher.lee@cspi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] myri10ge: remove unneeded variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564563226-13367-1-git-send-email-dingxiang@cmss.chinamobile.com>
References: <1564563226-13367-1-git-send-email-dingxiang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:44:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Date: Wed, 31 Jul 2019 16:53:46 +0800

> "error" is unneeded,just return 0
> 
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>

Applied to net-next.
