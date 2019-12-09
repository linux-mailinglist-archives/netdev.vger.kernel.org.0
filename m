Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0691173CE
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfLISOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:14:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLISOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:14:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 376051543A16A;
        Mon,  9 Dec 2019 10:14:04 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:14:03 -0800 (PST)
Message-Id: <20191209.101403.781347318798443818.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 net] sctp: get netns from asoc and ep base
From:   David Miller <davem@davemloft.net>
In-Reply-To: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
References: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:14:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Dec 2019 13:45:18 +0800

> Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
> in asoc and ep base since they're created, and it will never change.
> It's a better way to get netns from asoc and ep base, comparing to
> calling sock_net().
> 
> This patch is to replace them.
> 
> v1->v2:
>   - no change.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

This looks like a cleanup rather than a bug fix, so net-next right?

Otherwise we need a Fixes: tag here and a better explanation in the
commit message about what problem this fixes.  Are the netns's wrong
sometimes without this conversion for example?

Thanks.
