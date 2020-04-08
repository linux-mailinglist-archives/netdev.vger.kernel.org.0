Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CEA1A196D
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDHBJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:09:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDHBJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:09:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0E531210A3E3;
        Tue,  7 Apr 2020 18:09:40 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:09:40 -0700 (PDT)
Message-Id: <20200407.180940.27788002290100948.davem@davemloft.net>
To:     l.rubusch@gmail.com
Cc:     kuba@kernel.org, rdunlap@infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: sock.h: fix skb_steal_sock() kernel-doc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407225526.16085-1-l.rubusch@gmail.com>
References: <20200407225526.16085-1-l.rubusch@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:09:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Tue,  7 Apr 2020 22:55:25 +0000

> Fix warnings related to kernel-doc notation, and wording in
> function description.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Applied, thanks.
