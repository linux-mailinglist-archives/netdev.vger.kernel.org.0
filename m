Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4655199C99
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgCaRLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:11:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731291AbgCaRLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:11:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2D9115D0E53B;
        Tue, 31 Mar 2020 10:11:18 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:11:18 -0700 (PDT)
Message-Id: <20200331.101118.175673136963069915.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, borisp@mellanox.com,
        secdev@chelsio.com
Subject: Re: [PATCH net-next v2] cxgb4/chcr: nic-tls stats in ethtool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331161842.8165-1-rohitm@chelsio.com>
References: <20200331161842.8165-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Mar 2020 10:11:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Tue, 31 Mar 2020 21:48:42 +0530

> Included nic tls statistics in ethtool stats.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied.
