Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E1D1D1FAE
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403812AbgEMTw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390158AbgEMTw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:52:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C64C061A0C;
        Wed, 13 May 2020 12:52:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E89C7127F6DAE;
        Wed, 13 May 2020 12:52:55 -0700 (PDT)
Date:   Wed, 13 May 2020 12:52:55 -0700 (PDT)
Message-Id: <20200513.125255.2269307540440959207.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next 0/4] net: phy: broadcom: cable tester support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513163524.31256-1-michael@walle.cc>
References: <20200513163524.31256-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:52:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Wed, 13 May 2020 18:35:20 +0200

> Add cable tester support for the Broadcom PHYs. Support for it was
> developed on a BCM54140 Quad PHY which RDB register access.
> 
> If there is a link partner the results are not as good as with an open
> cable. I guess we could retry if the measurement until all pairs had at
> least one valid result.
> 
> changes since v1:
>  - added Reviewed-by: tags
>  - removed "div by 2" for cross shorts, just mention it in the commit
>    message. The results are inconclusive if the tests are repeated. So
>    just report the length as is for now.
>  - fixed typo in commit message

Series applied, thanks.
