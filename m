Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E573046E
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfE3V6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfE3V6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58A7314DB264E;
        Thu, 30 May 2019 14:39:14 -0700 (PDT)
Date:   Thu, 30 May 2019 14:39:13 -0700 (PDT)
Message-Id: <20190530.143913.1519609810642103812.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: enable WoL speed down on more chip
 versions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <19f0f196-0d7c-97a4-de21-b0754673c014@gmail.com>
References: <19f0f196-0d7c-97a4-de21-b0754673c014@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:39:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 29 May 2019 20:52:03 +0200

> Call the pll power down function also for chip versions 02..06 and
> 13..15. The MAC can't be powered down on these chip versions, but at
> least they benefit from the speed-down power-saving if WoL is enabled.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
