Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0BD1442F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfEFEyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:54:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFEyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:54:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F4AF12DAF003;
        Sun,  5 May 2019 21:54:51 -0700 (PDT)
Date:   Sun, 05 May 2019 21:54:48 -0700 (PDT)
Message-Id: <20190505.215448.454193805749980489.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: move EEE LED config to
 rtl8168_config_eee_mac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f5590aac-fc8e-3ca1-f3e0-c31e83ae58db@gmail.com>
References: <f5590aac-fc8e-3ca1-f3e0-c31e83ae58db@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:54:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 4 May 2019 17:13:09 +0200

> Move adjusting the EEE LED frequency to rtl8168_config_eee_mac.
> Exclude RTL8411 (version 38) like in the existing code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
