Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E784F2D871A
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 15:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439177AbgLLOef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 09:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLLOef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 09:34:35 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D974BC0613CF;
        Sat, 12 Dec 2020 06:33:54 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cm17so12467862edb.4;
        Sat, 12 Dec 2020 06:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1ysjGHJCqoELjN/o6Ll5rueoAoZM1cNxe2y7UCTlF04=;
        b=Zq3fEMjuP+QSEG9N3Rq4e6l4DAgKjPnXThIeusTrtO/97+iN+MdCPT6pwLYWYtxj/R
         eG8vD2aGGvR4UIYUnRClKWHV46GcEafNUK1yWRWJq8Wu0wRDJAfwz7YXlmvSo74tjOBj
         mw7HWKHG5SnqCQNxAiQQlDlRtsGbSthXMIRTUXUvkJC+Lz4KoA4jcLNqcLYGOpqudUlK
         Zyt1xtJi9XjES6yaYSw+sQpvMyDSRTPmLTEaApu8YJfLuKw1rRoC3QDSowh1/4d9SoHB
         tsPDz5NDqT2LaFjIqQtKnIrmgc5Ba+SxpJlM1GBrw2nEI9qjCrNE+iYtfJcY6XRL/6sv
         tLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1ysjGHJCqoELjN/o6Ll5rueoAoZM1cNxe2y7UCTlF04=;
        b=Y6GPF8jqrYR+xHpUNyO4WHgqWZwR5MQDNsRh+wN1lQas72gyYuhMWEDSzIA+TbA/my
         4uu84KAXJ5eLisfRLlZoYfS01HwYjTJojaTN0Yo5FDb9dVuCmwNx3V+aMyO2TJf1huxK
         DQTb1yFK/fnvSJzk78JbJ0/9lQ05scek9dxiYEVc25QcX0/ZwGHx1yGxqkjwo7f0LSK9
         YywH7zphTWIgUJ+/Bpjf/GOcfqnMx46x27AisIC2fEaPAwCLdTVGEZkOy02MuTr3mkBa
         FhFs+k7kIVh6CKHux5QSckM0fHqQcL62O+Kz0ktFGlcGySGU/FPRAkctOHeToazxIVU9
         R97w==
X-Gm-Message-State: AOAM532wTgQV9iLan3+M+3o8HfqZqC6uNJuLDkH9cvfEyzyPQ6awwRij
        saO3RKR7H0qXtJnjQRwX+0tKHZflhNs=
X-Google-Smtp-Source: ABdhPJxju1FAqC1ECfSi/xZzBI6E40EMjNXndwx+1PEi1Btip7tA16tNh/ggXyWZJX0dZStSDv5ziw==
X-Received: by 2002:a50:9310:: with SMTP id m16mr16960068eda.94.1607783633428;
        Sat, 12 Dec 2020 06:33:53 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id x15sm10894384edj.91.2020.12.12.06.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 06:33:52 -0800 (PST)
Date:   Sat, 12 Dec 2020 16:33:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Libing Zhou <libing.zhou@nokia-sbell.com>, davem@davemloft.net,
        mingo@redhat.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netconsole: Support VLAN for netconsole
Message-ID: <20201212143351.qzpadffnirht76yh@skbuf>
References: <20201210100742.8874-1-libing.zhou@nokia-sbell.com>
 <40a77a26-9944-245e-cb16-6690221efbd0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40a77a26-9944-245e-cb16-6690221efbd0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 09:55:16AM -0800, Florian Fainelli wrote:
