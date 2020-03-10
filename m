Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434D2180C66
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgCJXbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:31:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgCJXbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:31:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F035814DA84AB;
        Tue, 10 Mar 2020 16:31:19 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:31:18 -0700 (PDT)
Message-Id: <20200310.163118.1457052167026363295.davem@davemloft.net>
To:     mayflowerera@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sd@queasysnail.net
Subject: Re: [PATCH v3 1/2] macsec: Support XPN frame handling - IEEE
 802.1AEbw
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309194702.117050-1-mayflowerera@gmail.com>
References: <20200309194702.117050-1-mayflowerera@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:31:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Era Mayflower <mayflowerera@gmail.com>
Date: Mon,  9 Mar 2020 19:47:01 +0000

> Support extended packet number cipher suites (802.1AEbw) frames handling.
> This does not include the needed netlink patches.
> 
>     * Added xpn boolean field to `struct macsec_secy`.
>     * Added ssci field to `struct_macsec_tx_sa` (802.1AE figure 10-5).
>     * Added ssci field to `struct_macsec_rx_sa` (802.1AE figure 10-5).
>     * Added salt field to `struct macsec_key` (802.1AE 10.7 NOTE 1).
>     * Created pn_t type for easy access to lower and upper halves.
>     * Created salt_t type for easy access to the "ssci" and "pn" parts.
>     * Created `macsec_fill_iv_xpn` function to create IV in XPN mode.
>     * Support in PN recovery and preliminary replay check in XPN mode.
> 
> In addition, according to IEEE 802.1AEbw figure 10-5, the PN of incoming
> frame can be 0 when XPN cipher suite is used, so fixed the function
> `macsec_validate_skb` to fail on PN=0 only if XPN is off.
> 
> Signed-off-by: Era Mayflower <mayflowerera@gmail.com>

Sabrina, please review these two patches.

Thank you.
