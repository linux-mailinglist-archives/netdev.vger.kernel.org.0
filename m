Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68DF897F0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfHLHhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:37:24 -0400
Received: from smtp1.goneo.de ([85.220.129.30]:55118 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfHLHhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 03:37:24 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 03:37:23 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id 0FFD123F037;
        Mon, 12 Aug 2019 09:28:04 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.095
X-Spam-Level: 
X-Spam-Status: No, score=-3.095 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.195, BAYES_00=-1.9] autolearn=ham
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X6NG7wCyM0OW; Mon, 12 Aug 2019 09:28:03 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPSA id E38F923FA49;
        Mon, 12 Aug 2019 09:28:02 +0200 (CEST)
Date:   Mon, 12 Aug 2019 09:40:49 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PING 2] [PATCH v5 1/7] nfc: pn533: i2c: "pn532" as dt
 compatible string
Message-ID: <20190812074035.GA9797@lem-wkst-02.lemonage>
References: <20190111161812.26325-1-poeschel@lemonage.de>
 <20190228104801.GA14788@lem-wkst-02.lemonage>
 <20190403094735.GA19351@lem-wkst-02.lemonage>
 <20190805124236.GG3574@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124236.GG3574@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 02:42:36PM +0200, Johan Hovold wrote:
> You may want to resend this series to netdev now. David Miller will be
> picking up NFC patches directly from there.

Thank you very much for this information. Johannes Berg did reach out to
me already.
Rebase, test and resend is queued up for one of my next free timeslots.

Thanks again,
Lars
