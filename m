Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFF222A371
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733220AbgGVX5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgGVX5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 19:57:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8EAC0619DC;
        Wed, 22 Jul 2020 16:57:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E63011E8DD89;
        Wed, 22 Jul 2020 16:40:22 -0700 (PDT)
Date:   Wed, 22 Jul 2020 16:57:04 -0700 (PDT)
Message-Id: <20200722.165704.2159266778898156127.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        robh+dt@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Add DSA yaml binding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720124939.4359-1-kurt@linutronix.de>
References: <20200720124939.4359-1-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 16:40:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Mon, 20 Jul 2020 14:49:36 +0200

> as discussed [1] [2] it makes sense to add a DSA yaml binding. This is the
> second version and contains now two ways of specifying the switch ports: Either
> by "ports" or by "ethernet-ports". That is why the third patch also adjusts the
> DSA core for it.
> 
> Tested in combination with the hellcreek.yaml file.
> 
> Changes since v1:
> 
>  * Use select to not match unrelated switches
>  * Allow ethernet-port(s)
>  * List ethernet-controller properties
>  * Include better description
>  * Let dsa.txt refer to dsa.yaml
 ...
> [1] - https://lkml.kernel.org/netdev/449f0a03-a91d-ae82-b31f-59dfd1457ec5@gmail.com/
> [2] - https://lkml.kernel.org/netdev/20200710090618.28945-1-kurt@linutronix.de/

Series applied to net-next, thanks.
