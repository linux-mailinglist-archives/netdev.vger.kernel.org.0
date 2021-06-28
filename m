Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB173B69C6
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbhF1Ukx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:40:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48432 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbhF1Ukv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 16:40:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 899F84F41AE3E;
        Mon, 28 Jun 2021 13:38:24 -0700 (PDT)
Date:   Mon, 28 Jun 2021 13:38:17 -0700 (PDT)
Message-Id: <20210628.133817.1312716382882999150.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, marcelo.leitner@gmail.com,
        linux-sctp@vger.kernel.org, david.laight@aculab.com
Subject: Re: [PATCHv2 net-next 0/2] sctp: make the PLPMTUD probe more
 effective and efficient
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1624675179.git.lucien.xin@gmail.com>
References: <cover.1624675179.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Jun 2021 13:38:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I applied v1 of this so I'll need relative fixups.

Thank you.
