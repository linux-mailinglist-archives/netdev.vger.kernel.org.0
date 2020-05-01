Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2271C0CD1
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgEADx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:53:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6B6C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:53:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8A4712777A7B;
        Thu, 30 Apr 2020 20:53:27 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:53:26 -0700 (PDT)
Message-Id: <20200430.205326.2076239112809002882.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: configure PME_SIGNAL for RTL8125 too
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f0e60fd0-a4ac-2b2e-7278-f3f599e7d6e2@gmail.com>
References: <f0e60fd0-a4ac-2b2e-7278-f3f599e7d6e2@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:53:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 28 Apr 2020 22:55:59 +0200

> RTL8125 supports the same PME_SIGNAL handling as all later RTL8168
> chip variants.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
