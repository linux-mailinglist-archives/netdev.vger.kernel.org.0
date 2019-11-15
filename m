Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2743FD756
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKOHuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:50:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfKOHuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:50:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4633514BF4683;
        Thu, 14 Nov 2019 23:50:01 -0800 (PST)
Date:   Thu, 14 Nov 2019 23:49:58 -0800 (PST)
Message-Id: <20191114.234958.1198680245198023054.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: allow fast GRO for skbs with
 Ethernet header in head
From:   David Miller <davem@davemloft.net>
In-Reply-To: <097eb720466a7c429c8fd91c792e7cd5@dlink.ru>
References: <20191112122843.30636-1-alobakin@dlink.ru>
        <20191114.172508.1027995193093100862.davem@davemloft.net>
        <097eb720466a7c429c8fd91c792e7cd5@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 23:50:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Fri, 15 Nov 2019 10:36:08 +0300

> Please let me know if I must send v2 of this patch with corrected
> description before getting any further reviews.

I would say that you do, thanks for asking.

The more details and information in the commit message, the better.
