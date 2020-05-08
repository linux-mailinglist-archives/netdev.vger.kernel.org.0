Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E691C9FB0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEHAcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEHAcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:32:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E077C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:32:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 078C41193B1B0;
        Thu,  7 May 2020 17:32:18 -0700 (PDT)
Date:   Thu, 07 May 2020 17:32:17 -0700 (PDT)
Message-Id: <20200507.173217.1917825431576882441.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vinicius.gomes@intel.com, po.liu@nxp.com
Subject: Re: [PATCH v3 net-next 0/6] tc-gate offload for SJA1105 DSA switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505192057.9086-1-olteanv@gmail.com>
References: <20200505192057.9086-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:32:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  5 May 2020 22:20:51 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Expose the TTEthernet hardware features of the switch using standard
> tc-flower actions: trap, drop, redirect and gate.
> 
> v1 was submitted at:
> https://patchwork.ozlabs.org/project/netdev/cover/20200503211035.19363-1-olteanv@gmail.com/
> 
> v2 was submitted at:
> https://patchwork.ozlabs.org/project/netdev/cover/20200503211035.19363-1-olteanv@gmail.com/
> 
> Changes in v3:
> Made sure there are no compilation warnings when
> CONFIG_NET_DSA_SJA1105_TAS or CONFIG_NET_DSA_SJA1105_VL are disabled.
> 
> Changes in v2:
> Using a newly introduced dsa_port_from_netdev public helper.

Series applied, thanks.
