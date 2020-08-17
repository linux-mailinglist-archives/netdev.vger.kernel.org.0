Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B5324795C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgHQV6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgHQV6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:58:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF57C061389;
        Mon, 17 Aug 2020 14:58:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD60E15D695B5;
        Mon, 17 Aug 2020 14:41:59 -0700 (PDT)
Date:   Mon, 17 Aug 2020 14:58:45 -0700 (PDT)
Message-Id: <20200817.145845.337622311570874890.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ptp: ptp_clockmatrix: use i2c_master_send for i2c
 write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1597678655-842-1-git-send-email-min.li.xe@renesas.com>
References: <1597678655-842-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:41:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <min.li.xe@renesas.com>
Date: Mon, 17 Aug 2020 11:37:35 -0400

> @@ -53,7 +53,9 @@
>  
>  #define OUTPUT_MODULE_FROM_INDEX(index)	(OUTPUT_0 + (index) * 0x10)
>  
> -#define PEROUT_ENABLE_OUTPUT_MASK		(0xdeadbeef)
> +#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
> +
> +#define IDTCM_MAX_WRITE_COUNT		(512)

Why adjust the indentation of the value of PEROUT_ENABLE_OUTPUT_MASK?  It is meant
to line up with OUTPUT_MODULE_FROM_INDEX.

Please do not make unrelated changes like this and follow existing style and
indentation.

Thank you.