> 
> 
> On 12/10/2020 2:07 AM, Libing Zhou wrote:
> > During kernel startup phase, current netconsole doesn’t support VLAN
> > since there is no VLAN interface setup already.
> > 
> > This patch provides VLAN ID and PCP as optional boot/module parameters
> > to support VLAN environment, thus kernel startup log can be retrieved
> > via VLAN.
> > 
> > Signed-off-by: Libing Zhou <libing.zhou@nokia-sbell.com>
> > ---
> >  Documentation/networking/netconsole.rst | 10 ++++-
> >  drivers/net/netconsole.c                |  3 +-
> >  include/linux/netpoll.h                 |  3 ++
> >  net/core/netpoll.c                      | 58 ++++++++++++++++++++++++-
> >  4 files changed, 70 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/networking/netconsole.rst b/Documentation/networking/netconsole.rst
> > index 1f5c4a04027c..a08387fcc3f0 100644
> > --- a/Documentation/networking/netconsole.rst
> > +++ b/Documentation/networking/netconsole.rst
> > @@ -13,6 +13,8 @@ IPv6 support by Cong Wang <xiyou.wangcong@gmail.com>, Jan 1 2013
> >  
> >  Extended console support by Tejun Heo <tj@kernel.org>, May 1 2015
> >  
> > +VLAN support by Libing Zhou <libing.zhou@nokia-sbell.com>, Dec 8 2020
> > +
> >  Please send bug reports to Matt Mackall <mpm@selenic.com>
> >  Satyam Sharma <satyam.sharma@gmail.com>, and Cong Wang <xiyou.wangcong@gmail.com>
> >  
> > @@ -34,7 +36,7 @@ Sender and receiver configuration:
> >  It takes a string configuration parameter "netconsole" in the
> >  following format::
> >  
> > - netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
> > + netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr][-V<vid:pcp>]
> >  
> >     where
> >  	+             if present, enable extended console support
> > @@ -44,11 +46,17 @@ following format::
> >  	tgt-port      port for logging agent (6666)
> >  	tgt-ip        IP address for logging agent
> >  	tgt-macaddr   ethernet MAC address for logging agent (broadcast)
> > +	-V            if present, enable VLAN support
> > +	vid:pcp       VLAN identifier and priority code point
> >  
> >  Examples::
> >  
> >   linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
> >  
> > +or using VLAN::
> > +
> > + linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc-V100:1
> > +
> >  or::
> >  
> >   insmod netconsole netconsole=@/,@10.0.0.2/
> > diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> > index 92001f7af380..f0690cd6a744 100644
> > --- a/drivers/net/netconsole.c
> > +++ b/drivers/net/netconsole.c
> > @@ -36,7 +36,6 @@
> >  #include <linux/inet.h>
> >  #include <linux/configfs.h>
> >  #include <linux/etherdevice.h>
> > -
> >  MODULE_AUTHOR("Maintainer: Matt Mackall <mpm@selenic.com>");
> >  MODULE_DESCRIPTION("Console driver for network interfaces");
> >  MODULE_LICENSE("GPL");
> > @@ -46,7 +45,7 @@ MODULE_LICENSE("GPL");
> >  
> >  static char config[MAX_PARAM_LENGTH];
> >  module_param_string(netconsole, config, MAX_PARAM_LENGTH, 0);
> > -MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]");
> > +MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr][-V<vid:pcp>]");
> >  
> >  static bool oops_only = false;
> >  module_param(oops_only, bool, 0600);
> > diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
> > index e6a2d72e0dc7..8ab3f25cadae 100644
> > --- a/include/linux/netpoll.h
> > +++ b/include/linux/netpoll.h
> > @@ -31,6 +31,9 @@ struct netpoll {
> >  	bool ipv6;
> >  	u16 local_port, remote_port;
> >  	u8 remote_mac[ETH_ALEN];
> > +	bool vlan_present;
> > +	u16 vlan_id;
> > +	u8 pcp;
> >  };
> >  
> >  struct netpoll_info {
> > diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> > index 2338753e936b..077a7aec51ae 100644
> > --- a/net/core/netpoll.c
> > +++ b/net/core/netpoll.c
> > @@ -478,6 +478,14 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
> >  
> >  	skb->dev = np->dev;
> >  
> > +	if (np->vlan_present) {
> > +		skb->vlan_proto = htons(ETH_P_8021Q);
> > +
> > +		/* htons for tci is done in __vlan_insert_inner_tag, not here */
> > +		skb->vlan_tci = (np->pcp << VLAN_PRIO_SHIFT) + (np->vlan_id & VLAN_VID_MASK);
> > +		skb->vlan_present = 1;
> > +	}
> 
> This does not seem to be the way to go around this, I would rather
> specifying eth0.<VID> on the netconsole parameters and automatically
> create a VLAN interface from that which would ensure that everything
> works properly and that the VLAN interface is linked to its lower device
> properly.
> 
> If you prefer your current syntax, that is probably fine, too but you
> should consider registering a VLAN device when you parse appropriate
> options.
> -- 
> Florian

I don't have a strong opinion, considering that I have not actually
tried this. I do tend to agree with Florian about registering an 8021q
interface, as long as there aren't any other complications associated
with it. As for the syntax, I am not sure if "eth0.<VID>" is universal
enough to make an ABI out of it.
