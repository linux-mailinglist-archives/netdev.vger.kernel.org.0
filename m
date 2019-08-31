Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59A6A462D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfHaUVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:21:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfHaUVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:21:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4AE5154A52D6;
        Sat, 31 Aug 2019 13:21:38 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:21:38 -0700 (PDT)
Message-Id: <20190831.132138.475511142209892206.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/2] Dynamic toggling of vlan_filtering for
 SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830005325.26526-1-olteanv@gmail.com>
References: <20190830005325.26526-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 13:21:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 30 Aug 2019 03:53:23 +0300

> This patchset addresses a limitation in dsa_8021q where this sequence of
> commands was causing the switch to stop forwarding traffic:
> 
>   ip link add name br0 type bridge vlan_filtering 0
>   ip link set dev swp2 master br0
>   echo 1 > /sys/class/net/br0/bridge/vlan_filtering
>   echo 0 > /sys/class/net/br0/bridge/vlan_filtering
> 
> The issue has to do with the VLAN table manipulations that dsa_8021q
> does without notifying the bridge layer. The solution is to always
> restore the VLANs that the bridge knows about, when disabling tagging.

Series applied, thank you.
