Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8457C286F0F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgJHHQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:16:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38278 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHHQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:16:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id a23so3821653ljp.5;
        Thu, 08 Oct 2020 00:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=axxcjrN6jheBIbfDrV/Ff/WSbvxOpFA8SBhcP4k8xkg=;
        b=b3PPdy/R3rB+LAyaNh52R7THCmfZbGbXx6bTMoSZViLXn3DysDBGGcoGqAC5TB6yxE
         CV4LiYNiTuTOsfxU6lVFDWEA1++ueDnE7YqvnUwVva1YROuwqxtdsnql/dWMVvJ1kTx9
         +YLyHFG0IM0pbdaMCy29AoUb6ld1xtXy6d8npRi6YbNiiFeSUGQZivI5pEL+GIHbPth0
         BLUiXOK4+oAg/bymfXg/i3nOkGkY1aVe/i9ApL8GQ0Rv7oTcsMGmxugH6MDJYaJSin3+
         8OpmJOLDszxw+AAfhJ+a9jrq4r84i3dYwUxtMHwkGD9YFebUeeCpUOLoKwY8i8mppKMR
         CM6Q==
X-Gm-Message-State: AOAM53234s/STlQJK5jdklVdMfKeyB1WVFtCnChOS8S3p0qkEezWUjcE
        8YG5Sbmm/9HA0GLFWS42jBzp7/DRYVE=
X-Google-Smtp-Source: ABdhPJyKujpONsm8tNbjrZfTqlzdWi4CYLN384q7YoRJmIQ/EzWQnvBbKIx1FgS3kWD0W4gB95jCKg==
X-Received: by 2002:a2e:9602:: with SMTP id v2mr2500461ljh.455.1602141370876;
        Thu, 08 Oct 2020 00:16:10 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id t21sm704792ljh.65.2020.10.08.00.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:16:09 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kQQ9k-0004uj-Hk; Thu, 08 Oct 2020 09:16:04 +0200
Date:   Thu, 8 Oct 2020 09:16:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     Johan Hovold <johan@kernel.org>, Lars Melin <larsm17@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201008071604.GG26280@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
 <20201005082045.GL5141@localhost>
 <20201005130134.459b4de9@monster.powergraphx.local>
 <20201005110638.GP5141@localhost>
 <5222246c-08d7-dcf8-248d-c1fefc72c46f@gmail.com>
 <20201005140723.56f6c434@monster.powergraphx.local>
 <20201006070201.GB26280@localhost>
 <20201008084733.41ba3cec@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008084733.41ba3cec@monster.powergraphx.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 08:47:33AM +0200, Wilken Gottwalt wrote:
> On Tue, 6 Oct 2020 09:02:01 +0200
> Johan Hovold <johan@kernel.org> wrote:
> 
> > On Mon, Oct 05, 2020 at 02:07:23PM +0200, Wilken Gottwalt wrote:
> > > On Mon, 5 Oct 2020 18:36:36 +0700 Lars Melin <larsm17@gmail.com> wrote:

> > > > It is very likely that Cellient has replaced the VID with their own and 
> > > > kept the PID, it is something other mfgrs has done when buying modules 
> > > > from Qualcomm's series of devices with predefined composition.
> > > > 
> > > > The MS Windows driver for 05c6:9025 describes the interfaces as:
> > > > 
> > > > MI_00 Qualcomm HS-USB Diagnostics 9025
> > > > MI_01 Android Composite ADB Interface
> > > > MI_02 Qualcomm HS-USB Android Modem 9025
> > > > MI_03 Qualcomm HS-USB NMEA 9025
> > > > MI_04 Qualcomm Wireless HS-USB Ethernet Adapter 9025
> > > > MI_05 USB Mass Storage Device
> > > > 
> > > > where the net interface is for QMI/RMNET.
> > > > It fully matches the blacklisting Wilken has done for 2692:9025
> > > 
> > > Does your device have a GPS connector? Mine had not and I'm not sure
> > > if the description of MI_01 is actually correct. I remember looking at
> > > this port and seeing bogus NMEA data.
> > 
> > Well if it's NMEA then the interface shouldn't be blacklisted (even if
> > the values are bogus on your device), but if it's ADB it should be as
> > that is handled by userspace.
> > 
> > Here's some lsusb output from a Cellient MPL200 that still uses the
> > Qualcomm VID:
> > 
> > 	https://www.mail-archive.com/modemmanager-devel@lists.freedesktop.org/msg04523.html
> > 
> > which gives some support to Lars's hypothesis. I guess we'll just keep
> > the first interface reserved.
> 
> Lars and Johan are right here. I found an older external Gobi driver
> where I actually added comments saying interface 1 is ADB and interface 3
> is NMEA delivering only zeroed values because of the missing antenna
> connector, at least for the models I had access to.

Great, thanks for confirming.

Johan
