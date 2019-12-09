Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E36117445
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLISdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:33:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLISdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:33:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C757E1543BD14;
        Mon,  9 Dec 2019 10:33:01 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:33:01 -0800 (PST)
Message-Id: <20191209.103301.2153422263511234336.davem@davemloft.net>
To:     ms@dev.tdt.de
Cc:     andrew.hendry@gmail.com, edumazet@google.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/x25: add new state X25_STATE_5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209072134.19746-1-ms@dev.tdt.de>
References: <20191209072134.19746-1-ms@dev.tdt.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:33:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>
Date: Mon,  9 Dec 2019 08:21:34 +0100

> This is needed, because if the flag X25_ACCPT_APPRV_FLAG is not set on a
> socket (manual call confirmation) and the channel is cleared by remote
> before the manual call confirmation was sent, this situation needs to
> be handled.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

Applied, thank you.
