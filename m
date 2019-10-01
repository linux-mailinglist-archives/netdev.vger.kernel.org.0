Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4FC43D8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfJAWas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:30:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfJAWas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:30:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78B2414770038;
        Tue,  1 Oct 2019 15:30:47 -0700 (PDT)
Date:   Tue, 01 Oct 2019 15:30:46 -0700 (PDT)
Message-Id: <20191001.153046.1642212253518211617.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing
 listening sk backlog
From:   David Miller <davem@davemloft.net>
In-Reply-To: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 15:30:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 30 Sep 2019 21:10:18 +0800

> This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
 ...

Marcel and Neil, please review.
