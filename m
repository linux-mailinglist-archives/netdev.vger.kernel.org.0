Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA50430CA
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbfFLUGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:06:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbfFLUGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:06:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65E9E1530497D;
        Wed, 12 Jun 2019 13:06:17 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:06:15 -0700 (PDT)
Message-Id: <20190612.130615.331364758503152913.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2 net-next] tcp: add optional per socket transmit delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612185725.176576-1-edumazet@google.com>
References: <20190612185725.176576-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 13:06:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 12 Jun 2019 11:57:25 -0700

> This patchs adds TCP_TX_DELAY socket option, to set a delay in
> usec units.
 ...

Ok, build testing again :-)
