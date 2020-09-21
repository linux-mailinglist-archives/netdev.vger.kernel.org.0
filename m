Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF8B27351F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgIUVpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIUVpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:45:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362BAC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 14:45:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6634311E49F62;
        Mon, 21 Sep 2020 14:28:56 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:45:42 -0700 (PDT)
Message-Id: <20200921.144542.1865080112144340779.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next 0/5] PHY subsystem kernel doc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200920171703.3692328-1-andrew@lunn.ch>
References: <20200920171703.3692328-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:28:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 20 Sep 2020 19:16:58 +0200

> The first two patches just fixed warnings seen while trying to work on
> PHY documentation.
> 
> The following patches then first fix existing warnings in the
> kerneldoc for the PHY subsystem, and then extend the kernel
> documentation for the major structures and functions in the PHY
> subsystem.

Please respin with the minor feedback Florian gave for patch #4.

Thanks.
