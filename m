Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BBC63E9C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 02:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGJA3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 20:29:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48384 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGJA3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 20:29:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABB561455244B;
        Tue,  9 Jul 2019 17:29:40 -0700 (PDT)
Date:   Tue, 09 Jul 2019 17:29:36 -0700 (PDT)
Message-Id: <20190709.172936.1666884223446806217.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] Name NICs based on vmbus offer and enable
 async probe by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562712932-79936-1-git-send-email-haiyangz@microsoft.com>
References: <1562712932-79936-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 17:29:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The net-next tree, if you are reading netdev today, has been closed.
