Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C3AB204D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390489AbfIMNT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:19:59 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39807 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390476AbfIMNT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:19:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so28073376qki.6;
        Fri, 13 Sep 2019 06:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+pqaPjqlV0BrQ4hHhXgFPuFmBz/FGOsoy+9VPaJq4nA=;
        b=aBn2R2ojjt/ijFu6BvSdJi6kRhogvV7noZDEe+OiOjb+RZQdhVjAlmZEQQXl80aFlG
         bZsFq+zk7CnQ0jhVO+J2xeGS70mdCNHNARDvXrhthUhGz875pDiWVUojLwDqfJgM3NCk
         XsdRoJNepJk5j9L/WIfQBA9KaPXu+KiwcLNy2yyeZKZsJFw6j0G6cJ0DuWhxsPc+mpx+
         baXSHaBHMy9uKIRsgabCrcjmMLhBu8V8EjusYruiQ5s2fv4SB9sIVSNQYTUX0fbSbby6
         3/xf6EPhhykIVCp4K8X/5QO09BdjHmkZIoINx4BHKNYXOItq94Fwi8wW+8H02i13TAkw
         11Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+pqaPjqlV0BrQ4hHhXgFPuFmBz/FGOsoy+9VPaJq4nA=;
        b=BlGcInxHpRWBP29yhORwFuXYhxGoDzNuBAPEG+i/NzSB2BHEazQZIkzo52BC6OL1Yl
         j2jgdC6NQEicAUPOCRtfGFr452rxsvHIMEiFQqnt7+Xxo9p+xndgOYR/s9p9VvGVhsnX
         nxlNhAZh+dwXoAM2HRzKeEbrODVcuVQevIPgqcQps5xBrNBUsv6JliyZzU5GgTu4+O1o
         qN6XQN4OBGSp3YOkep129GT7xKwozSSzUU3t7nimIgKGKdRqSvPAmMwjzRimgQoV1hl/
         2iYLZLcMG4JhY2x+QRJihiWeGhFslh38EQze/OTAElVMbcms0liUKmY5qPc8KDjISRxz
         qJYw==
X-Gm-Message-State: APjAAAVjeK4rVilLVnAjZzv2vhMkFEsLZ7IB3CIncxg1aRXgdpb62bdM
        5b0CN6zFehc/G7WVNMrK77c=
X-Google-Smtp-Source: APXvYqw/sJHeV5Pu8xBRCoBzzMQzQDjc1Bu0VcTumGgMpn6uhMK8LHImBx3Y2zWhnYLACyZ0Wp4zsA==
X-Received: by 2002:a37:5a06:: with SMTP id o6mr33782201qkb.279.1568380797870;
        Fri, 13 Sep 2019 06:19:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f01c:48c2:8ccf:8b81:8d41:df1e])
        by smtp.gmail.com with ESMTPSA id e42sm1431201qte.26.2019.09.13.06.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 06:19:56 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5F495C4A55; Fri, 13 Sep 2019 10:19:54 -0300 (-03)
Date:   Fri, 13 Sep 2019 10:19:54 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Message-ID: <20190913131954.GX3431@localhost.localdomain>
References: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
 <20190911125609.GC3499@localhost.localdomain>
 <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
 <20190912225154.GF3499@localhost.localdomain>
 <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 08:36:22AM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 12 September 2019 23:52
> ...
> > Here it is more visible. If net->...ps_retrans is disabled, remaining
> > fields (currently just this one, but as we are extending it now, we
> > have to think about the possibility of more as well) will be ignored,
> > we and we may not want that.
> 
> The only real way to add additional fields is to change the name
> of the structure - that way recompiled programs still work.
> 
> You could require that programs zero the entire structure - but
> that is difficult to verify.
> And, in this case, it seems that the default has to be 0xffff
> rather than 0 - which is, in itself, horrid.

Yep, and with that, a new sockopt as well. May not be the most
beautiful way, but it's the safest. Applications can then probe if the
sockopt is available or not and use what they want/can.

Inner kernel code can then be rearranged like it was for the peeloff
operation and peeloff + flags, and these issues just don't exist then.

We actually had agreed on using new sockopts, on thread
[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length

Interestingly, we have/had the opposite problem with netlink. Like, it
was allowing too much flexibility, such as silently ignoring unknown
fields (which is what would happen with a new app running on an older
kernel would trigger here) is bad because the app cannot know if it
was actually used or not. Some gymnastics in the app could cut through
the fat here, like probing getsockopt() return size, but then it may
as well probe for the right sockopt to be used.

  Marcelo
