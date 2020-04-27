Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33511BAF6A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgD0UZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbgD0UZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:25:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1D1C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:25:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEE3115D6B9D0;
        Mon, 27 Apr 2020 13:25:37 -0700 (PDT)
Date:   Mon, 27 Apr 2020 13:25:37 -0700 (PDT)
Message-Id: <20200427.132537.2224731308286933559.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH resend net-next] r8169: improve error message if no
 dedicated PHY driver is found
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d0d394de-6b5f-e340-6269-8539af02829b@gmail.com>
References: <d0d394de-6b5f-e340-6269-8539af02829b@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 13:25:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 27 Apr 2020 21:07:00 +0200

> There's a number of consumer mainboards where the BIOS leaves the PHY
> in a state that it's reporting an invalid PHY ID. To detect such cases
> add the PHY ID to the error message if no dedicated PHY driver is found.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> - accidently sent previous version from wrong mail account

Applied, thanks.
