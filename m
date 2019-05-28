Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21DE2C3D6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfE1KCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:02:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33055 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfE1KCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:02:22 -0400
Received: by mail-pl1-f196.google.com with SMTP id g21so8156149plq.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 03:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MgEaDmj03PeHH5s0woc9TH9iQfb45IJscaEm4tsIo10=;
        b=NFRMWN4l5HMrRN8iamOHtu1jy1wkm5rd6XvLiYhgB8PiQ1KSMDFQ4fKr8ywTfba61B
         QWSZeXlDqU1OciFDe3lVZph2qIaB1AFO/N1yy67YPiQ4jhMG8TdCdwL/Pz6sJqNQ2YtC
         qTpmbTAOnGg+M5TM/TY55hE+DIU/YiUSyhUbwFOmnx0p0rqEyGeB/fsFaNuCRfnSonnG
         0nMVeQNQ6JMDYGiGwpwbLJoxW3qgXvf+9n46E2PD+GEP9vHKvxTKrJOLCPd5LQhAQKpn
         4gOEz47eFBNIpXY4Fdg5RcLH2uw0aHuUdxbSthDVxRWNm/IlA7Ibj1kkR6Ea2MGC0BKD
         iVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MgEaDmj03PeHH5s0woc9TH9iQfb45IJscaEm4tsIo10=;
        b=GWbno21/eVHUoh6s5u9vtKSUZR192djl+0uVwyJAb1hrBTrjhThSxlM0NMT3DX8Ywj
         //afzfCTnQyfJMI0yeXWAd8mHfYwVRrgc8R+6rjL4JhLBBEayWV8AvvFyfu+nrNhzakF
         E1YJZi4LVOaki0f0jvRZQhiaR3DFVBB1mAQH0FefFjOpe9EkRDx7Y+fnjLW3Cz0Q8zd4
         uxCtHcN9rNqVnb+nKVvPnypcdBHzZzuPs49i67asVKsAQWvy97a9+aXIwKHkLFQQtGZd
         Dbxjrs8ZnkPSVh0AMmu/ebPc/KmGclOAEhKMxoJihPj43UQO/fAvQM1OKh/1xvhm+uDq
         VDsQ==
X-Gm-Message-State: APjAAAVUIxBGcUF6q1d7sn1E+GVkdbrqED1zhK0rBRcDrvL/fctJyPLD
        ZFOG97QnuREWlotOkWc2SAfNPPOyiGk=
X-Google-Smtp-Source: APXvYqwjeg7qGlQjaBW13MlPqYixzaUHcricbvE1y+f34Shg6AxoTJB5I7j+/ZotlMbSLi5xWkIQ1g==
X-Received: by 2002:a17:902:e683:: with SMTP id cn3mr110946830plb.86.1559037741964;
        Tue, 28 May 2019 03:02:21 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p20sm4996641pgk.7.2019.05.28.03.02.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 03:02:21 -0700 (PDT)
Date:   Tue, 28 May 2019 18:02:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
Message-ID: <20190528100211.GX18865@dhcp-12-139.nay.redhat.com>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
 <20190528090823.GB2699@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528090823.GB2699@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 11:08:23AM +0200, Jiri Pirko wrote:
> >+static int team_ethtool_get_link_ksettings(struct net_device *dev,
> >+					   struct ethtool_link_ksettings *cmd)
> >+{
> >+	struct team *team= netdev_priv(dev);
> >+	unsigned long speed = 0;
> >+	struct team_port *port;
> >+
> >+	cmd->base.duplex = DUPLEX_UNKNOWN;
> >+	cmd->base.port = PORT_OTHER;
> >+
> >+	list_for_each_entry(port, &team->port_list, list) {
> >+		if (team_port_txable(port)) {
> >+			if (port->state.speed != SPEED_UNKNOWN)
> >+				speed += port->state.speed;
> >+			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
> >+			    port->state.duplex != DUPLEX_UNKNOWN)
> >+				cmd->base.duplex = port->state.duplex;
> 
> What is exactly the point of this patch? Why do you need such
> information. This is hw-related info. If you simply sum-up all txable
> ports, the value is always highly misleading.
> 
> For example for hash-based port selection with 2 100Mbit ports,
> you will get 200Mbit, but it is not true. It is up to the traffic and
> hash function what is the actual TX speed you can get.
> On the RX side, this is even more misleading as the actual speed depends
> on the other side of the wire.

The number is the maximum speed in theory. I added it because someone
said bond interface could show total speed while team could not...
The usage is customer could get team link-speed and throughput via SNMP.

Thanks
Hangbin
> 
> 
> >+		}
> >+	}
> >+	cmd->base.speed = speed ? : SPEED_UNKNOWN;
> >+
> >+	return 0;
> >+}
> >+
> > static const struct ethtool_ops team_ethtool_ops = {
> > 	.get_drvinfo		= team_ethtool_get_drvinfo,
> > 	.get_link		= ethtool_op_get_link,
> >+	.get_link_ksettings	= team_ethtool_get_link_ksettings,
> > };
> > 
> > /***********************
> >-- 
> >2.19.2
> >
