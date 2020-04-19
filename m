Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49921AF667
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 05:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgDSDUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 23:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgDSDUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 23:20:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B523C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 20:20:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06F00127B4FD4;
        Sat, 18 Apr 2020 20:20:37 -0700 (PDT)
Date:   Sat, 18 Apr 2020 20:20:37 -0700 (PDT)
Message-Id: <20200418.202037.1886256350240322452.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] r8169: series with improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 20:20:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 18 Apr 2020 23:05:50 +0200

> Again a series with few improvements.

Series applied, thanks.
