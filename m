Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B06F24EB7
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 14:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfEUMNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 08:13:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35318 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfEUMNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 08:13:22 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so2990310plo.2
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 05:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BdI5OKQNREhHr46z4bmgW+gyEyU73Oy5E+QBj4m8GOQ=;
        b=o6ewLPiGh1VwABP8pK4hdKvEN4N+A8cjjuCmeW3BBlbyFxLWXC5Jv0AjYaVWSxgloy
         n8/JOhVx2CvBziVqUhSti/QcZKx3zV5aHlthWlLH0l/FqccTwWSgc6aQs2HCx/wfKja6
         7/c0EnruDbpb3oIIVo7lpFhsrT1jtXiDOj3kFuZzV/7TVb2bI0qVGAu1q4Cimg6mpJu7
         Oy7OBO3/SWoQUgc09nDbGTWmMOtZbFUEkqxLExq4s9W1R3D/1YYJA3/TAgQ7mZiL06RJ
         xisVOe6bdSa/kLIwy5g5VoD+1YRGncJbFSxp6o0RGt/tghLZHUOIgagsdRuyNpDbJMM5
         QM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BdI5OKQNREhHr46z4bmgW+gyEyU73Oy5E+QBj4m8GOQ=;
        b=AwQNALnTN8F5LD7mutHFfmSDR7RmW+QXT59IvP/yetq7BbG2LnudySFxihNYLq/HSc
         tlvrfPVRISWqzBj9t2THCH+1CxOZJHmtiqo8z+KmiHpovaUNXO4M0qeyUiuQKTqOH9JY
         HqHHtXWcA9mvtUQT3a02+JloZsbZV/UR9PYzbd87PJOtoeEodFOtLNyugusiBRgB1t7r
         +IpaVUNMGLvNytioaS6XBscagtPQFdjan1ym8oFiIrSZPJS55kDZjH3ksXDQ3C5eOeMF
         k7h1IzyN1BP+FfKg4MST4DlhakUFftdq9OxRC00fUStYYhif4YL/NZQNIRdcucf8l7bY
         1kJA==
X-Gm-Message-State: APjAAAVbkpm8IeqDV1S5480J7dNub8ZgOzKmMaRR7q6efTJJ+Kma/IP8
        Tm5zjLKOggFTpCQ7Z1wAwKk=
X-Google-Smtp-Source: APXvYqzbYbpXYANvqp65SX6zFdcm46V1k2MFkzHxfn1QY9LFf/RTQGBo6hw/aZALDjdQXnrY//YWRg==
X-Received: by 2002:a17:902:46a:: with SMTP id 97mr54077787ple.66.1558440801881;
        Tue, 21 May 2019 05:13:21 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s19sm21320184pfh.176.2019.05.21.05.13.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 05:13:21 -0700 (PDT)
Date:   Tue, 21 May 2019 20:13:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH iproute2 net-next] ip: add a new parameter -Numeric
Message-ID: <20190521121311.GW18865@dhcp-12-139.nay.redhat.com>
References: <20190520075648.15882-1-liuhangbin@gmail.com>
 <4e2e8ba7-7c80-4d35-9255-c6dac47df4e7@gmail.com>
 <20190520100322.2276a76d@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520100322.2276a76d@hermes.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 10:03:22AM -0700, Stephen Hemminger wrote:
> On Mon, 20 May 2019 09:18:08 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
> > On 5/20/19 1:56 AM, Hangbin Liu wrote:
> > > When calles rtnl_dsfield_n2a(), we get the dsfield name from
> > > /etc/iproute2/rt_dsfield. But different distribution may have
> > > different names. So add a new parameter '-Numeric' to only show
> > > the dsfield number.
> > > 
> > > This parameter is only used for tos value at present. We could enable
> > > this for other fields if needed in the future.
> > > 
> > 
> > It does not make sense to add this flag just for 1 field.
> > 
> > 3 years ago I started a patch to apply this across the board. never
> > finished it. see attached. The numeric variable should be moved to
> > lib/rt_names.c. It handles all of the conversions in that file - at
> > least as of May 2016.
> 
> 
> Agree, if you are going to do it, go all in.
> Handle all types and in same manner for ip, tc, bridge, and devlink.
> ss already has -numeric option.

OK, I will do it.

BTW, for some pre-defined names in iproute2, like rtnl_rtprot_tab,
nl_proto_tab. Should we also print the number directly or just keep
using the human readable names?

I would like to keep them as this is defined in iproute and we can control
them. But this may make people feel confused with the -Numeric parameter.
So what do you think?

Thanks
Hangbin
