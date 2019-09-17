Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6554BB4C54
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfIQKzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:55:25 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:43380 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfIQKzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 06:55:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id E38D423F6EC;
        Tue, 17 Sep 2019 12:55:22 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.106
X-Spam-Level: 
X-Spam-Status: No, score=-3.106 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.206, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dKXicsz0i760; Tue, 17 Sep 2019 12:55:22 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id 6D69524013D;
        Tue, 17 Sep 2019 12:55:21 +0200 (CEST)
Date:   Tue, 17 Sep 2019 12:55:19 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     David Miller <davem@davemloft.net>
Cc:     allison@lohutok.net, keescook@chromium.org, opensource@jilayne.com,
        swinslow@gmail.com, gregkh@linuxfoundation.org,
        gustavo@embeddedor.com, tglx@linutronix.de,
        kstewart@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v7 6/7] nfc: pn533: Add autopoll capability
Message-ID: <20190917105519.GB18936@lem-wkst-02.lemonage>
References: <20190910093415.2186-1-poeschel@lemonage.de>
 <20190911.101759.1557703938346599792.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911.101759.1557703938346599792.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:17:59AM +0200, David Miller wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> Date: Tue, 10 Sep 2019 11:34:12 +0200
> 
> > +static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
> > +			       struct sk_buff *resp)
> > +{
> > +	u8 nbtg;
> > +	int rc;
> > +	struct pn532_autopoll_resp *apr;
> > +	struct nfc_target nfc_tgt;
> 
> Need reverse christmas tree here.

See below.

> > @@ -1534,6 +1655,7 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
> >  	struct pn533_poll_modulations *cur_mod;
> >  	u8 rand_mod;
> >  	int rc;
> > +	struct sk_buff *skb;
> 
> Likewise.

I will do a v8 with these changes soon.
