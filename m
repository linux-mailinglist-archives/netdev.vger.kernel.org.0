Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9CBE5857
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 05:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfJZD3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 23:29:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfJZD3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 23:29:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 665B514B7CD0E;
        Fri, 25 Oct 2019 20:29:34 -0700 (PDT)
Date:   Fri, 25 Oct 2019 20:29:33 -0700 (PDT)
Message-Id: <20191025.202933.2181766390562935818.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: align fix_features callback with
 vendor driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a6e8ef26-8748-6876-6bc4-57570096753f@gmail.com>
References: <a6e8ef26-8748-6876-6bc4-57570096753f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 20:29:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 23 Oct 2019 21:09:34 +0200

> This patch aligns the fix_features callback with the vendor driver and
> also disables IPv6 HW checksumming and TSO if jumbo packets are used
> on RTL8101/RTL8168/RTL8125.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
