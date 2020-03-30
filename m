Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820A5197396
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgC3Exb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:53:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33134 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3Exb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:53:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75DFC15C548CF;
        Sun, 29 Mar 2020 21:53:30 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:53:29 -0700 (PDT)
Message-Id: <20200329.215329.483072419919619088.davem@davemloft.net>
To:     cambda@linux.alibaba.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, koct9i@gmail.com,
        dust.li@linux.alibaba.com, tonylu@linux.alibaba.com
Subject: Re: [PATCH net-next] net: Fix typo of SKB_SGO_CB_OFFSET
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326073314.55633-1-cambda@linux.alibaba.com>
References: <20200326073314.55633-1-cambda@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:53:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>
Date: Thu, 26 Mar 2020 15:33:14 +0800

> The SKB_SGO_CB_OFFSET should be SKB_GSO_CB_OFFSET which means the
> offset of the GSO in skb cb. This patch fixes the typo.
> 
> Fixes: 9207f9d45b0a ("net: preserve IP control block during GSO segmentation")
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Applied.
