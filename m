Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F1714432
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfEFE6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:58:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFE6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:58:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 635AF12EB0322;
        Sun,  5 May 2019 21:58:49 -0700 (PDT)
Date:   Sun, 05 May 2019 21:58:48 -0700 (PDT)
Message-Id: <20190505.215848.2007454471265920688.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: replace some magic with more
 speaking functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
References: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:58:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 5 May 2019 12:32:29 +0200

> Based on info from Realtek replace some magic with speaking functions
> even though the exact meaning of certain values isn't known.

Series applied, thanks.
