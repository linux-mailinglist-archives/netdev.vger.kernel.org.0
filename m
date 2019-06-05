Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A303687A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFEX6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:58:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEX6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:58:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAFCB10081D58;
        Wed,  5 Jun 2019 16:58:11 -0700 (PDT)
Date:   Wed, 05 Jun 2019 16:58:11 -0700 (PDT)
Message-Id: <20190605.165811.1912503294566196521.davem@davemloft.net>
To:     info@metux.net
Cc:     linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: drop unneeded likely() call around IS_ERR()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559768945-19902-1-git-send-email-info@metux.net>
References: <1559768945-19902-1-git-send-email-info@metux.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 16:58:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Date: Wed,  5 Jun 2019 23:09:05 +0200

> From: Enrico Weigelt <info@metux.net>
> 
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Applied.
