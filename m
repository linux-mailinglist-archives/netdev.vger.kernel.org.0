Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F1728354D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 14:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgJEMCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 08:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJEMCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 08:02:50 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7355AC0613CE;
        Mon,  5 Oct 2020 05:02:50 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4C4fP256txzKmXF;
        Mon,  5 Oct 2020 14:02:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1601899363; bh=pih6XgYDkh
        l48V+BsdGHAYaFoA2g7od1ZzQAq6LaM3s=; b=bZNQL9/M/c46lCFj+XsdjFomlb
        G98zlxnUJks+QKFqtFg0oplTkuqy9pTZgW3W8PfC1zkk02ZvN+aThC44fMgoDc9o
        6EaqjNlsGEVFwS1VSCxm07yb1zs/e3XaAZv2+Ab+LXKSpsfJiXX/2xGb8dTRxTuO
        NG7WHbN/Yc7s8Jpq1dgXKD4LjYDN+u37mktqx/SHcE2t7NPfevUYDN8c4NDLp55V
        j04414kXIDG+Tn+MHCAgiRp92Co4cW4AI7K6u3y/zHSpWh4EhOPvOqzPEpuX9lfm
        xsqUzF0EQqtFWC0a/uW4SHbA+JIxc+Ty3gjKUcLI8Ly1NUl2P//Fdj5PEyuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601899364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mUslHDM4D0qu0GiOwSg49uvZ9RTQWIl97TGFJy+Ih0E=;
        b=nUQMiglFZLtrGqPlmNGbErRmOJql+THZNLU0KNInbb+ndEz3EXGMWHC9TkPj6710kqcaI5
        HjdiOpUYUAeV1rrJ2dnfkhCIN1qcQGfLuk91tvicdGR5PFifOkL0gYeQ0rQLh7GQ/wbXPd
        LlVuvkXRPAsnqY4dWvrPjEYCfQq902hPva0gE5oK1ShuUcxClrDOIaBjQOJsLPfBsNlG4L
        1B3Rrc/zU+dLzB6eShCy9dr2nC0vvttsm/nMqktvOQfh84C8Hi8OZtr0YdXLHjt+OnjeRX
        EQO3134kIX8hm+zhHXuCQgzCpi68n+7ETo4aZ8E/vZDXpa2oVUR6USHWv+FrKw==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id RgbikclqFlhw; Mon,  5 Oct 2020 14:02:43 +0200 (CEST)
Date:   Mon, 5 Oct 2020 14:02:41 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201005140241.54fcd211@monster.powergraphx.local>
In-Reply-To: <20201005110638.GP5141@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
        <20201005082045.GL5141@localhost>
        <20201005130134.459b4de9@monster.powergraphx.local>
        <20201005110638.GP5141@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.96 / 15.00 / 15.00
X-Rspamd-Queue-Id: 84BFD17F1
X-Rspamd-UID: 40de2a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Oct 2020 13:06:38 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Mon, Oct 05, 2020 at 01:01:34PM +0200, Wilken Gottwalt wrote:
> > On Mon, 5 Oct 2020 10:20:45 +0200
> > Johan Hovold <johan@kernel.org> wrote:
> > 
> > > On Sat, Oct 03, 2020 at 11:40:29AM +0200, Wilken Gottwalt wrote:
> > > > Add usb ids of the Cellient MPL200 card.
> > > > 
> > > > Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> > > > ---
> 
> > > > @@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
> > > >  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2,
> > > > 0xff, 0x02, 0x01) }, { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> > > > MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) }, { USB_DEVICE(CELLIENT_VENDOR_ID,
> > > > CELLIENT_PRODUCT_MEN200) },
> > > > +	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
> > > > +	  .driver_info = RSVD(1) | RSVD(4) },
> > > 
> > > Would you mind posting the output of "lsusb -v" for this device?
> > 
> > I would like to, but unfortunately I lost access to this really rare hardware
> > about a month ago. It is a Qualcomm device (0x05c6:0x9025) with a slightly
> > modified firmware to rebrand it as a Cellient product with a different vendor
> > id. How to proceed here, if I have no access to it anymore? Drop it?
> 
> No, that's ok, I've applied the patch now. It's just that in case we
> ever need to revisit the handling of quirky devices, it has proven
> useful to have a record the descriptors.
> 
> Do you remember the interface layout and why you blacklisted interface
> 1?

If I remember correctly this interface belongs to the GPS data, but the
card itself has no connector for a GPS antenna. The NMEA protocol data
there were bogus values. I'm not sure if there is a hardware revision
which has the connector, but the firmware seems to support it. Interface
4 is the qmi endpoint for sure. The other endpoints are Hayes protocol
and diag.

greetings,
Will
