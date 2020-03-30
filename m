Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0451C19839F
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgC3Spi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:45:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgC3Spg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:45:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B83A115C66A8D;
        Mon, 30 Mar 2020 11:45:35 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:45:34 -0700 (PDT)
Message-Id: <20200330.114534.1408781419763242146.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve handling of TD_MSS_MAX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eda95a7b-2873-538a-567a-4fe9e1ca2bb2@gmail.com>
References: <eda95a7b-2873-538a-567a-4fe9e1ca2bb2@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:45:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 29 Mar 2020 18:28:45 +0200

> If the mtu is greater than TD_MSS_MAX, then TSO is disabled, see
> rtl8169_fix_features(). Because mss is less than mtu, we can't have
> the case mss > TD_MSS_MAX in the TSO path.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
