Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23513B7448
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 09:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfISHgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 03:36:52 -0400
Received: from smtp3.goneo.de ([85.220.129.37]:60700 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfISHgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 03:36:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id BCF6723F7E9;
        Thu, 19 Sep 2019 09:36:48 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.028
X-Spam-Level: 
X-Spam-Status: No, score=-3.028 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.128, BAYES_00=-1.9] autolearn=ham
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PLrzwm4_few9; Thu, 19 Sep 2019 09:36:47 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPSA id C971823F86D;
        Thu, 19 Sep 2019 09:36:46 +0200 (CEST)
Date:   Thu, 19 Sep 2019 09:36:40 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Simon Horman <horms@verge.net.au>
Cc:     Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v7 1/7] nfc: pn533: i2c: "pn532" as dt compatible string
Message-ID: <20190919073639.GA26517@lem-wkst-02.lemonage>
References: <20190910093129.1844-1-poeschel@lemonage.de>
 <20190918123457.wg6mtygr6cboqsp6@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918123457.wg6mtygr6cboqsp6@verge.net.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 02:34:57PM +0200, Simon Horman wrote:
> On Tue, Sep 10, 2019 at 11:31:21AM +0200, Lars Poeschel wrote:
> > It is favourable to have one unified compatible string for devices that
> > have multiple interfaces. So this adds simply "pn532" as the devicetree
> > binding compatible string and makes a note that the old ones are
> > deprecated.
> 
> Do you also need to update
> Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt
> to both document the new compat string and deprecate the old ones?

Simon, thank you for this hint.
The patch 2/7 adds a seperate binding doc, that contains the info about
the deprecated compat strings. But I think this is not the way to go. I
will change the patch 2/7 to update the info
Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt
instead, rename it to pn532.txt and do not add a new binding doc.

