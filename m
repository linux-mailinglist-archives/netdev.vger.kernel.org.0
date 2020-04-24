Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03751B828C
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgDXXsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXXsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:48:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978A5C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:48:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40A6A14F478E3;
        Fri, 24 Apr 2020 16:48:17 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:48:16 -0700 (PDT)
Message-Id: <20200424.164816.1537369832495081762.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: phy: smaller phylib improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
References: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:48:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 23 Apr 2020 21:33:52 +0200

> Series with smaller improvements for suspend and soft-reset handling.

Series applied, thanks Heiner.
