Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF7719826D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgC3Rdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:33:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgC3Rdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:33:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2601315C0FE9D;
        Mon, 30 Mar 2020 10:33:41 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:33:40 -0700 (PDT)
Message-Id: <20200330.103340.908942701513894338.davem@davemloft.net>
To:     ayush.sawal@chelsio.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Fixes issues during chcr driver
 registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330151853.32550-1-ayush.sawal@chelsio.com>
References: <20200330151853.32550-1-ayush.sawal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:33:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>
Date: Mon, 30 Mar 2020 20:48:51 +0530

> Patch 1: Avoid the accessing of wrong u_ctx pointer.
> Patch 2: Fixes a deadlock between rtnl_lock and uld_mutex.

Series applied, thanks.
