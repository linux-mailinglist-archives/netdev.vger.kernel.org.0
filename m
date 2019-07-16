Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2039E6A072
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbfGPCFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:05:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47584 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfGPCFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 22:05:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D38914EA30DD;
        Mon, 15 Jul 2019 19:05:51 -0700 (PDT)
Date:   Mon, 15 Jul 2019 19:05:47 -0700 (PDT)
Message-Id: <20190715.190547.2251732138126894888.davem@davemloft.net>
To:     gerd.rausch@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] net/rds: RDMA fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <510cd678-67d6-bd53-1d8e-7a74c4efb14a@oracle.com>
References: <510cd678-67d6-bd53-1d8e-7a74c4efb14a@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jul 2019 19:05:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is closed, and why are you submitting bug fixes for net-next
when 'net' is the appropriate tree to target for that purpose?
