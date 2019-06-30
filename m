Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB07B5B24C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 01:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfF3XFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 19:05:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfF3XFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 19:05:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4FBB14CC1554;
        Sun, 30 Jun 2019 16:05:10 -0700 (PDT)
Date:   Sun, 30 Jun 2019 16:05:10 -0700 (PDT)
Message-Id: <20190630.160510.1813092165599015075.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/15][pull request] Intel Wired LAN Driver Updates
 2019-06-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 30 Jun 2019 16:05:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 28 Jun 2019 15:49:17 -0700

> This series contains a smorgasbord of updates to many of the Intel
> drivers.
 ...

Pulled, thanks Jeff.

Please respond to Joe Perches's feedback on the debug macros.

Thanks.
