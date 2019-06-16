Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D820476F8
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfFPV13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:27:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfFPV13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:27:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B0EA151C3C58;
        Sun, 16 Jun 2019 14:27:29 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:27:28 -0700 (PDT)
Message-Id: <20190616.142728.1547354274655222635.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, jbaron@akamai.com, willemb@google.com
Subject: Re: [PATCH net-next] selftests/net: fix warnings in TFO key
 rotation selftest
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190616171501.142551-1-willemdebruijn.kernel@gmail.com>
References: <20190616171501.142551-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:27:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun, 16 Jun 2019 13:15:01 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> One warning each on signedness, unused variable and return type.
> 
> Fixes: 10fbcdd12aa2 ("selftests/net: add TFO key rotation selftest")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied.
