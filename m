Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B828355F
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 14:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJEMHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 08:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgJEMHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 08:07:30 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9ABC0613CE;
        Mon,  5 Oct 2020 05:07:29 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4C4fVS3Tt8zKm5Q;
        Mon,  5 Oct 2020 14:07:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1601899645; bh=uW44uYPrhB
        Ak9bdc1yCwjJpGoZBR7+lNRqJgmDKEtuQ=; b=g/g/Egz1LWJ8/l/+iPloHI1gWt
        YWjY4ZCxMZ7f35deW9qVtVKgv/B66cw68Jw54rZQ8bBh0QXeGifK6C/MELPrEq5H
        49mfdl63pk8naBbXlDmp44LFsT68ChZ+k8qeJjW3xnnRf8votgc2eXZTE0Vi4MHD
        394mywM4dvYPW6SRMEbOiPE2J8EFk5pDcPytI6++as3Qjah0Ow8oPuHOnIH/8wzB
        IDy44OJIlSDFwCfL2Pyw6j64NqwrwzmDh8NqlgSAuu1VXhc2rBa7YhmbvJCcqMLt
        B0nkF+YReEI8ewXx8fI1oVJNp2P1+M+d9r6uinM07X+L80IvpNQYZMAylcAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601899646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RYy9CaSjXdLF8peC9exJg+yhvC7heRaR3PJTeXb8sjM=;
        b=C5C1Bq/J8CI8e8FJNy+sV0Uy1CWdz8LhfEpw8jyMV61mWBXGdJuOqMykgE/7FGlMc2hwMU
        vVU7HD/pjvXxEwYRNw1scd8eSfY2jIbI1PoZR97xf3NuaVY8EpxinXCBQQjFbsYMA0lrq1
        NSJgOeA86gboKG9hhU3zuCts755QjDs3glpLLcIVdFeNt0FguAmvpfPfMCxSLYHUxw0ZUg
        0ESYKXY0sXlsDwo2LsAN+gMY6osYgOwrPHZCWoUvOOScF52+qJQYYybzNEkqhYGv4tDPWp
        ECUA6PjvceY26kc/zYH6DcZp9f8k/t8gLTHlRsYV2WBiVzBuC0FOu7EbvgKLcQ==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id VqJVNEQz4qN1; Mon,  5 Oct 2020 14:07:25 +0200 (CEST)
Date:   Mon, 5 Oct 2020 14:07:23 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     Lars Melin <larsm17@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201005140723.56f6c434@monster.powergraphx.local>
In-Reply-To: <5222246c-08d7-dcf8-248d-c1fefc72c46f@gmail.com>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
        <20201005082045.GL5141@localhost>
        <20201005130134.459b4de9@monster.powergraphx.local>
        <20201005110638.GP5141@localhost>
        <5222246c-08d7-dcf8-248d-c1fefc72c46f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.98 / 15.00 / 15.00
X-Rspamd-Queue-Id: 8B9A91824
X-Rspamd-UID: 543473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Oct 2020 18:36:36 +0700
Lars Melin <larsm17@gmail.com> wrote:

> On 10/5/2020 18:06, Johan Hovold wrote:
> > On Mon, Oct 05, 2020 at 01:01:34PM +0200, Wilken Gottwalt wrote:
> >> On Mon, 5 Oct 2020 10:20:45 +0200
> >> Johan Hovold <johan@kernel.org> wrote:
> >>
> >>> On Sat, Oct 03, 2020 at 11:40:29AM +0200, Wilken Gottwalt wrote:
> >>>> Add usb ids of the Cellient MPL200 card.
> >>>>
> >>>> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> >>>> ---
> > 
> >>>> @@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
> >>>>   	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2,
> >>>> 0xff, 0x02, 0x01) }, { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> >>>> MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) }, { USB_DEVICE(CELLIENT_VENDOR_ID,
> >>>> CELLIENT_PRODUCT_MEN200) },
> >>>> +	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
> >>>> +	  .driver_info = RSVD(1) | RSVD(4) },
> >>>
> >>> Would you mind posting the output of "lsusb -v" for this device?
> >>
> >> I would like to, but unfortunately I lost access to this really rare hardware
> >> about a month ago. It is a Qualcomm device (0x05c6:0x9025) with a slightly
> >> modified firmware to rebrand it as a Cellient product with a different vendor
> >> id. How to proceed here, if I have no access to it anymore? Drop it?
> > 
> > No, that's ok, I've applied the patch now. It's just that in case we
> > ever need to revisit the handling of quirky devices, it has proven
> > useful to have a record the descriptors.
> > 
> > Do you remember the interface layout and why you blacklisted interface
> > 1?
> > 
> > Johan
> > 
> 
> It is very likely that Cellient has replaced the VID with their own and 
> kept the PID, it is something other mfgrs has done when buying modules 
> from Qualcomm's series of devices with predefined composition.
> 
> The MS Windows driver for 05c6:9025 describes the interfaces as:
> 
> MI_00 Qualcomm HS-USB Diagnostics 9025
> MI_01 Android Composite ADB Interface
> MI_02 Qualcomm HS-USB Android Modem 9025
> MI_03 Qualcomm HS-USB NMEA 9025
> MI_04 Qualcomm Wireless HS-USB Ethernet Adapter 9025
> MI_05 USB Mass Storage Device
> 
> where the net interface is for QMI/RMNET.
> It fully matches the blacklisting Wilken has done for 2692:9025

Does your device have a GPS connector? Mine had not and I'm not sure
if the description of MI_01 is actually correct. I remember looking at
this port and seeing bogus NMEA data.

greetings,
Will
