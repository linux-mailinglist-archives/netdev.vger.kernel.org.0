Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F691B161A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDTTnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725896AbgDTTnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:43:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E264DC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:43:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E5E2127FA525;
        Mon, 20 Apr 2020 12:43:52 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:43:51 -0700 (PDT)
Message-Id: <20200420.124351.1258166785764343074.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 0/3] RFC 2863 Testing Oper status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419221152.884053-1-andrew@lunn.ch>
References: <20200419221152.884053-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:43:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 20 Apr 2020 00:11:49 +0200

> This patchset add support for RFC 2863 Oper status testing.  An
> interface is placed into this state when a self test is performed
> using ethtool.
> 
> v2:
> Fix date/kernel version in Documentation
> Add reviewed-by tags

Series applied, thanks Andrew.
