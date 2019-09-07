Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CCCACA10
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 01:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbfIGXyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 19:54:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:51524 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731557AbfIGXyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 19:54:19 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id D9DB0140CCC;
        Sun,  8 Sep 2019 01:54:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1567900458; bh=i5r9hR1GcDnnP7/tGdcCIQnIZI/5e/hl2mda1beOhgU=;
        h=Date:From:To;
        b=bL6HQ0CNWRKlWhXl+WZnWjVvpAANr+qdN42rmY0mO6fEojyJd8aebL9IlFp4mDE95
         9dsKKwDA302JDyKJyAT9UiRooHHovAKuFXasEO9dc5QHiLN+txU6GbKbkLfHTVRzXM
         pqSn4w/epM8bilmfmmn/E/GUWvVjpCXfjKEPGcT8=
Date:   Sun, 8 Sep 2019 01:54:17 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: introduce
 .port_set_policy
Message-ID: <20190908015417.29cfc94b@nic.cz>
In-Reply-To: <20190907200049.25273-3-vivien.didelot@gmail.com>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
        <20190907200049.25273-3-vivien.didelot@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Sep 2019 16:00:48 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> @@ -3132,6 +3132,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
>  	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
>  	.port_set_speed = mv88e6352_port_set_speed,
>  	.port_tag_remap = mv88e6095_port_tag_remap,
> +	.port_set_policy = mv88e6352_port_set_policy,
>  	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
>  	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
>  	.port_set_ether_type = mv88e6351_port_set_ether_type,

Topaz also supports this, 6141 and 6341.
