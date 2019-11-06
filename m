Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C13F0BC5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbfKFBuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:50:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFBub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:50:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4281D150FC2F9;
        Tue,  5 Nov 2019 17:50:31 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:50:30 -0800 (PST)
Message-Id: <20191105.175030.61785967151011769.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: added tests with cookie for
 mpls TC action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572733551-24772-1-git-send-email-mrv@mojatatu.com>
References: <1572733551-24772-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:50:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sat,  2 Nov 2019 18:25:51 -0400

> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
