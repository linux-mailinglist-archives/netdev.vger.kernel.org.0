Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000903E12B1
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbhHEKcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbhHEKcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 06:32:01 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08180C061765;
        Thu,  5 Aug 2021 03:31:46 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id ED4F4502265EA;
        Thu,  5 Aug 2021 03:31:41 -0700 (PDT)
Date:   Thu, 05 Aug 2021 11:31:17 +0100 (BST)
Message-Id: <20210805.113117.1181162254677052108.davem@davemloft.net>
To:     saravanak@google.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, maz@kernel.org, narmstrong@baylibre.com,
        khilman@baylibre.com, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Clean up and fix error handling in
 mdio_mux_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210804214333.927985-1-saravanak@google.com>
References: <20210804214333.927985-1-saravanak@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 05 Aug 2021 03:31:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit the cleanups targetting net-next and the bug fix targetting net.

Thank you.
