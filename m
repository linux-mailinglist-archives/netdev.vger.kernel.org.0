Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8271B15EC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDTT1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTT1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:27:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A5BC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:27:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2C10127F98BC;
        Mon, 20 Apr 2020 12:27:32 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:27:32 -0700 (PDT)
Message-Id: <20200420.122732.1786644519285516848.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: inline rtl8169_mark_as_last_descriptor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0e92eda1-79c2-761f-b58e-8a50eb94080c@gmail.com>
References: <0e92eda1-79c2-761f-b58e-8a50eb94080c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:27:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 19 Apr 2020 23:07:39 +0200

> rtl8169_mark_as_last_descriptor() has just one user, so inline it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
