Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF560ECA8F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfKAVx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:53:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46668 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAVxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 17:53:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6919B151AD4CB;
        Fri,  1 Nov 2019 14:53:55 -0700 (PDT)
Date:   Fri, 01 Nov 2019 14:53:54 -0700 (PDT)
Message-Id: <20191101.145354.517003483767933706.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: added tests with cookie for
 conntrack TC action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572635140-23099-1-git-send-email-mrv@mojatatu.com>
References: <1572635140-23099-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 14:53:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Fri,  1 Nov 2019 15:05:40 -0400

> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied, thanks.
