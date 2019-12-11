Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D277F11C080
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfLKXYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:24:51 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:41757 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfLKXYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 18:24:51 -0500
Received: by mail-pj1-f66.google.com with SMTP id ca19so193857pjb.8
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 15:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kQFxMWNV4rgLBmw4zuw/aZgjr7Z3zb6XFoOJB/+sV9I=;
        b=r1TZS5QMatjWbLH5EaYwA2CYRpw0u9gnsPDXWvyUsCPRiNauT66mOl+3/MS5XLLglo
         Xy9TaK0MndN3MMWdjbsBlZhh7g34/f4luVrSrcs+1klheGOTmk4rSan5FMqYCi7y86OI
         K+YqrMh+WEjGFFrDHV4daw6GN+LNbewJaNLRRLwzEb64UtO9XBaW8Uzq0dtNPDXX2pPR
         yvEIFo+NHxmiwXB9GXh5uxH3CV9sbJtBJXMwZy1bK8JYpgS2Q72atPzzPa265z8qx7JY
         ObB4xKHZmSed0mgzq1oHOiJ6vUIZw1CDcxp5gekJ6l+TgLx2ffES0suL++/43IVZqu23
         U51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kQFxMWNV4rgLBmw4zuw/aZgjr7Z3zb6XFoOJB/+sV9I=;
        b=T8ln/9j1w4e9vbrY1FBz75aPN0eZU9njNCyOqLqZRdewUPxp1aPEdXzj1CqysQl25V
         8uSIHNQ43Fo24YL7fCb0z1KZfxmVBHXyeogiI3htKTAz3cgQwce4blkBtZ1NYoWbGqGr
         4NQegVnnMuL5ynarXFEjWVqTSLekn9WHEk7fYIiZLNG9wOKqJJxeTq6kWJQtlHQx6J0o
         T/0WGAUJksqE4z+bzBENaYHnBI2cRteTivNfs2yO6ZV5x4WBgLiuxInPfD3tINrJ6tlE
         w1s/Zt++aK9gWvgkApw6U+Fw9cDWuOrRxj+SZDvqKBtr4IPHh5iZJ9l1tfjZk3CuRaYJ
         sLVw==
X-Gm-Message-State: APjAAAVXdI3rsWffVtVz2e0r5q+VlwAFXRKXaRPsjmUHzZK0uPKJKpt+
        XAO6myu615BM+Lel4r71WVLNnw==
X-Google-Smtp-Source: APXvYqyUa7q0yLtfW9aGxFE+qQYWXcdLj+ncDZmXWGuGTutIoSHc//eDxsjQ3jfUumBlpQaJUcqA1g==
X-Received: by 2002:a17:902:8b86:: with SMTP id ay6mr6102040plb.223.1576106689937;
        Wed, 11 Dec 2019 15:24:49 -0800 (PST)
Received: from shemminger-XPS-13-9360 ([167.220.58.27])
        by smtp.gmail.com with ESMTPSA id s196sm4523159pfs.136.2019.12.11.15.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 15:24:49 -0800 (PST)
Date:   Wed, 11 Dec 2019 15:24:46 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH iproute2 v2] iplink: add support for STP xstats
Message-ID: <20191211152446.4334559d@shemminger-XPS-13-9360>
In-Reply-To: <20191210131633.GB1344570@t480s.localdomain>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
        <20191209230522.1255467-2-vivien.didelot@gmail.com>
        <20191209161345.5b3e757a@hermes.lan>
        <20191210131633.GB1344570@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 13:16:33 -0500
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Hi Stephen,
> 
> On Mon, 9 Dec 2019 16:13:45 -0800, Stephen Hemminger <stephen@networkplumber.org> wrote:
> > On Mon,  9 Dec 2019 18:05:22 -0500
> > Vivien Didelot <vivien.didelot@gmail.com> wrote:
> >   
> > > Add support for the BRIDGE_XSTATS_STP xstats, as follow:
> > > 
> > >     # ip link xstats type bridge_slave dev lan5
> > >                         STP BPDU:
> > >                           RX: 0
> > >                           TX: 39
> > >                         STP TCN:
> > >                           RX: 0
> > >                           TX: 0
> > >                         STP Transitions:
> > >                           Blocked: 0
> > >                           Forwarding: 1
> > >                         IGMP queries:
> > >                           RX: v1 0 v2 0 v3 0
> > >                           TX: v1 0 v2 0 v3 0
> > >     ...  
> > 
> > Might I suggest a more concise format:
> > 	STP BPDU:  RX: 0 TX: 39
> > 	STP TCN:   RX: 0 TX:0
> > 	STP Transitions: Blocked: 0 Forwarding: 1
> > ...  
> 
> I don't mind if you prefer this format ;-)

Just trying to reduce the long output. Which is already too long for the xstat as it is.
