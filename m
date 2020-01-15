Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFADE13C1A8
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgAOMvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:51:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAOMvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 07:51:19 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B5ECE159E7DA5;
        Wed, 15 Jan 2020 04:51:17 -0800 (PST)
Date:   Wed, 15 Jan 2020 04:51:15 -0800 (PST)
Message-Id: <20200115.045115.844354931575663015.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add vlan notifications
 and rtm support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
References: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 04:51:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 14 Jan 2020 19:56:06 +0200

> This patch-set is a prerequisite for adding per-vlan options support
> because we need to be able to send vlan-only notifications and do larger
> vlan netlink dumps. Per-vlan options are needed as we move the control
> more to vlans and would like to add per-vlan state (needed for per-vlan
> STP and EVPN), per-vlan multicast options and control, and I'm sure
> there would be many more per-vlan options coming.
 ...

Series applied, thanks Nikolay.
