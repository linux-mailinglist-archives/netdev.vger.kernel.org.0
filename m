Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10EE887A7
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 04:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfHJC7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 22:59:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfHJC7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 22:59:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70A3A15404B3C;
        Fri,  9 Aug 2019 19:59:32 -0700 (PDT)
Date:   Fri, 09 Aug 2019 19:59:31 -0700 (PDT)
Message-Id: <20190809.195931.1197160865034205207.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: added tdc tests for matchall
 filter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565390800-26061-1-git-send-email-mrv@mojatatu.com>
References: <1565390800-26061-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 19:59:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Fri,  9 Aug 2019 18:46:40 -0400

> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
