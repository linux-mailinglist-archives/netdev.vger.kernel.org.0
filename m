Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD974086
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbfGXVAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:00:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXVAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:00:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF7D0153E8968;
        Wed, 24 Jul 2019 14:00:11 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:00:11 -0700 (PDT)
Message-Id: <20190724.140011.1839679169257474219.davem@davemloft.net>
To:     yanhaishuang@cmss.chinamobile.com
Cc:     kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, u9012063@gmail.com
Subject: Re: [PATCH] ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563969642-11843-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1563969642-11843-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 14:00:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Date: Wed, 24 Jul 2019 20:00:42 +0800

> Since ip6_tnl_parse_tlv_enc_lim() can call pskb_may_pull()
> which may change skb->data, so we need to re-load ipv6h at
> the right place.
> 
> Fixes: 898b29798e36 ("ip6_gre: Refactor ip6gre xmit codes")
> Cc: William Tu <u9012063@gmail.com>
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Applied and queued up for -stable, thanks.
