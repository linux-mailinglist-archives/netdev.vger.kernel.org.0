Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F2310C07E
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfK0XAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 18:00:06 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36454 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfK0XAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 18:00:06 -0500
Received: by mail-qk1-f196.google.com with SMTP id v19so1444818qkv.3;
        Wed, 27 Nov 2019 15:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=XpdT4iBZBeJ0hRqBa8Cg+54FM/3TrXa8XetmtaTWXfg=;
        b=iJIDyU2uu3EUS1+Q4EFqZeRgBTOgt+oDPuvARuIiPFiIKUcnEe8kygilSWnJWk+6tB
         rQRO3BADj5vs8wisC1udDAZF/Kv2qzJTLFX9Kg0o7FbcQ2Nu8FPlYk7xB6Ck7QcHFeM3
         dO+xUHhmC68YpLyC5eaWcqxmVqVatnQFEWr2W4+R+6S2uI995fH4iTn9uHqBZ78hiseq
         FjbClLXuQN4UJqf/OYae/2dGIzK7YCfrSxn38GlYsQ3y57m2mqp25s60IdxdBRdBWUO+
         vaueypzd8wf2014nWduydPt8lkE3UesqZUDd0YOQ9tb560+juINOt6hlaIfyjVsk38KE
         lsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=XpdT4iBZBeJ0hRqBa8Cg+54FM/3TrXa8XetmtaTWXfg=;
        b=LoIAASVALdwLiDZcCYsWWj+Nl0EvCEqso868pH0+FacDodNYNbmYHIZGnA2Wlv+ubm
         cIEjyzLsEtPr+/hON0mISDGva/ryJunu3wV8kL8aa2ZUcYKMLD0YAb2MmA+hThUjvItb
         RK3cGRbTKEKt/uIoyhC77oduowc7sfnpb74D6ppeY0N+H7Ii7MhyVU5TGPckdf9vXLF3
         O9ZyeexYLF+39AWyETgBetelBAYb02Eou8lLRD6fWm2pgrdEJ8/ATci4HG0cvjGqowFk
         7+7QkLENVy93RQjW6Zj0w2OosRPjuHdiYh8/9GnWz+VIIBZxyaWVe3I/WL8+C3n49DKH
         KLfw==
X-Gm-Message-State: APjAAAVejRvkFDbA3LHdn9RghPu38HBuVV2Y8nkB3SyTHKVWGjEBaKPr
        KYAbJkX8M7dwcjsxco5rxdQ=
X-Google-Smtp-Source: APXvYqzekrJWBAHtZShKMHfQIojSr/cql5Qymeq7nJTEiCUDuXYsCg3DhwohjgLWZnDoNz+GBm938g==
X-Received: by 2002:a37:5942:: with SMTP id n63mr7075567qkb.432.1574895605146;
        Wed, 27 Nov 2019 15:00:05 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:3bac:6dc2:4a4b:b6a6:4365])
        by smtp.gmail.com with ESMTPSA id y91sm8644219qtd.28.2019.11.27.15.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 15:00:04 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A2418C08F5; Wed, 27 Nov 2019 20:00:01 -0300 (-03)
Date:   Wed, 27 Nov 2019 20:00:01 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191127230001.GO388551@localhost.localdomain>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain>
 <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 12:50:39PM -0800, Maciej Żenczykowski wrote:
> On Wed, Nov 27, 2019 at 5:14 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Tue, Nov 26, 2019 at 04:13:13PM -0800, Maciej Żenczykowski wrote:
> > > From: Maciej Żenczykowski <maze@google.com>
> > >
> > > and associated inet_is_local_unbindable_port() helper function:
> > > use it to make explicitly binding to an unbindable port return
> > > -EPERM 'Operation not permitted'.
> > >
> > > Autobind doesn't honour this new sysctl since:
> > >   (a) you can simply set both if that's the behaviour you desire
> > >   (b) there could be a use for preventing explicit while allowing auto
> > >   (c) it's faster in the relatively critical path of doing port selection
> > >       during connect() to only check one bitmap instead of both
> > ...
> > > If we *know* that certain ports are simply unusable, then it's better
> > > nothing even gets the opportunity to try to use them.  This way we at
> > > least get a quick failure, instead of some sort of timeout (or possibly
> > > even corruption of the data stream of the non-kernel based use case).
> >
> > This is doable with SELinux today, no?
> 
> Perhaps, but SELinux isn't used by many distros, including the servers
> where I have nics that steal some ports.  It's also much much
> more difficult, requiring a policy, compilers, etc... and it gets even
> more complex if you need to dynamically modify the set of ports,
> which requires extra tools and runtime permissions.

I'm no SELinux expert, but my /etc/ssh/sshd_config has this nice handy
comment:
# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER

The kernel has no specific knowledge of 'ssh_port_t' and all I need to
do to allow such port, is run the command above. No compiler, etc.
The distribution would have to have a policy, say,
'unbindable_ports_t', and it could work similarly, I suppose, but I
have no knowledge on this part.

As a reference only,
# semanage port -l
gives a great list of ports that daemons are supposed to be using, and
it supports ranges and so, like:
amqp_port_t                    tcp      15672, 5671-5672
gluster_port_t                 tcp      38465-38469, 24007-24027

On not having SELinux enabled, you got me there. I not really willing
to enter a "to do SELinux or not" discussion. :-)
