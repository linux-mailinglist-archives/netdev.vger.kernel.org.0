Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD312846B8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgJFHCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:02:12 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32992 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgJFHCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 03:02:11 -0400
Received: by mail-lf1-f67.google.com with SMTP id l2so828777lfk.0;
        Tue, 06 Oct 2020 00:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xVHBvfBhaYdlhUHysSfoQOHRN/3Ik6cMafEkNwOoykw=;
        b=GmL2nfcGTdV2AlFhlkDKdCxneiPy64o2mMmLa98akCHiY3SKNBvT56WPZyEIFvFuB0
         B5VFA2CcUKfQMfppcff2d+8Qhm1WBdUKerBFwkaGzNVS2/H31BEvbapIfEYqLXvA92LT
         P0C9Z9+WbWE/fq7BygTZ9ywmhDnwOd60Mdl9MgJoSCWon18AOOEIXaXCgn9SZLUI9NWA
         enrpk4kDACIubUwzwcgGuIsjzzxZs2js4qMKyYmhsvp02agYPYTuC4K4+knZz9dl+s+r
         ZdQ5AnHflTXSBNM2jiPWEhlp7HyumRCfcPaZ24AXHKTqEdPbVW/j17m0LT55zUKFPcnu
         6AVA==
X-Gm-Message-State: AOAM532E7UZSZgurtu4gNoj0EpxSvm4FH9hGWToWpS4Y4CJ921klOARG
        odbRowp1WZ/OonOHOsQDx3w=
X-Google-Smtp-Source: ABdhPJz6A1+SkmW10Xw4aOOUN7l0P+lzOXGyuSTP6v01ODYApoqx0s8L+151N65BY9/siAUeE+UBbw==
X-Received: by 2002:ac2:4d10:: with SMTP id r16mr8083lfi.58.1601967728460;
        Tue, 06 Oct 2020 00:02:08 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id o6sm573531ljc.33.2020.10.06.00.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 00:02:07 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kPgz3-00072H-Vo; Tue, 06 Oct 2020 09:02:02 +0200
Date:   Tue, 6 Oct 2020 09:02:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     Lars Melin <larsm17@gmail.com>, Johan Hovold <johan@kernel.org>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201006070201.GB26280@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
 <20201005082045.GL5141@localhost>
 <20201005130134.459b4de9@monster.powergraphx.local>
 <20201005110638.GP5141@localhost>
 <5222246c-08d7-dcf8-248d-c1fefc72c46f@gmail.com>
 <20201005140723.56f6c434@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005140723.56f6c434@monster.powergraphx.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 02:07:23PM +0200, Wilken Gottwalt wrote:
> On Mon, 5 Oct 2020 18:36:36 +0700 Lars Melin <larsm17@gmail.com> wrote:
> > On 10/5/2020 18:06, Johan Hovold wrote:

> > > Do you remember the interface layout and why you blacklisted interface
> > > 1?

> > It is very likely that Cellient has replaced the VID with their own and 
> > kept the PID, it is something other mfgrs has done when buying modules 
> > from Qualcomm's series of devices with predefined composition.
> > 
> > The MS Windows driver for 05c6:9025 describes the interfaces as:
> > 
> > MI_00 Qualcomm HS-USB Diagnostics 9025
> > MI_01 Android Composite ADB Interface
> > MI_02 Qualcomm HS-USB Android Modem 9025
> > MI_03 Qualcomm HS-USB NMEA 9025
> > MI_04 Qualcomm Wireless HS-USB Ethernet Adapter 9025
> > MI_05 USB Mass Storage Device
> > 
> > where the net interface is for QMI/RMNET.
> > It fully matches the blacklisting Wilken has done for 2692:9025
> 
> Does your device have a GPS connector? Mine had not and I'm not sure
> if the description of MI_01 is actually correct. I remember looking at
> this port and seeing bogus NMEA data.

Well if it's NMEA then the interface shouldn't be blacklisted (even if
the values are bogus on your device), but if it's ADB it should be as
that is handled by userspace.

Here's some lsusb output from a Cellient MPL200 that still uses the
Qualcomm VID:

	https://www.mail-archive.com/modemmanager-devel@lists.freedesktop.org/msg04523.html

which gives some support to Lars's hypothesis. I guess we'll just keep
the first interface reserved.

Johan
