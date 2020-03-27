Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7E31961BE
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgC0XIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:08:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0XIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:08:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E99AC15BDBEDB;
        Fri, 27 Mar 2020 16:07:59 -0700 (PDT)
Date:   Fri, 27 Mar 2020 16:07:59 -0700 (PDT)
Message-Id: <20200327.160759.974164146197650051.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/8] Configure the MTU on DSA switches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 16:08:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Mar 2020 21:55:39 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series adds support for configuring the MTU on front-panel switch
> ports, while seamlessly adapting the CPU port and the DSA master to the
> largest value plus the tagger overhead.
> 
> It also implements bridge MTU auto-normalization within the DSA core, as
> resulted after the feedback of the implementation of this feature inside
> the bridge driver in v2.
> 
> Support was added for quite a number of switches, in the hope that this
> series would gain some traction:
>  - sja1105
>  - felix
>  - vsc73xx
>  - b53 and rest of the platform
> 
> V3 of this series was submitted here:
> https://patchwork.ozlabs.org/cover/1262394/
> 
> V2 of this series was submitted here:
> https://patchwork.ozlabs.org/cover/1261471/
> 
> V1 of this series was submitted here:
> https://patchwork.ozlabs.org/cover/1199868/

Series applied, thank you.
