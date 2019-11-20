Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC54210451A
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKTUbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:31:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59616 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKTUbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:31:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3F7914C1F41A;
        Wed, 20 Nov 2019 12:31:07 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:31:07 -0800 (PST)
Message-Id: <20191120.123107.1557551937289122832.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH] isdn: Fix Kconfig indentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120134120.15009-1-krzk@kernel.org>
References: <20191120134120.15009-1-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:31:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Wed, 20 Nov 2019 21:41:20 +0800

> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
> 	$ sed -e 's/^        /\t/' -i */Kconfig
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied to net-next
