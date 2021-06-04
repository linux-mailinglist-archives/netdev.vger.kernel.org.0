Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E52239B586
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 11:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFDJLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 05:11:32 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:37209 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhFDJLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 05:11:32 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id C8F9AC74FD;
        Fri,  4 Jun 2021 09:09:44 +0000 (UTC)
Received: (Authenticated sender: hadess@hadess.net)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 14349FF804;
        Fri,  4 Jun 2021 09:09:19 +0000 (UTC)
Message-ID: <1fc00ee63fcb2be29148e33be1f013a154caf287.camel@hadess.net>
Subject: Re: [PATCH v3 1/3] Bluetooth: use inclusive language in HCI role
 comments
From:   Bastien Nocera <hadess@hadess.net>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Date:   Fri, 04 Jun 2021 11:09:19 +0200
In-Reply-To: <CAJQfnxHtgsCTS5GCTj-p4iqaR=jZVPho1ELgFQ6-UngZcBECig@mail.gmail.com>
References: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
         <fc36d07a8f148a45c61225fefdd440313ee723d0.camel@hadess.net>
         <CAJQfnxHtgsCTS5GCTj-p4iqaR=jZVPho1ELgFQ6-UngZcBECig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-06-04 at 16:56 +0800, Archie Pusaka wrote:
> Hi Bastien,
> 
> Thanks! That was a great input.
> I'm not sure though, do we have a standard, proper way to deprecate
> macros?
> Or does a simple /* deprecated */ comment works for now?

I think we might need to add #ifdef around those instead unfortunately,
something like "#ifndef BLUETOOTH_NO_DEPRECATED_CONSTANTS" around the
old names.

> 
> Cheers,
> Archie
> 
> 
> On Fri, 4 Jun 2021 at 16:39, Bastien Nocera <hadess@hadess.net>
> wrote:
> > 
> > On Fri, 2021-06-04 at 16:26 +0800, Archie Pusaka wrote:
> > > 
> > > The #define preprocessor terms are unchanged for now to not
> > > disturb
> > > dependent APIs.
> > 
> > Could we add new defines, and deprecate the old ones? Something
> > akin
> > to that would help migrate the constants, over time:
> > https://gitlab.gnome.org/GNOME/glib/blob/master/glib/gmacros.h#L686-716
> > 


