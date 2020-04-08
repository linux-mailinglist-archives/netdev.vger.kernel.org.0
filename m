Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45F51A19A5
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgDHBjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:39:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44404 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgDHBjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:39:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30FFC1210A3E3;
        Tue,  7 Apr 2020 18:39:06 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:39:05 -0700 (PDT)
Message-Id: <20200407.183905.443388229440218710.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, lucasb@mojatatu.com
Subject: Re: [PATCH net 1/1] tc-testing: remove duplicate code in tdc.py
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1586279605-6689-1-git-send-email-mrv@mojatatu.com>
References: <1586279605-6689-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:39:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Tue,  7 Apr 2020 13:13:25 -0400

> In set_operation_mode() function remove duplicated check for args.list
> parameter, which is already done one line before.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
