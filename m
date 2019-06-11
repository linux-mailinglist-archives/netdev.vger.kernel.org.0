Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB73C627
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403862AbfFKIol convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Jun 2019 04:44:41 -0400
Received: from hilbert2.alphasky.net ([178.63.16.112]:49919 "EHLO
        hilbert2.alphasky.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403836AbfFKIol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:44:41 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2019 04:44:40 EDT
Received: from localhost (localhost [127.0.0.1])
        by hilbert.alphasky.net (Postfix) with ESMTP id 3CDE1E003B5;
        Tue, 11 Jun 2019 10:37:48 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at hilbert.alphasky.net
Received: from hilbert2.alphasky.net ([127.0.0.1])
        by localhost (hilbert.alphasky.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J42EsXcZB5s8; Tue, 11 Jun 2019 10:37:47 +0200 (CEST)
Received: from tau.familiekling.de (tau.familiekling.de [10.99.0.1])
        by delta.familiekling.de (Postfix) with ESMTPS id E189212A10AE;
        Tue, 11 Jun 2019 10:37:46 +0200 (CEST)
Received: from tau.familiekling.de (10.99.0.1) by tau.familiekling.de
 (10.99.0.1) with Microsoft SMTP Server (TLS) id 15.0.847.32; Tue, 11 Jun 2019
 10:37:46 +0200
Received: from tau.familiekling.de ([fe80::5c8e:2c3e:e113:32f7]) by
 tau.familiekling.de ([fe80::5c8e:2c3e:e113:32f7%12]) with mapi id
 15.00.0847.040; Tue, 11 Jun 2019 10:37:46 +0200
From:   Christoph Kling <christoph@kling.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
        <driverdev-devel@linuxdriverproject.org>
Subject: Re: [GIT PULL net-next, resend] isdn: deprecate non-mISDN drivers
Thread-Topic: Re: [GIT PULL net-next, resend] isdn: deprecate non-mISDN
 drivers
Thread-Index: AdUezS0NeVLicA74QvuShSLnam5txw==
Date:   Tue, 11 Jun 2019 08:37:45 +0000
Message-ID: <c4c42effac174d03b1ffdbd9dc319003@tau.familiekling.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.1.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

I'm a long time ISDN user and I cannot fully agree to the assessment of current ISDN usage. It is of course true that ISDN is no longer a main protocol for telephone connections and therefore the number of users has dropped. But still there are people with public ISDN telephone links, e.g. in Germany. Not everything has been converted into voice over ip. 

More importantly however, there are still many *private* ISDN networks. The simple reason is that beyond the public networks, there are still a lot of people who have ISDN telephone installations in their buildings. 

Those installations date from the time when many public telephone connections used ISDN. Those private ISDN telephone installations have a *very* long lifetime (> 20 years), as many people, especially individuals shy at the cost and effort to get a new internal telephone installation. A reliable indicator for that is that one of the most widespread wifi router products in Germany and beyond, AVM Fritz!Box still supports ISDN even in its most recent version (7590). 

Speaking for myself, I still use the capi based b1pci driver for active AVM cards in several installations.

Please do not base your assessment of ISDN usage on the size and number of public ISDN networks and please do not remove capi and isdn4linux support from the kernel.

Thank you for commitment to the kernel development!

Kind regards,
Christoph Kling 
