Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17053F003B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhHRJUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhHRJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:20:25 -0400
Received: from mail.monkeyblade.net (unknown [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199FC061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 02:19:49 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C1DC64D2DFA8D;
        Wed, 18 Aug 2021 02:19:31 -0700 (PDT)
Date:   Wed, 18 Aug 2021 10:19:24 +0100 (BST)
Message-Id: <20210818.101924.2211584682779714222.davem@davemloft.net>
To:     petko.manolov@konsulko.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fixes of set_register(s) return
 value evaluation;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210817140613.27737-1-petko.manolov@konsulko.com>
References: <20210817140613.27737-1-petko.manolov@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 18 Aug 2021 02:19:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit with a proper Fixes: tag, thank you.
