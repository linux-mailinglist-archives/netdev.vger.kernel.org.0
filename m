Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CF23DFB
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbfETRDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:03:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46964 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390006AbfETRDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:03:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id t187so7053519pgb.13
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 10:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x8ttiJZRDFEXEXr3dvnIQip5we4nIXnwRMovXRxRh7U=;
        b=pASffhFBDpb//4tW1cU1pgZYxu3HPsJ/CtgRGQXCWM6mVdCjviLkqd7NL5ATzIUxM1
         T7oC6uwbxA9Bw3oF8EUgoOx3lSmfFPRsEXM4Qe001VTkxxvPfVheOn0h/R6/DYiuORoz
         +Ae39uBYKcAIliYymLdeFpu+GivRuSnwDFBcp/kk7NLFesyBsJMUF9iY0R1M5GlXDcuw
         MTvS9RAzx/XKpldmQk0XEv7tyL/KuMkWflWIk0eMV22sTAuAyJcP0sssHG0+AY94XtYn
         3QqqfCUw29iXorolhixWKCt2SiK3x+Ja4cYNBuZPZnBbsCLlvQufHkz2LoPPWSEx90hg
         FMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8ttiJZRDFEXEXr3dvnIQip5we4nIXnwRMovXRxRh7U=;
        b=keV/Mbkgn89LbDeYozc0McPiaYlK/sTtXc258F3tZnGybmckZDlLV1pu9iUxoiRt+r
         xEIoynAn+YpFR0e87e25ppH5uhKJqtYpGDZDbih3vvoGeJKjZF9MKzec2+oF/wLSZqux
         mjx4CJUv0dTmKQM6U8/LK6Kf0uR++wOJy9mLr+7nhJa+eN2crCIFa1a+3h7Bv3og/Ev4
         KknvqEu8zsjQQ7nqcKa9Nc6vg2q7Qf4S847/E5mL7bhglK15DkirZWGYUVKRfctI6Oyv
         HSzYzSMpmB/iDR3X+kqTcpcoPuYtUHKI1C3FJ/4aXqKNqh0rI1pHekyCA+tD3agtjHUp
         Ju2g==
X-Gm-Message-State: APjAAAVbfj7kb6nGRVVb+AD5qcs2EcFxVixchY5Ea/sURsbTi8FCwgc8
        2puzun0GpfRxy7a2s+ztwLvMVair7mc=
X-Google-Smtp-Source: APXvYqwcLNWSh73q8yvFMy+xsBsWeQXPr81v/rq17eTkrcq7pwW1fAe5Lz8cxkrPp5Zm+Lawm/zufg==
X-Received: by 2002:a63:8b4b:: with SMTP id j72mr76374031pge.318.1558371809586;
        Mon, 20 May 2019 10:03:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y13sm23435729pfb.143.2019.05.20.10.03.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 10:03:29 -0700 (PDT)
Date:   Mon, 20 May 2019 10:03:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH iproute2 net-next] ip: add a new parameter -Numeric
Message-ID: <20190520100322.2276a76d@hermes.lan>
In-Reply-To: <4e2e8ba7-7c80-4d35-9255-c6dac47df4e7@gmail.com>
References: <20190520075648.15882-1-liuhangbin@gmail.com>
        <4e2e8ba7-7c80-4d35-9255-c6dac47df4e7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 May 2019 09:18:08 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/20/19 1:56 AM, Hangbin Liu wrote:
> > When calles rtnl_dsfield_n2a(), we get the dsfield name from
> > /etc/iproute2/rt_dsfield. But different distribution may have
> > different names. So add a new parameter '-Numeric' to only show
> > the dsfield number.
> > 
> > This parameter is only used for tos value at present. We could enable
> > this for other fields if needed in the future.
> > 
> 
> It does not make sense to add this flag just for 1 field.
> 
> 3 years ago I started a patch to apply this across the board. never
> finished it. see attached. The numeric variable should be moved to
> lib/rt_names.c. It handles all of the conversions in that file - at
> least as of May 2016.


Agree, if you are going to do it, go all in.
Handle all types and in same manner for ip, tc, bridge, and devlink.
ss already has -numeric option.

Wish that -n wasn't used for netns, should have been -N...
