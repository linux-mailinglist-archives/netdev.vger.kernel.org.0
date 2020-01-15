Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C194513B7B8
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgAOCcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:32:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOCcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 21:32:02 -0500
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39FFA158087E3;
        Tue, 14 Jan 2020 18:31:48 -0800 (PST)
Date:   Tue, 14 Jan 2020 18:31:38 -0800 (PST)
Message-Id: <20200114.183138.2165891554137732877.davem@davemloft.net>
To:     niu_xilei@163.com
Cc:     tglx@linutronix.de, fw@strlen.de, peterz@infradead.org,
        steffen.klassert@secunet.com, bigeasy@linutronix.de,
        jonathan.lemon@gmail.com, pabeni@redhat.com,
        anshuman.khandual@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v4] pktgen: Allow configuration of IPv6 source address range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114031229.8569-1-niu_xilei@163.com>
References: <20200114031229.8569-1-niu_xilei@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 18:32:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niu Xilei <niu_xilei@163.com>
Date: Tue, 14 Jan 2020 11:12:29 +0800

> Pktgen can use only one IPv6 source address from output device or src6
> command setting. In pressure test we need create lots of sessions more
> than 65535. So add src6_min and src6_max command to set the range.
> 
> Signed-off-by: Niu Xilei <niu_xilei@163.com>

Applied to net-next.
