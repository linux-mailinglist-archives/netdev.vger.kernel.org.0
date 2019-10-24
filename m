Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5DBE3E8F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbfJXVzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:55:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52384 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfJXVzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:55:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E261B14B694E1;
        Thu, 24 Oct 2019 14:55:40 -0700 (PDT)
Date:   Thu, 24 Oct 2019 14:55:36 -0700 (PDT)
Message-Id: <20191024.145536.140176702728222831.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, johannes@sipsolutions.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@resnulli.us, sd@queasysnail.net, roopa@cumulusnetworks.com,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        stephen@networkplumber.org, sashal@kernel.org, hare@suse.de,
        varun@chelsio.com, ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Subject: Re: [PATCH net v5 00/10] net: fix nested device bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191021184710.12981-1-ap420073@gmail.com>
References: <20191021184710.12981-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 14:55:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 21 Oct 2019 18:47:10 +0000

> This patchset fixes several bugs that are related to nesting
> device infrastructure.
 ...

Series applied.

There were some inline functions in foo.c files which we don't so, we
let the compiler decide.  So I removed the inline keyword in these case
when applying this series.

Thanks.
