Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9A4283179
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgJEIGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:06:21 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37794 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEIGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:06:21 -0400
Received: by mail-lf1-f67.google.com with SMTP id z19so9767109lfr.4;
        Mon, 05 Oct 2020 01:06:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Pqt87N2/oWHfTXcWeuFEUpVJyuj9uGxDoWHyl4VsuNw=;
        b=qEtDfkL4oRXA+ryHTsbpYGG8IzG2j8dp257iHRp4FKd8sYhTVm3pHYDcWkoNTCkhqa
         OEa2hQyoqI2WRjfBFfESyFQWAGKWbHfSzxLMb6BKxVxnDgOqsHmGhqO5369sIOEbKGUp
         +XUsMnAzfRLaq45sqQJSY+tpVB2umlZ4oKmjQ4rP0Sz1ylJ2+4+VezeDFS2IjKRsd5Wy
         OQ4PW6RACVbHbUGPGL+ryK7GrtWrL8KY4PUAvQ2d1e/vBRnaukAWFptX14zzNcQlrGRi
         PQlHtkRN1V4AePfQAMQB32SM+it+PDrSATZgCHwrlqW8TnoOTuO6MtyM0v5PqYn86XI7
         BTRQ==
X-Gm-Message-State: AOAM532qIWzOMHcmeiIxIJdFfis4keDoZxtoy6bACW0y06gs9lMcQ8ms
        GdiQmwv0ogGGZGq/gnWEQWsVH5G+Isk=
X-Google-Smtp-Source: ABdhPJwMDK/OvFS7GonadUK7h37lMatnXiLgyf7iqxV5X6VIN7PAAQ766so0hyMXMUkcm8G6Y4028Q==
X-Received: by 2002:a19:430f:: with SMTP id q15mr5962457lfa.191.1601885178228;
        Mon, 05 Oct 2020 01:06:18 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id q11sm2691823lfc.309.2020.10.05.01.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 01:06:17 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kPLVc-0006Wk-Rh; Mon, 05 Oct 2020 10:06:13 +0200
Date:   Mon, 5 Oct 2020 10:06:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: serial: qmi_wwan: add Cellient MPL200 card
Message-ID: <20201005080612.GI5141@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
 <87d01yovq5.fsf@miraculix.mork.no>
 <20201004203042.093ac473@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201004203042.093ac473@monster.powergraphx.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 08:30:42PM +0200, Wilken Gottwalt wrote:
> On Sun, 04 Oct 2020 17:29:38 +0200
> Bjørn Mork <bjorn@mork.no> wrote:
> 
> > Wilken Gottwalt <wilken.gottwalt@mailbox.org> writes:
> > 
> > > Add usb ids of the Cellient MPL200 card.
> > >
> > > Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> > > ---
> > >  drivers/net/usb/qmi_wwan.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > > index 07c42c0719f5..0bf2b19d5d54 100644
> > > --- a/drivers/net/usb/qmi_wwan.c
> > > +++ b/drivers/net/usb/qmi_wwan.c
> > 
> > This is not a 'usb: serial' driver. Please resend with a less confusing
> > subject prefix.
> > 
> > > @@ -1432,6 +1432,7 @@ static const struct usb_device_id products[] = {
> > >  	{QMI_GOBI_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
> > >  	{QMI_GOBI_DEVICE(0x12d1, 0x14f1)},	/* Sony Gobi 3000 Composite */
> > >  	{QMI_GOBI_DEVICE(0x1410, 0xa021)},	/* Foxconn Gobi 3000 Modem device (Novatel
> > > E396) */
> > > +	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},	/* Cellient MPL200 (rebranded Qualcomm
> > > 0x05c6) */ 
> > >  	{ }					/* END */
> > >  };
> > 
> > 
> > This table is supposed to be organized by device type.  The last section
> > is for Gobi2k and Gobi3k devices.  Please try to put new devices into
> > the correct section.
> 
> Oh sorry, looks like I got it mixed up a bit. It was my first attempt to submit
> a patch set. Which is the best way to resubmit an update if the other part of
> the patch set gets accepted? The documentation about re-/submitting patch sets
> is a bit thin.

Just send these as individual patches (not a series) as they are
independent and go through separate trees.

Also, I never received the USB serial patch, only this one, so you need
to resend both anyway.

Johan
