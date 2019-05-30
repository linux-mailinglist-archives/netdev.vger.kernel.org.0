Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AFF30120
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfE3Riw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:38:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38295 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Riv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:38:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id a186so3702344pfa.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o+ztwltOLvyQ8dR43nsGUJHsTLOapZh76LUWRPkownw=;
        b=h08G804xSEfvQ3OV0oXOEj/zS0BwVdlQzEY6J78rcOifSWf1k15LGXOv1rBUBa4Q7U
         X7ZTTimhVGBkfS6xsXVffAKfU0GvuaBpei+0b4R6qfEoi/ko9wo9D4dhaH78wBHIZOR7
         EGbUDCfi5W5HAfYJ5a6ZY4wXasUf3B05RBR9l1wCGTxvo/54VmFMY4p7e2YyUkX4BNWe
         Y8CwN+91KbbAVBey7xGh+0KWjsSZUm7dZdRLhGdzqeQDZQsbmD+FgQaw+bxYdra70AOn
         hp4tibB7wCzLN73fjUPvtNkYx/OxoUZ9tXgb+SbP7M3Bh5MTLWvCTYtvCsN5BG96acfR
         Jmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+ztwltOLvyQ8dR43nsGUJHsTLOapZh76LUWRPkownw=;
        b=FZVDIwmhnOHngTG2tZ8auJsFd1WVj0juBOqRLcbNQWQf6P9cZgUEzDtzSICMvtn0hK
         8KwTv4IQjsvG0XI/8qktCd8R7TBzmJahp+FmpnJ86yhqflFNjhr61VvfOzoAuQi7mClw
         CHXStxjo2HzEsZgOubJ/wQLRTibSaRbdwNwxVhvMNayZDdVPzhh9a8xQnL9tRhcqcPVt
         eOK6rBshI0X2LRnYgbzRAjyq9tMEmWCunU5h6WmREsUUblcxI6fFroA1u2FPFpi4NAAf
         suyYSsUf3cmAKSHeej9CFlu/I5wqxtx1WOAI7uCmzN7uzSlFCsCFfKczr3MiUEcVMAwL
         xtPw==
X-Gm-Message-State: APjAAAUHGQq/csvGNakNQJQLGkTVMmg8SYeFbADcgxhbXoyoPGqxOAtT
        g6r0bCEn1pAEwWeA1W4TpnKnNe4ZuIc=
X-Google-Smtp-Source: APXvYqwAqm6ENiXnuBk1/9gBFC18s1G6rENORNBAoc/xcYw/RHiVTarLUy8dHerNyN3DBTCD4gHv6A==
X-Received: by 2002:a65:62cc:: with SMTP id m12mr4706293pgv.237.1559237930837;
        Thu, 30 May 2019 10:38:50 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k36sm3453349pjb.14.2019.05.30.10.38.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 10:38:50 -0700 (PDT)
Date:   Thu, 30 May 2019 10:38:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Message-ID: <20190530103847.36166cf4@hermes.lan>
In-Reply-To: <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
References: <20190530164246.17955-1-ldir@darbyshire-bryant.me.uk>
        <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 16:43:20 +0000
Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> wrote:

> ctinfo is an action restoring data stored in conntrack marks to various
> fields.  At present it has two independent modes of operation,
> restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
> marks into packet skb marks.
> 
> It understands a number of parameters specific to this action in
> additional to the usual action syntax.  Each operating mode is
> independent of the other so all options are err, optional, however not
> specifying at least one mode is a bit pointless.
> 
> Usage: ... ctinfo [dscp mask[/statemask]] [cpmark [mask]] [zone ZONE] [CONTROL] [index <INDEX>]\n"
> 
> DSCP mode
> 
> dscp enables copying of a DSCP store in the conntrack mark into the
> ipv4/v6 diffserv field.  The mask is a 32bit field and specifies where
> in the conntrack mark the DSCP value is stored.  It must be 6 contiguous
> bits long, e.g. 0xfc000000 would restore the DSCP from the upper 6 bits
> of the conntrack mark.
> 
> The DSCP copying may be optionally controlled by a statemask.  The
> statemask is a 32bit field, usually with a single bit set and must not
> overlap the dscp mask.  The DSCP restore operation will only take place
> if the corresponding bit/s in conntrack mark yield a non zero result.
> 
> eg. dscp 0xfc000000/0x01000000 would retrieve the DSCP from the top 6
> bits, whilst using bit 25 as a flag to do so.  Bit 26 is unused in this
> example.
> 
> CPMARK mode
> 
> cpmark enables copying of the conntrack mark to the packet skb mark.  In
> this mode it is completely equivalent to the existing act_connmark.
> Additional functionality is provided by the optional mask parameter,
> whereby the stored conntrack mark is logically anded with the cpmark
> mask before being stored into skb mark.  This allows shared usage of the
> conntrack mark between applications.
> 
> eg. cpmark 0x00ffffff would restore only the lower 24 bits of the
> conntrack mark, thus may be useful in the event that the upper 8 bits
> are used by the DSCP function.
> 
> Usage: ... ctinfo [dscp mask[/statemask]] [cpmark [mask]] [zone ZONE] [CONTROL] [index <INDEX>]
> where :
> 	dscp MASK is the bitmask to restore DSCP
> 	     STATEMASK is the bitmask to determine conditional restoring
> 	cpmark MASK mask applied to restored packet mark
> 	ZONE is the conntrack zone
> 	CONTROL := reclassify | pipe | drop | continue | ok | goto chain <CHAIN_INDEX>
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>


Your patch is mangled by your mail system, it has DOS line endings etc.

Run checkpatch please.




