Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAC14653C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAWKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:00:15 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37010 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgAWKAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:00:15 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so1126285pga.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 02:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F6pSebdzNamSU8e5A/uS/3nP12DqbV4N2HTCe1agClc=;
        b=sAmDcF+SmpRFa3mr67+6K3kkn/JtDUWL4JgVBn14C/ZFPNQSkfnxp+FKTyXgLLuy/6
         9ljfCezyBzTRzYdBP3doRYsQ+EG/xzF9J6f5BpfJhk3jM1nOIrcjWaYAe3dgF5hb8Jq8
         tFOIRUmxRwhZIw7639jhEpaqVB0qrW+CMoBD8RHFb04WszCxZF9/iHcK+A6ktZPZksZx
         DD/M9V/nVfhBMqQG28rlbji1ut02E8jPXYqFYwhKOJ6t1IV1liNM4BYhoJ/i5F51rJTR
         i62YB3Y6YWTCOo8B4kqAhA+UYoUZB/SRxAzfYCngKJFOqbd5qoo2eU67z9tq3US6EAjA
         v2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F6pSebdzNamSU8e5A/uS/3nP12DqbV4N2HTCe1agClc=;
        b=YlSkXAjD81cBYMBzIdcmmVCnWtqMRMwmt1BngPjSVGR1yO1PheoDEkyYv55wewCWbk
         0PJgjgCWphfygCcOdVoI2bOUAlRONraM+pBohTFnlQErtlFEnDnrO27lrzyoUdeMlHqb
         CkjDleqwIeVesDd3pejQ8H1M2P0gxXQYHdDeeCPHKMG95XWR4m63UmAaSZf43SqsKlg0
         zM+Yv6s1xirwL7dL3o5bxkXts3kmk+/lx6Yg1sxBH+AoAVpSxU+jIWoxZE9T1xZRJWOA
         N5xfhJkxgCA8G6MIeaiLaL9WdGfeijjLg5zrd6+wWhI7yCeQf+URLmKSbtv7OkyIn9iM
         425w==
X-Gm-Message-State: APjAAAVMYCt9v4E4muwsL1c/khtQnlvBUbtNdVeGFi3gRVDHO6U69zVX
        lulzRoPi/WGzjihjQvQXt88=
X-Google-Smtp-Source: APXvYqzMTxryIcTCXla5mjIaJrwU7wvZWvsO/7JcKMmtOAjc71D6puXLL7PM17T87wlMCHWCSzfStg==
X-Received: by 2002:a63:214e:: with SMTP id s14mr3031130pgm.428.1579773614650;
        Thu, 23 Jan 2020 02:00:14 -0800 (PST)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id x4sm1939948pff.143.2020.01.23.02.00.13
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 02:00:14 -0800 (PST)
Date:   Thu, 23 Jan 2020 15:30:11 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v4 2/2] net: Special handling for IP & MPLS.
Message-ID: <20200123100011.GB6331@martin-VirtualBox>
References: <cover.1579624762.git.martin.varghese@nokia.com>
 <946031c56fa58d24f4a7ab45cbc6dfc9e42c8106.1579624762.git.martin.varghese@nokia.com>
 <CA+FuTSdvC+7MuEPnB2kUxx+L5170SxEP1Gn6AfN5v6e5_RqcvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdvC+7MuEPnB2kUxx+L5170SxEP1Gn6AfN5v6e5_RqcvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 01:30:53PM -0500, Willem de Bruijn wrote:
> On Tue, Jan 21, 2020 at 12:51 PM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > Special handling is needed in bareudp module for IP & MPLS as they
> > support more than one ethertypes.
> >
> > MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
> > While decapsulating MPLS packet from UDP packet the tunnel destination IP
> > address is checked to determine the ethertype. The ethertype of the packet
> > will be set to 0x8848 if the  tunnel destination IP address is a multicast
> > IP address. The ethertype of the packet will be set to 0x8847 if the
> > tunnel destination IP address is a unicast IP address.
> >
> > IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version
> > field of the IP header tunnelled will be checked to determine the ethertype.
> >
> > This special handling to tunnel additional ethertypes will be disabled
> > by default and can be enabled using a flag called ext mode. This flag can
> > be used only with ethertypes 0x8847 and 0x0800.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for your time.
