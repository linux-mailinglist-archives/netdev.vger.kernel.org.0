Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9666E1EB143
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgFAVph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgFAVph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:45:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4345C061A0E;
        Mon,  1 Jun 2020 14:45:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0DC011F5F637;
        Mon,  1 Jun 2020 14:45:35 -0700 (PDT)
Date:   Mon, 01 Jun 2020 14:45:35 -0700 (PDT)
Message-Id: <20200601.144535.203726078659236025.davem@davemloft.net>
To:     victor@inliniac.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, corbet@lwn.net,
        edumazet@google.com, willemb@google.com, maowenan@huawei.com,
        arnd@arndb.de, nhorman@tuxdriver.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] af-packet: new flag to indicate all csums are
 good
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601204938.13302-1-victor@inliniac.net>
References: <20200601204938.13302-1-victor@inliniac.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 14:45:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Julien <victor@inliniac.net>
Date: Mon,  1 Jun 2020 22:49:37 +0200

> @@ -472,6 +472,12 @@ TP_STATUS_CSUM_VALID	This flag indicates that at least the transport
>  			validated on the kernel side. If the flag is not set
>  			then we are free to check the checksum by ourselves
>  			provided that TP_STATUS_CSUMNOTREADY is also not set.
> +TP_STATUS_CSUM_UNNECESSARY  This flag indicates that the driver validated all
> +                        the packets csums. If it is not set it might be that
> +                        the driver doesn't support this, or that one of the
> +                        layers csums is bad. TP_STATUS_CSUM_VALID may still
> +                        be set if the transport layer csum is correct or
> +                        if the driver supports only this mode.
>  ======================  =======================================================
                        ^^^^^

I think you need to reformat these dividers.

