Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6153744590
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbfFMQou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:44:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43473 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbfFMGQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 02:16:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so10301154pgv.10
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 23:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W6Ppd07CKbzUZav1oZCchzmLN3cE4Cc39p2cZdj3v9Y=;
        b=bLBX7xYjVUHf+9wWCvGwYdjtmCeye3psltnkzfHMTew1Wu6Wkk0MS6tno5Wry5HPDt
         hHU8PjnROtwl4HcmjW3pRSlaZjqCO7Miub6rx5sSGUHA5gLEI39g4xpbM0bY+jjWzjr/
         QqOzggTtrEPgyf2KlcUQbj1xPxxhSFdTmK140p9utDw/lxf5PNbivO1eD8bgMkpWUVBM
         RqzfQmhxONS7TYUB4omHYysyLU7Sznzy1nbQ8bct+UZ2h3xh4OM81sNWm6ehVcCv+DAc
         nj5fsR3+H+kWhVYklkkwqB7ii+PD6lCNXxECAtafEK0XipQaQ5G9enmnY+UQak4sJRCO
         pP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W6Ppd07CKbzUZav1oZCchzmLN3cE4Cc39p2cZdj3v9Y=;
        b=WHWCSfzrbifA6bCQUOePMfKNPUpDZa/Z4KtzRBiTbEpNHC89x3RzGusirMDH+/jj1V
         xhRV47Ya7ScBrt+kjQGFr0PzgVNXYebuJL9BlBGkstGSVBSO17Iwtn/mlfDsrJEvUjO2
         tgNvlGJYMIMrb1G3/EG5eL8nqJZaPmBV6Ep+sKcRb58qp/0SloAmhPgdjLPIP1vL6h1q
         7Vg5DzeNcpLtRhZKfBCKsP6PoVJ+motqtGpIRtbfO/hv5ItzoBe//Dbxvd2Y5g9FgC5n
         NfOyb0GIcuq0alLhl4LMRfof/fnZGxyltHgwx5FXOamNTY/w1U1fGvNYasn+Y5LXENH0
         6VJA==
X-Gm-Message-State: APjAAAW2mmSy8WlKGDh9leyJKTBLnper9jc4Cn9tFz2j7N9Z9r3HvDXZ
        Bk0ktRLNsbg2zssd8jzeDDU=
X-Google-Smtp-Source: APXvYqxhHQ6WwRkMZ3KsmziUM6u3KWpPI2WJwYLZ/7hg4qybPnsIoVmP+raYlvkob0utRGoYWBWuEA==
X-Received: by 2002:a63:cc43:: with SMTP id q3mr28871887pgi.438.1560406618993;
        Wed, 12 Jun 2019 23:16:58 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m16sm2309901pfd.127.2019.06.12.23.16.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 23:16:58 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:16:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
Message-ID: <20190613061648.GE18865@dhcp-12-139.nay.redhat.com>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
 <20190528090823.GB2699@nanopsycho>
 <20190528100211.GX18865@dhcp-12-139.nay.redhat.com>
 <20190528112431.GA2252@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528112431.GA2252@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:24:31PM +0200, Jiri Pirko wrote:
> Tue, May 28, 2019 at 12:02:11PM CEST, liuhangbin@gmail.com wrote:
> >On Tue, May 28, 2019 at 11:08:23AM +0200, Jiri Pirko wrote:
> >> >+static int team_ethtool_get_link_ksettings(struct net_device *dev,
> >> >+					   struct ethtool_link_ksettings *cmd)
> >> >+{
> >> >+	struct team *team= netdev_priv(dev);
> >> >+	unsigned long speed = 0;
> >> >+	struct team_port *port;
> >> >+
> >> >+	cmd->base.duplex = DUPLEX_UNKNOWN;
> >> >+	cmd->base.port = PORT_OTHER;
> >> >+
> >> >+	list_for_each_entry(port, &team->port_list, list) {
> >> >+		if (team_port_txable(port)) {
> >> >+			if (port->state.speed != SPEED_UNKNOWN)
> >> >+				speed += port->state.speed;
> >> >+			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
> >> >+			    port->state.duplex != DUPLEX_UNKNOWN)
> >> >+				cmd->base.duplex = port->state.duplex;
> >> 
> >> What is exactly the point of this patch? Why do you need such
> >> information. This is hw-related info. If you simply sum-up all txable
> >> ports, the value is always highly misleading.
> >> 
> >> For example for hash-based port selection with 2 100Mbit ports,
> >> you will get 200Mbit, but it is not true. It is up to the traffic and
> >> hash function what is the actual TX speed you can get.
> >> On the RX side, this is even more misleading as the actual speed depends
> >> on the other side of the wire.
> >
> >The number is the maximum speed in theory. I added it because someone

Hi Jiri,

Sorry for the late reply.

> 
> "in theory" is not what this value should return in my opinion.

Would you please give some hits about what "in theory" value we should return?

In my understanding, it just shows the maximum in theory speed. Just like a
NIC card shows the speed 1000Mb/s, but the actually max speed could be only
700-900 Mb/s for tcp/udp testing. No need to say if the other side's max speed
is only 100Mb/s, we will get lower speed value.

So I think with ab, rr, lb, random mode, the team speed could be the summary of
total active ports' speed. The only controversial mode may be the broadcast
mode as it just broadcast all the data from all ports. But it do send all the
data. If we ignore the fault tolerance sutff, all the bandwidth are used. The
speed shows the total number of all NICs looks also make sense.

Hope I made it clear and you could got what I mean..
> 
> 
> >said bond interface could show total speed while team could not...
> >The usage is customer could get team link-speed and throughput via SNMP.
> 
> Has no meaning though :/

Anyway, the customer is looking for this feature. Shouldn't we
consider about the requirement?

Thanks
Hangbin
