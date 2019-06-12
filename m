Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D866942E7F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFLSWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:22:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFLSWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:22:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9FD5152F3D46;
        Wed, 12 Jun 2019 11:22:49 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:22:49 -0700 (PDT)
Message-Id: <20190612.112249.1252227316058010690.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V3 net 0/7] Support for dynamic queue size changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611115811.2819-1-sameehj@amazon.com>
References: <20190611115811.2819-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:22:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Tue, 11 Jun 2019 14:58:04 +0300

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset introduces the following:
> * add new admin command for supporting different queue size for Tx/Rx
> * add support for Tx/Rx queues size modification through ethtool
> * allow queues allocation backoff when low on memory
> * update driver version
> 
> Difference from v2:
> * Dropped superfluous range checks which are already done in ethtool. [patch 5/7]
> * Dropped inline keyword from function. [patch 4/7]
> * Added a new patch which drops inline keyword all *.c files. [patch 6/7]
> 
> Difference from v1:
> * Changed ena_update_queue_sizes() signature to use u32 instead of int
>   type for the size arguments. [patch 5/7]

Series applied, thanks.
