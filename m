Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9501698A17
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 06:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbfHVD5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:57:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730683AbfHVD5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:57:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 337C1152366B6;
        Wed, 21 Aug 2019 20:57:36 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:57:35 -0700 (PDT)
Message-Id: <20190821.205735.2069656948701231785.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, jpettit@nicira.com,
        simon.horman@netronome.com, marcelo.leitner@gmail.com,
        vladbu@mellanox.com, jiri@mellanox.com, roid@mellanox.com,
        yossiku@mellanox.com, ronye@mellanox.com, ozsh@mellanox.com
Subject: Re: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from
 tc chain index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566304251-15795-1-git-send-email-paulb@mellanox.com>
References: <1566304251-15795-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:57:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Tue, 20 Aug 2019 15:30:51 +0300

> @@ -4050,6 +4060,9 @@ enum skb_ext_id {
>  #ifdef CONFIG_XFRM
>  	SKB_EXT_SEC_PATH,
>  #endif
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> +	TC_SKB_EXT,
> +#endif
>  	SKB_EXT_NUM, /* must be last */
>  };

Sorry, no.

The SKB extensions are not a dumping ground for people to use when they can't
figure out another more reasonable place to put their values.  Try to use
the normal cb[], and if you can't you must explain in exhaustive detail
why you cannot in any way whatsoever make that work.

Again, SKB extensions are not a dumping ground.
