Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1539A1E956B
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgEaEhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEaEhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:37:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104BAC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:37:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1203128FC2D6;
        Sat, 30 May 2020 21:37:15 -0700 (PDT)
Date:   Sat, 30 May 2020 21:37:11 -0700 (PDT)
Message-Id: <20200530.213711.852036423225428249.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] r8169: again few improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:37:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 30 May 2020 23:52:26 +0200

> Again a series with few r8169 improvements.

Series applied, thanks Heiner.
