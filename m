Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2C322A469
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733293AbgGWBND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729401AbgGWBND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:13:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105D8C0619DC;
        Wed, 22 Jul 2020 18:13:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A71FB126B596D;
        Wed, 22 Jul 2020 17:56:17 -0700 (PDT)
Date:   Wed, 22 Jul 2020 18:13:02 -0700 (PDT)
Message-Id: <20200722.181302.1104883511907809883.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     aelior@marvell.com, kuba@kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: qed_hsi.h: Avoid the use of one-element
 array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722185852.GA16220@embeddedor>
References: <20200722185852.GA16220@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:56:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Wed, 22 Jul 2020 13:58:52 -0500

> One-element arrays are being deprecated[1]. Replace the one-element
> array with a simple value type '__le32 reserved1'[2], once it seems
> this is just a placeholder for alignment.
> 
> [1] https://github.com/KSPP/linux/issues/79
> [2] https://github.com/KSPP/linux/issues/86
> 
> Tested-by: kernel test robot <lkp@intel.com>
> Link: https://github.com/GustavoARSilva/linux-hardening/blob/master/cii/0-day/qed_hsi-20200718.md
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied.
