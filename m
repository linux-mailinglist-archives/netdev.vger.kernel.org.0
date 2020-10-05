Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7009528349E
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 13:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgJELGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 07:06:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40361 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJELGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 07:06:47 -0400
Received: by mail-lf1-f66.google.com with SMTP id a9so942606lfc.7;
        Mon, 05 Oct 2020 04:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C0dTs41OrVTZ/P3AA4ZGUtSfP+cxizWeFj5N633TtGU=;
        b=MRj7/Kz0pN3IxSfMzwCesa0lCbX/3Qzl92i/G74YfAjrYTinK9i/dxpnJ64Q1C9d17
         4zMAof/YsrJP3alKFefv9KaDZWT6se/xw/OeSsX17h+XFXZy6CzYCXDYUS1lT8tjfDOC
         xG+/zrHcnq8yR/x0Eba3EZT0TUUt4uW+n0GFcj0pUWAyzRJHQSKStoKjyYUvC2QRIbAl
         zYf9+UbUipjUmTnUoa/1id4z+qJRkB81sd9Mc1xZF8+PVSaHNHiHTzv+pE/T3f7Rk9gx
         t6nVo6TuK9ibFJ7LgvblB3wjhZxU//lb/MD7ZInpXuU+6AtreOHBcIHY+b+iOfevUXAB
         Y6aw==
X-Gm-Message-State: AOAM531xDiY2Ao6R66O4lTAXsR9QHIlKYYB6KkaWouGTbamw5EW+5PCh
        Iz4N/iAnBYHC1b3fPkQPz/M=
X-Google-Smtp-Source: ABdhPJx9G9aqy1qlXknI5yEktHc6rcJv5HV+UYF/KiP7CyF7kqiPPQPhCtUL6V1N2Baa5momlM8J8A==
X-Received: by 2002:ac2:4c31:: with SMTP id u17mr5089372lfq.1.1601896002590;
        Mon, 05 Oct 2020 04:06:42 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id c1sm2583968ljd.105.2020.10.05.04.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 04:06:41 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kPOKE-0005gb-P8; Mon, 05 Oct 2020 13:06:38 +0200
Date:   Mon, 5 Oct 2020 13:06:38 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201005110638.GP5141@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
 <20201005082045.GL5141@localhost>
 <20201005130134.459b4de9@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005130134.459b4de9@monster.powergraphx.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 01:01:34PM +0200, Wilken Gottwalt wrote:
> On Mon, 5 Oct 2020 10:20:45 +0200
> Johan Hovold <johan@kernel.org> wrote:
> 
> > On Sat, Oct 03, 2020 at 11:40:29AM +0200, Wilken Gottwalt wrote:
> > > Add usb ids of the Cellient MPL200 card.
> > > 
> > > Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> > > ---

> > > @@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
> > >  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff,
> > > 0x02, 0x01) }, { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2,
> > > 0xff, 0x00, 0x00) }, { USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
> > > +	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
> > > +	  .driver_info = RSVD(1) | RSVD(4) },
> > 
> > Would you mind posting the output of "lsusb -v" for this device?
> 
> I would like to, but unfortunately I lost access to this really rare hardware
> about a month ago. It is a Qualcomm device (0x05c6:0x9025) with a slightly
> modified firmware to rebrand it as a Cellient product with a different vendor
> id. How to proceed here, if I have no access to it anymore? Drop it?

No, that's ok, I've applied the patch now. It's just that in case we
ever need to revisit the handling of quirky devices, it has proven
useful to have a record the descriptors.

Do you remember the interface layout and why you blacklisted interface
1?

Johan
