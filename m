Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDADF46A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfJURjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:39:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfJURjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:39:08 -0400
Received: from localhost (unknown [4.14.35.89])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFEF01411EAC8;
        Mon, 21 Oct 2019 10:39:07 -0700 (PDT)
Date:   Mon, 21 Oct 2019 10:39:07 -0700 (PDT)
Message-Id: <20191021.103907.1835218922048587239.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: updated pedit TDC tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571492753-7771-1-git-send-email-mrv@mojatatu.com>
References: <1571492753-7771-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 10:39:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sat, 19 Oct 2019 09:45:53 -0400

> Added test cases for IP header operations:
> - set tos/precedence
> - add value to tos/precedence
> - clear tos/precedence
> - invert tos/precedence
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
