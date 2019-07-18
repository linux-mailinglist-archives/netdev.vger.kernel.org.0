Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937206D464
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbfGRTIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:08:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391028AbfGRTIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:08:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 306741527DFBA;
        Thu, 18 Jul 2019 12:08:30 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:08:29 -0700 (PDT)
Message-Id: <20190718.120829.1693127632426510179.davem@davemloft.net>
To:     yanhaishuang@cmss.chinamobile.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Fix a possible memory leak on dst_cache
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563466028-2531-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1563466028-2531-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:08:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Date: Fri, 19 Jul 2019 00:07:08 +0800

> dst_cache should be destroyed when fail to add flow actions.
> 
> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

OVS folks, please review.
