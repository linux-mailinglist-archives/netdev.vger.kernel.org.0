Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49009476F0
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFPVNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:13:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPVNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:13:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D2D2151C344E;
        Sun, 16 Jun 2019 14:13:45 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:13:45 -0700 (PDT)
Message-Id: <20190616.141345.1132798019172535158.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-tests: added path to ip command in tdc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560627703-1844-1-git-send-email-mrv@mojatatu.com>
References: <1560627703-1844-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:13:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sat, 15 Jun 2019 15:41:43 -0400

> This macro $IP will be used in upcoming tc tests, which require
> to create interfaces etc.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
