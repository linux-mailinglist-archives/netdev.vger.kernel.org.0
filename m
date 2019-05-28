Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A55B2C557
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfE1LYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:24:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40043 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfE1LYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:24:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id t4so11514132wrx.7
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qEcvvgJMFIRPe6aYSSr5145L4noutj1Bp3XNtqqFIXs=;
        b=lQxotpl2WAPufmz8XbpHwa0CcspzgKN1n7e19D2HcIh71ECDP3d7eKFtUHptgYK9xY
         kdPDsdNRA7at/vKqdALgdyl2fm2iRbFWMjZJBASICA/XOSA40jG27IQtDnFe8I4D1Agy
         00r3MiJWquL5gL/8DRZtjOIhpAovNCuSzsA/6ufIXS7imlBY/e0yc78uTspa7CVKSM/R
         VO6HbQBBqQYvFVvrxjXJV+i8oT1P2KwxFtv4H8B4PrKHg2XB9jIBBlwCYSC1bfpmUZoc
         STk28sIcnvoHQ6Ccd7EqZoRqLibBid/4koc/W4AEPN7O7p60UaAnphl/Q3T7agucEaRm
         tLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qEcvvgJMFIRPe6aYSSr5145L4noutj1Bp3XNtqqFIXs=;
        b=rh4/nGK9wIc9XdHYNRuY73Yx+1vskQk3S02Qi/uu1xa7/T8Jep9SWpTq6gG+HnIV45
         wgvveqmUgI950GD0mzICPTYHur7Nxn7YLIcMHYBGysynv/eekP74RdShnLRztkDRHpgc
         VDumRu3R9M5pOgehP6GVtYsPk/yF9vOxYhMgaKLV7KdJGtgrMaRdtLRqqgAfy2OR1G8r
         K0dogt64/lJYyF4Km4A9QZFb82MKBc540gN4CphpiPGw/1eu8ZPM43hDPNNzHKtZiNjK
         XU40CB0xBE7WglkjTDf5SKDAA2AsjfNoKxm8r+nTl1CPKLGqceHF4kTRRVdX1gBVDrB0
         eAYg==
X-Gm-Message-State: APjAAAWb8WQ8WeNUxzxjhIUq1BaV/4IzCDbejqKWtFuuhllGGarN0161
        YRO9UOinAsJ/ZUCPVH2VTKv/nA==
X-Google-Smtp-Source: APXvYqwNx7PLvpYxsQDFWL4unmyUZKqtbxY+eJhasqg/tYOW3bqofn93WtZ9B9LR2OaTaZl7hZTuZA==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr9413056wro.60.1559042672603;
        Tue, 28 May 2019 04:24:32 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id k8sm11684441wrp.74.2019.05.28.04.24.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 04:24:32 -0700 (PDT)
Date:   Tue, 28 May 2019 13:24:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
Message-ID: <20190528112431.GA2252@nanopsycho>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
 <20190528090823.GB2699@nanopsycho>
 <20190528100211.GX18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528100211.GX18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 28, 2019 at 12:02:11PM CEST, liuhangbin@gmail.com wrote:
>On Tue, May 28, 2019 at 11:08:23AM +0200, Jiri Pirko wrote:
>> >+static int team_ethtool_get_link_ksettings(struct net_device *dev,
>> >+					   struct ethtool_link_ksettings *cmd)
>> >+{
>> >+	struct team *team= netdev_priv(dev);
>> >+	unsigned long speed = 0;
>> >+	struct team_port *port;
>> >+
>> >+	cmd->base.duplex = DUPLEX_UNKNOWN;
>> >+	cmd->base.port = PORT_OTHER;
>> >+
>> >+	list_for_each_entry(port, &team->port_list, list) {
>> >+		if (team_port_txable(port)) {
>> >+			if (port->state.speed != SPEED_UNKNOWN)
>> >+				speed += port->state.speed;
>> >+			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
>> >+			    port->state.duplex != DUPLEX_UNKNOWN)
>> >+				cmd->base.duplex = port->state.duplex;
>> 
>> What is exactly the point of this patch? Why do you need such
>> information. This is hw-related info. If you simply sum-up all txable
>> ports, the value is always highly misleading.
>> 
>> For example for hash-based port selection with 2 100Mbit ports,
>> you will get 200Mbit, but it is not true. It is up to the traffic and
>> hash function what is the actual TX speed you can get.
>> On the RX side, this is even more misleading as the actual speed depends
>> on the other side of the wire.
>
>The number is the maximum speed in theory. I added it because someone

"in theory" is not what this value should return in my opinion.


>said bond interface could show total speed while team could not...
>The usage is customer could get team link-speed and throughput via SNMP.

Has no meaning though :/


>
>Thanks
>Hangbin
>> 
>> 
>> >+		}
>> >+	}
>> >+	cmd->base.speed = speed ? : SPEED_UNKNOWN;
>> >+
>> >+	return 0;
>> >+}
>> >+
>> > static const struct ethtool_ops team_ethtool_ops = {
>> > 	.get_drvinfo		= team_ethtool_get_drvinfo,
>> > 	.get_link		= ethtool_op_get_link,
>> >+	.get_link_ksettings	= team_ethtool_get_link_ksettings,
>> > };
>> > 
>> > /***********************
>> >-- 
>> >2.19.2
>> >
