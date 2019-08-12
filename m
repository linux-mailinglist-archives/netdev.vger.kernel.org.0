Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9889654
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfHLEkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:40:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHLEkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:40:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3BE1145F4F52;
        Sun, 11 Aug 2019 21:40:40 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:40:40 -0700 (PDT)
Message-Id: <20190811.214040.1362923590670743834.davem@davemloft.net>
To:     chris.packham@alliedtelesis.co.nz
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] tipc: initialise addr_trail_end when setting node
 addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190811201825.13876-1-chris.packham@alliedtelesis.co.nz>
References: <20190811201825.13876-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:40:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Mon, 12 Aug 2019 08:18:25 +1200

> We set the field 'addr_trial_end' to 'jiffies', instead of the current
> value 0, at the moment the node address is initialized. This guarantees
> we don't inadvertently enter an address trial period when the node
> address is explicitly set by the user.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
