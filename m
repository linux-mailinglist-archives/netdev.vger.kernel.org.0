Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9CE325F1
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFCBPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:15:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCBPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:15:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 389FA133E98DB;
        Sun,  2 Jun 2019 18:15:52 -0700 (PDT)
Date:   Sun, 02 Jun 2019 18:15:51 -0700 (PDT)
Message-Id: <20190602.181551.1158487915589677288.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: replace several function pointers
 with direct calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
References: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 18:15:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 31 May 2019 19:52:24 +0200

> This series removes most function pointers from struct rtl8169_private
> and uses direct calls instead. This simplifies the code and avoids
> the penalty of indirect calls in times of retpoline.

Series applied, thanks.
