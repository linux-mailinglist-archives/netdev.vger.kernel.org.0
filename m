Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA750E7A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfFXOfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:35:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFXOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:35:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3608B150420B3;
        Mon, 24 Jun 2019 07:35:18 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:35:17 -0700 (PDT)
Message-Id: <20190624.073517.1612706351643151777.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: remove the unnecessary msg->req check from
 tipc_nl_compat_bearer_set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a4f39065f0b1cb13da2159339c08d78cb61f88d9.1561363362.git.lucien.xin@gmail.com>
References: <a4f39065f0b1cb13da2159339c08d78cb61f88d9.1561363362.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:35:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 24 Jun 2019 16:02:42 +0800

> tipc_nl_compat_bearer_set() is only called by tipc_nl_compat_link_set()
> which already does the check for msg->req check, so remove it from
> tipc_nl_compat_bearer_set(), and do the same in tipc_nl_compat_media_set().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Is this really appropriate as a fix for 'net'?  Seems more like net-next material
to me.
