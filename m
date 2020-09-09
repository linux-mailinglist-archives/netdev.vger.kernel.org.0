Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B272635F8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIIS04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgIIS0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:26:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BAFC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:26:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCC941295A9EC;
        Wed,  9 Sep 2020 11:10:05 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:26:51 -0700 (PDT)
Message-Id: <20200909.112651.316991618642135494.davem@davemloft.net>
To:     pbarker@konsulko.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/4] ksz9477 dsa switch driver improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909100417.380011-1-pbarker@konsulko.com>
References: <20200909100417.380011-1-pbarker@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 11:10:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Barker <pbarker@konsulko.com>
Date: Wed,  9 Sep 2020 11:04:13 +0100

> These changes were made while debugging the ksz9477 driver for use on a
> custom board which uses the ksz9893 switch supported by this driver. The
> patches have been runtime tested on top of Linux 5.8.4, I couldn't
> runtime test them on top of 5.9-rc3 due to unrelated issues. They have
> been build tested on top of net-next.
 ...

Series applied to net-next, thank you.

