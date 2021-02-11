Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD45331836E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 03:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBKCHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 21:07:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35139 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhBKCHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 21:07:16 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lA1ND-0000x3-UJ; Thu, 11 Feb 2021 02:06:28 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id BA7DA5FEE7; Wed, 10 Feb 2021 18:06:25 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B26759FAC3;
        Wed, 10 Feb 2021 18:06:25 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
cc:     netdev@vger.kernel.org, roopa@nvidia.com, andy@greyhouse.net,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexander.duyck@gmail.com, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v2 0/3] bonding: 3ad: support for 200G/400G ports and more verbose warning
In-reply-to: <20210210204333.729603-1-razor@blackwall.org>
References: <20210210204333.729603-1-razor@blackwall.org>
Comments: In-reply-to Nikolay Aleksandrov <razor@blackwall.org>
   message dated "Wed, 10 Feb 2021 22:43:30 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9752.1613009185.1@famine>
Date:   Wed, 10 Feb 2021 18:06:25 -0800
Message-ID: <9753.1613009185@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Aleksandrov <razor@blackwall.org> wrote:

>From: Nikolay Aleksandrov <nikolay@nvidia.com>
>
>Hi,
>We'd like to have proper 200G and 400G support with 3ad bond mode, so we
>need to add new definitions for them in order to have separate oper keys,
>aggregated bandwidth and proper operation (patches 01 and 02). In
>patch 03 Ido changes the code to use pr_err_once instead of
>pr_warn_once which would help future detection of unsupported speeds.
>
>v2: patch 03: use pr_err_once instead of WARN_ONCE
>
>Thanks,
> Nik
>
>Ido Schimmel (1):
>  bonding: 3ad: Print an error for unknown speeds
>
>Nikolay Aleksandrov (2):
>  bonding: 3ad: add support for 200G speed
>  bonding: 3ad: add support for 400G speed
>
> drivers/net/bonding/bond_3ad.c | 26 ++++++++++++++++++++++----
> 1 file changed, 22 insertions(+), 4 deletions(-)

	Patches 1 and 2 could have been one patch, I suppose, but not
really a big deal.  I'm in agreement about pr_err_once instead of
WARN_ONCE.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
