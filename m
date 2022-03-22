Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420644E3ECF
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiCVMxq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Mar 2022 08:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiCVMxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 08:53:45 -0400
X-Greylist: delayed 1798 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 05:52:16 PDT
Received: from farmhouse.coelho.fi (paleale.coelho.fi [176.9.41.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BD923BE4
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:52:16 -0700 (PDT)
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=[192.168.100.150])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <luca@coelho.fi>)
        id 1nWdWL-000d3J-Fx;
        Tue, 22 Mar 2022 14:21:56 +0200
Message-ID: <83804cd944bbdbdf205f1629ec8b968cd24df171.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Matt Chen <matt.chen@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Date:   Tue, 22 Mar 2022 14:21:52 +0200
In-Reply-To: <70eeaa305a32e5e59759713ba842640ffb21956a.camel@sipsolutions.net>
References: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
         <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
         <20220318102100.7dfeeced@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <70eeaa305a32e5e59759713ba842640ffb21956a.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.43.3-1+b1 
MIME-Version: 1.0
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
Subject: Re: net-next: regression: patch "iwlwifi: acpi: move ppag code from
 mvm to fw/acpi" (e8e10a37c51c) breaks wifi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-21 at 19:46 +0100, Johannes Berg wrote:
> Hi,
> 
> On Fri, 2022-03-18 at 10:21 -0700, Jakub Kicinski wrote:
> > 
> > Hi Johannes, we're readying up for the merge window, feels like this
> > may be something we want fixed before we ship net-next off to Linus.
> > Do you have an ETA on the fix? Am I overestimating the importance?
> > 
> Hm, right. Depends on the machine if you need it or not!
> 
> Luca, any thoughts? Can we send out the patch quickly?

Hmmm, I think we should get it in asap.  Not all machines will have
this issue, but the ones that do will not have a working WiFi...

I'll send Miri's patch that fixes this issue soon.

--
Cheers,
Luca.
