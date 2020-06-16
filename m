Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2701FC093
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 23:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgFPVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPVBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 17:01:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BB5C061573;
        Tue, 16 Jun 2020 14:01:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 237D6128D864A;
        Tue, 16 Jun 2020 14:01:37 -0700 (PDT)
Date:   Tue, 16 Jun 2020 14:01:36 -0700 (PDT)
Message-Id: <20200616.140136.2098262489959228356.davem@davemloft.net>
To:     tharvey@gateworks.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: add MODULE_DEVICE_TABLE for module loading
 alias
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592321518-28464-1-git-send-email-tharvey@gateworks.com>
References: <1592321518-28464-1-git-send-email-tharvey@gateworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 14:01:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 16 Jun 2020 08:31:58 -0700

> Without a MODULE_DEVICE_TABLE the attributes are missing that create
> an alias for auto-loading the module in userspace via hotplug.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Applied, thank you.
