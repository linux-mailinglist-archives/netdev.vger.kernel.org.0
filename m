Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1E52D3742
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgLHX6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730241AbgLHX6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:58:12 -0500
X-Greylist: delayed 118774 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Dec 2020 15:57:32 PST
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E58BC0613CF;
        Tue,  8 Dec 2020 15:57:32 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 8E5264D248DBD;
        Tue,  8 Dec 2020 15:57:31 -0800 (PST)
Date:   Tue, 08 Dec 2020 15:57:31 -0800 (PST)
Message-Id: <20201208.155731.1558729549312660543.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net-next] net/af_iucv: use DECLARE_SOCKADDR to cast
 from sockaddr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201207125307.68725-1-jwi@linux.ibm.com>
References: <20201207125307.68725-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 15:57:31 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon,  7 Dec 2020 13:53:07 +0100

> This gets us compile-time size checking.
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied, thanks.
