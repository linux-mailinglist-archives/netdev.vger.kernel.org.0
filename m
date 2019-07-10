Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB964EB8
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfGJWcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:32:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbfGJWcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 18:32:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD46D14B5B89F;
        Wed, 10 Jul 2019 15:32:10 -0700 (PDT)
Date:   Wed, 10 Jul 2019 15:32:10 -0700 (PDT)
Message-Id: <20190710.153210.1430261429297429712.davem@davemloft.net>
To:     kris.van.hees@oracle.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org,
        clm@fb.com
Subject: Re: [PATCH V2 0/1] tools/dtrace: initial implementation of DTrace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jul 2019 15:32:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kris Van Hees <kris.van.hees@oracle.com>
Date: Wed, 10 Jul 2019 08:37:50 -0700 (PDT)

> This is version 2 of the patch, incorporating feedback from Peter
> Zijlstra and Arnaldo Carvalho de Melo.

No way, NACK.
