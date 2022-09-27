Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95A05EBB14
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 09:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiI0HEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 03:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiI0HEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 03:04:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27F876748;
        Tue, 27 Sep 2022 00:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0E6FB8171C;
        Tue, 27 Sep 2022 07:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BE3C433C1;
        Tue, 27 Sep 2022 07:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664262246;
        bh=XsVmdk3Kbtc8/UN1ScHldBcUEK5P+AuSRa66z5gbz/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WuaZqi8rekW0piqvPJ7wdVbyrCFK2/etUczvKbvRii3/B4oqMjYoGU5AHVJ0UMZaV
         vIw9nT1LZ8wPyRItZ0QVuCJujqsRBHoXv+0EHJ3J00QW3ZyNNRyuDUdshl6FweEUyl
         tfbj7Sk4EViWyHKKlcahh7MpUoJj5pDfZwpZDvg3lm0x72kbZJezwGRduknMeaJ7MO
         56ruRsR0z16BhX9kVZmtgqZY0VTaT7CLpw5QqUaEUmIE26BYPu0dU6DxlzdB7bkDZH
         YrlgGpNxTzkfEhNue58lvG3tZ8mDXpad/SJa/EfHs52GDRIa66TkQycHJvPBjRWwyD
         iMFWK8RE1GuTQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1od4dY-00033m-Eu; Tue, 27 Sep 2022 09:04:12 +0200
Date:   Tue, 27 Sep 2022 09:04:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>, linux-usb@vger.kernel.org,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Aw: Re: [PATCH 1/2] USB: serial: qcserial: add new usb-id for
 Dell branded EM7455
Message-ID: <YzKgbCl6eBfqvBa3@hovoldconsulting.com>
References: <20220926150740.6684-1-linux@fw-web.de>
 <20220926150740.6684-2-linux@fw-web.de>
 <YzKYpPFyZYMkVaxS@hovoldconsulting.com>
 <trinity-91bc03bb-af6e-42bc-a365-455816214834-1664261303738@3c-app-gmx-bs56>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-91bc03bb-af6e-42bc-a365-455816214834-1664261303738@3c-app-gmx-bs56>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 08:48:23AM +0200, Frank Wunderlich wrote:
> Hi
> 
> > Gesendet: Dienstag, 27. September 2022 um 08:31 Uhr
> > Von: "Johan Hovold" <johan@kernel.org>

> > On Mon, Sep 26, 2022 at 05:07:39PM +0200, Frank Wunderlich wrote:
> > > From: Frank Wunderlich <frank-w@public-files.de>
> 
> > > +++ b/drivers/usb/serial/qcserial.c
> > > @@ -177,6 +177,7 @@ static const struct usb_device_id id_table[] = {
> > >  	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
> > >  	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
> > >  	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
> > > +	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e QDL */
> > 
> > I assume this is not just for QDL mode as the comment indicates.
> 
> to be honest, have not found out yet what QDL means and assumed that
> it's like the other dw5811e, so not changed comment :)

I believe that's Qualcomm Download mode or similar, for flashing the
device (cf. 5816e which has two entries, one for QDL mode).

> > Could you post the output of usb-devices for this device?
> 
> Bus 001 Device 004: ID 413c:81c2 Sierra Wireless, Incorporated DW5811e Snapdragon™ X7 LTE
> 
> 
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci-mtk/2p, 480M                                                                  
>     ID 1d6b:0002 Linux Foundation 2.0 root hub                                                                                      
>     |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/4p, 480M                                                                         
>         ID 1a40:0101 Terminus Technology Inc. Hub                                                                                   
>         |__ Port 1: Dev 6, If 0, Class=Vendor Specific Class, Driver=qcserial, 480M                                                 
>             ID 413c:81c2 Dell Computer Corp.                                                                                        
>         |__ Port 1: Dev 6, If 2, Class=Vendor Specific Class, Driver=qcserial, 480M                                                 
>             ID 413c:81c2 Dell Computer Corp.                                                                                        
>         |__ Port 1: Dev 6, If 3, Class=Vendor Specific Class, Driver=qcserial, 480M                                                 
>             ID 413c:81c2 Dell Computer Corp.                                                                                        
>         |__ Port 1: Dev 6, If 8, Class=Vendor Specific Class, Driver=qmi_wwan, 480M                                                 
>             ID 413c:81c2 Dell Computer Corp.        

Thanks. The above doesn't include all the details that usb-devices (or
lsusb -v) would but still confirms the basic bits so I've applied the
patch now after amending the comment.

Johan
