Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AC147A013
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 10:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhLSJsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 04:48:53 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51316 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229585AbhLSJsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 04:48:53 -0500
X-Greylist: delayed 2341 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2021 04:48:53 EST
Received: from 91-156-5-105.elisa-laajakaista.fi ([91.156.5.105] helo=[192.168.100.150])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mysCT-001O2D-AV; Sun, 19 Dec 2021 11:09:49 +0200
Message-ID: <ad06fddfcc8bef222fecf69b8a9c7effd8cc9db5.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Sun, 19 Dec 2021 11:09:47 +0200
In-Reply-To: <CAMZdPi9eeVCakwQPnzvc-3BHo8ABv6=kb3VJj+FAXDZbz4R6bw@mail.gmail.com>
References: <20211207144211.A9949C341C1@smtp.kernel.org>
         <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <87tufjfrw0.fsf@codeaurora.org>
         <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <87zgpb83uz.fsf@codeaurora.org>
         <CAMZdPi9eeVCakwQPnzvc-3BHo8ABv6=kb3VJj+FAXDZbz4R6bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-08 at 17:58 +0100, Loic Poulain wrote:
> Hi Kalle,
> 
> On Wed, 8 Dec 2021 at 17:21, Kalle Valo <kvalo@kernel.org> wrote:
> > 
> > Jakub Kicinski <kuba@kernel.org> writes:
> > 
> > > On Wed, 08 Dec 2021 10:00:15 +0200 Kalle Valo wrote:
> > > > Jakub Kicinski <kuba@kernel.org> writes:
> > > Yeah, scroll down, there is a diff of the old warnings vs new ones, and
> > > a summary of which files have changed their warning count:
> > > 
> > > +      2 ../drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > > +      3 ../drivers/net/wireless/intel/iwlwifi/mei/main.c
> > > -      1 ../drivers/net/wireless/intel/iwlwifi/mvm/ops.c
> > > +      2 ../drivers/net/wireless/intel/iwlwifi/mvm/ops.c
> > > -      2 ../drivers/net/wireless/microchip/wilc1000/wlan.c
> > 
> > Ah, that makes it easier.
> > 
> > > So presumably these are the warnings that were added:
> > > 
> > > drivers/net/wireless/intel/iwlwifi/mei/main.c:193: warning: cannot
> > > understand function prototype: 'struct '
> > > drivers/net/wireless/intel/iwlwifi/mei/main.c:1784: warning: Function
> > > parameter or member 'cldev' not described in 'iwl_mei_probe'
> > > drivers/net/wireless/intel/iwlwifi/mei/main.c:1784: warning: Function
> > > parameter or member 'id' not described in 'iwl_mei_probe'
> > 
> > Luca, please take a look and send a patch. I'll then apply it directly
> > to wireless-drivers-next.

Kalle, as we agreed, I sent 4 patches fixes this errors/warnings in
iwlwifi.

--
Cheers,
Luca.
