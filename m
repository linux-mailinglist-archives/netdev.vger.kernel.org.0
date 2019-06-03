Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF5333B7C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFCWi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:38:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfFCWi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:38:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5003D1008B046;
        Mon,  3 Jun 2019 15:38:57 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:38:56 -0700 (PDT)
Message-Id: <20190603.153856.2027863735009165417.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8169: make firmware handling code ready
 to be factored out
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
References: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:38:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 3 Jun 2019 21:22:46 +0200

> This series contains the final steps to make firmware handling code
> ready to be factored out into a separate source code file.

Series applied, thanks.
