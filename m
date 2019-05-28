Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E5F2C2C1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfE1JIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:08:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34224 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfE1JI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:08:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id e19so1769225wme.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 02:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vHGXXLTKqf5HZ4IMEy3p07mpgHJpfV6I01cHozBLGK4=;
        b=OQZSNEuC3ovzTTsV7vhDjt1Ig05ocfEOsBCAoU7snFiChUxA9nJ9Fa02czaT1xLxmg
         gvG4xiYiY7njndLYqBwF+utSuT6RththcLZW37IybtHlbsp4nb/0Iu9ycMooP8Mw6dkz
         QFmcXZLOFDRgTwioLBymTKr2mkoQbkDsMNwbbkVdAy98Bcv02jx4X2nttPcanBg/thFJ
         /2v4VIA8eEucteYwuhALUi0T+YZ06twy8bXLbpXNiZC5vRoh9zqrR/pZ8O6ValA8Pw4S
         BHXAVRUG9d3OjdkDeMl/4WOEg+2RkHOCzb+dUG9F3f21jfUU5ZnOKJpBg6WYKZ7IRZMO
         NXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vHGXXLTKqf5HZ4IMEy3p07mpgHJpfV6I01cHozBLGK4=;
        b=VEnzDvutlL8uxhNFXXylr9kGstrvqX6b5xM0OMv00gdlU2TniZ9B4flfIOWORQR6/s
         nuq53TPfdyPHN9v7wtvXLkATSXfOjOl+tsEMQ9UfMrKcpUKzZj4HBqLW9X4jO8HkGwDE
         774sD9UTxT9cEdROPir+rR7WgohZvH7jnelfR0akiAZCjYqAdJwIotOxrzwM4WnXSM37
         CTCduc81W3XZHI1Hh5sd8yNt81DOOrLq8wijJaUJV0IGcWz91u4l0+aWuop0e5+IPVWE
         Yww+A5s7YuHo4QX5wBx8aPibirCV2v/gxVOwubT9WUQe/TK5yaUTljbJ1AgplRZN9EFu
         jfvg==
X-Gm-Message-State: APjAAAWJe7yNMUOVSAp/H+qMImBkaEc1SDhGUGHxPwhVFRa/nZsrJWG2
        08iaK5kNnbP8rh0NKc8hLzRl1SvqgQc=
X-Google-Smtp-Source: APXvYqxmuAZVOwFQEovvI+L4LEE1slwo+s3eGnjwI1zx0gKdx2G7P10hXNt1DEIxwoRDY8YCQr6lQg==
X-Received: by 2002:a1c:2507:: with SMTP id l7mr2197637wml.23.1559034504981;
        Tue, 28 May 2019 02:08:24 -0700 (PDT)
Received: from localhost ([5.180.201.3])
        by smtp.gmail.com with ESMTPSA id y8sm3129259wmi.8.2019.05.28.02.08.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 02:08:24 -0700 (PDT)
Date:   Tue, 28 May 2019 11:08:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
Message-ID: <20190528090823.GB2699@nanopsycho>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527033110.9861-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 27, 2019 at 05:31:10AM CEST, liuhangbin@gmail.com wrote:
>Like bond, add ethtool get_link_ksettings to show the total speed.
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> drivers/net/team/team.c | 25 +++++++++++++++++++++++++
> 1 file changed, 25 insertions(+)
>
>diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
>index 2106045b3e16..5e892ee4c006 100644
>--- a/drivers/net/team/team.c
>+++ b/drivers/net/team/team.c
>@@ -2058,9 +2058,34 @@ static void team_ethtool_get_drvinfo(struct net_device *dev,
> 	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
> }
> 
>+static int team_ethtool_get_link_ksettings(struct net_device *dev,
>+					   struct ethtool_link_ksettings *cmd)
>+{
>+	struct team *team= netdev_priv(dev);
>+	unsigned long speed = 0;
>+	struct team_port *port;
>+
>+	cmd->base.duplex = DUPLEX_UNKNOWN;
>+	cmd->base.port = PORT_OTHER;
>+
>+	list_for_each_entry(port, &team->port_list, list) {
>+		if (team_port_txable(port)) {
>+			if (port->state.speed != SPEED_UNKNOWN)
>+				speed += port->state.speed;
>+			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
>+			    port->state.duplex != DUPLEX_UNKNOWN)
>+				cmd->base.duplex = port->state.duplex;

What is exactly the point of this patch? Why do you need such
information. This is hw-related info. If you simply sum-up all txable
ports, the value is always highly misleading.

For example for hash-based port selection with 2 100Mbit ports,
you will get 200Mbit, but it is not true. It is up to the traffic and
hash function what is the actual TX speed you can get.
On the RX side, this is even more misleading as the actual speed depends
on the other side of the wire.


>+		}
>+	}
>+	cmd->base.speed = speed ? : SPEED_UNKNOWN;
>+
>+	return 0;
>+}
>+
> static const struct ethtool_ops team_ethtool_ops = {
> 	.get_drvinfo		= team_ethtool_get_drvinfo,
> 	.get_link		= ethtool_op_get_link,
>+	.get_link_ksettings	= team_ethtool_get_link_ksettings,
> };
> 
> /***********************
>-- 
>2.19.2
>
