Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA97680F9
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfGNTPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:15:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfGNTPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:15:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E3B214E7AC3A;
        Sun, 14 Jul 2019 12:15:44 -0700 (PDT)
Date:   Sun, 14 Jul 2019 12:15:43 -0700 (PDT)
Message-Id: <20190714.121543.1994938148048727587.davem@davemloft.net>
To:     yanhaishuang@cmss.chinamobile.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sit: use dst_cache in ipip6_tunnel_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563111082-10721-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1563111082-10721-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 14 Jul 2019 12:15:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Date: Sun, 14 Jul 2019 21:31:22 +0800

> Same as other ip tunnel, use dst_cache in xmit action to avoid
> unnecessary fib lookups.
> 
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Looks good, applied, thanks.
