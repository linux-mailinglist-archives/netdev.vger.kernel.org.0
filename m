Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E384578D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfFNIc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:32:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37202 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfFNIc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:32:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id 22so1392903wmg.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 01:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QGrjRDL6vnoj/DVgVhDiUjUISnUVk9vjNFRS6O7Pbj8=;
        b=0zeMFAXDs14N7ndKl2AFGXqhuW2GN/t0xV7jOrtJUf3e7cCO2mnFvl0F7LE1RZ7oZy
         n2eQ4Bku+bRjgLZOH8lRzDNA0LvYnjKcFZz56Iv0Qjlw+QV/Jp1FHKint3J5AWntD/3g
         iVxOcr/RWSGM3DV79K4SRRgAG6ITjnBl2ozzJ9h4DUaO8jfPdLmIGyD8eP9390lvXJLm
         2J2UN0b0iYpYhStqGzKw1rUotyypM9IOwXlaB97r8k7d2JUHZyEn8MKXygK99L8n2XbE
         5VF7pbISpyOO5lbrAmDbnGaEfxCXNH/QfAuqkO2aeB8NXOb7LAlIrP5R+5QMev1JmL+B
         agQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QGrjRDL6vnoj/DVgVhDiUjUISnUVk9vjNFRS6O7Pbj8=;
        b=pxtNd8lCQdx9YBcZzblwgE6qaKdQueRdBG1ocvZEsFIUOjx8kSkthnvzd3NkVKBMhd
         TooVtVP6k2y3F6x7DSAVW9Ua2PHAEt5NZrAiZeEZiCysrXw5OHnWoVMmTFJ/Z5aIzBpX
         ZmZwLAH7ue6Xj7+7htHEHbDATQLUcRdUQL2cPA9xLLJsER9U/2ayTkmlpmi0IxU3cSIY
         8g15MH2ZyB/lJNPgbMRkQ+HawXNHIdScq/ALuLRagJPkQwIUdbTwN0QSHVk4SvbHOlqL
         RgBXxIJoNn1YtKiYfgca8YYoU1c8dvmcL5ouiZ8HT/cM7eoJ6MNvqhv7YArTGwQjh9g2
         AI8g==
X-Gm-Message-State: APjAAAV2Bg5ajjIZOnt4h5o+1kEHpDCBeQRuG6Q/RK/xj8q053FgOGXG
        na26fETjc+qgoQ8s3fB9aWn0Xg==
X-Google-Smtp-Source: APXvYqwFVzOHKnyAfthhkk2dKiJPQrG+8QBtudUEXbPBuyxlhDy4MAX7IN6h++tOJmCcmCvn5Q5i0g==
X-Received: by 2002:a1c:f102:: with SMTP id p2mr6689423wmh.126.1560501146574;
        Fri, 14 Jun 2019 01:32:26 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id d3sm4872730wrf.87.2019.06.14.01.32.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:32:26 -0700 (PDT)
Date:   Fri, 14 Jun 2019 10:32:25 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
Message-ID: <20190614083225.GE2242@nanopsycho>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
 <20190528090823.GB2699@nanopsycho>
 <20190528100211.GX18865@dhcp-12-139.nay.redhat.com>
 <20190528112431.GA2252@nanopsycho>
 <20190613061648.GE18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613061648.GE18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 13, 2019 at 08:16:49AM CEST, liuhangbin@gmail.com wrote:
>On Tue, May 28, 2019 at 01:24:31PM +0200, Jiri Pirko wrote:
>> Tue, May 28, 2019 at 12:02:11PM CEST, liuhangbin@gmail.com wrote:
>> >On Tue, May 28, 2019 at 11:08:23AM +0200, Jiri Pirko wrote:
>> >> >+static int team_ethtool_get_link_ksettings(struct net_device *dev,
>> >> >+					   struct ethtool_link_ksettings *cmd)
>> >> >+{
>> >> >+	struct team *team= netdev_priv(dev);
>> >> >+	unsigned long speed = 0;
>> >> >+	struct team_port *port;
>> >> >+
>> >> >+	cmd->base.duplex = DUPLEX_UNKNOWN;
>> >> >+	cmd->base.port = PORT_OTHER;
>> >> >+
>> >> >+	list_for_each_entry(port, &team->port_list, list) {
>> >> >+		if (team_port_txable(port)) {
>> >> >+			if (port->state.speed != SPEED_UNKNOWN)
>> >> >+				speed += port->state.speed;
>> >> >+			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
>> >> >+			    port->state.duplex != DUPLEX_UNKNOWN)
>> >> >+				cmd->base.duplex = port->state.duplex;
>> >> 
>> >> What is exactly the point of this patch? Why do you need such
>> >> information. This is hw-related info. If you simply sum-up all txable
>> >> ports, the value is always highly misleading.
>> >> 
>> >> For example for hash-based port selection with 2 100Mbit ports,
>> >> you will get 200Mbit, but it is not true. It is up to the traffic and
>> >> hash function what is the actual TX speed you can get.
>> >> On the RX side, this is even more misleading as the actual speed depends
>> >> on the other side of the wire.
>> >
>> >The number is the maximum speed in theory. I added it because someone
>
>Hi Jiri,
>
>Sorry for the late reply.
>
>> 
>> "in theory" is not what this value should return in my opinion.
>
>Would you please give some hits about what "in theory" value we should return?
>
>In my understanding, it just shows the maximum in theory speed. Just like a
>NIC card shows the speed 1000Mb/s, but the actually max speed could be only
>700-900 Mb/s for tcp/udp testing. No need to say if the other side's max speed
>is only 100Mb/s, we will get lower speed value.
>
>So I think with ab, rr, lb, random mode, the team speed could be the summary of
>total active ports' speed. The only controversial mode may be the broadcast
>mode as it just broadcast all the data from all ports. But it do send all the
>data. If we ignore the fault tolerance sutff, all the bandwidth are used. The
>speed shows the total number of all NICs looks also make sense.
>
>Hope I made it clear and you could got what I mean..

Yeah, I was thinking about this in the meantime and I admit this is
probably the best of the wrong approaches. The only correct one would be
to teach the userspace apps to understand the topology and report
parameters according to the runner, utilization, division of the
traffic etc. Not real.

Long story short, I'm okay with your patch. Thanks!



>> 
>> 
>> >said bond interface could show total speed while team could not...
>> >The usage is customer could get team link-speed and throughput via SNMP.
>> 
>> Has no meaning though :/
>
>Anyway, the customer is looking for this feature. Shouldn't we
>consider about the requirement?
>
>Thanks
>Hangbin
