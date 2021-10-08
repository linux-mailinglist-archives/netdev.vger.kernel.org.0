Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97298426788
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbhJHKTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239730AbhJHKTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:19:31 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429C5C061764;
        Fri,  8 Oct 2021 03:17:34 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BF6E44FED5494;
        Fri,  8 Oct 2021 03:17:30 -0700 (PDT)
Date:   Fri, 08 Oct 2021 11:16:46 +0100 (BST)
Message-Id: <20211008.111646.1874039740182175606.davem@davemloft.net>
To:     krzysztof.kozlowski@canonical.com
Cc:     k.opasiak@samsung.com, mgreer@animalcreek.com, kuba@kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RESEND PATCH v2 0/7] nfc: minor printk cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Oct 2021 03:17:32 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date: Thu,  7 Oct 2021 15:30:14 +0200

> Hi,
> 
> This is a rebase and resend of v2. No other changes.
> 
> Changes since v1:
> 1. Remove unused variable in pn533 (reported by kbuild).

Please CC: netdev for nfc patches otherwise they will not get tracked
and applied.

Thank you.
