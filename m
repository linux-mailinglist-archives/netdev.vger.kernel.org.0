Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54664C35E0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388591AbfJANho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 09:37:44 -0400
Received: from relay-b03.edpnet.be ([212.71.1.220]:50795 "EHLO
        relay-b03.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387564AbfJANhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 09:37:43 -0400
X-ASG-Debug-ID: 1569937057-0a88186e2343f92e0001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (77.109.119.18.adsl.dyn.edpnet.net [77.109.119.18]) by relay-b03.edpnet.be with ESMTP id lhxlEiytuwtOONF6; Tue, 01 Oct 2019 15:37:37 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.119.18.adsl.dyn.edpnet.net[77.109.119.18]
X-Barracuda-Apparent-Source-IP: 77.109.119.18
Received: from x1.vandijck-laurijssen.be (74.250-240-81.adsl-static.isp.belgacom.be [81.240.250.74])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id D7800A1ED53;
        Tue,  1 Oct 2019 15:37:36 +0200 (CEST)
Date:   Tue, 1 Oct 2019 15:37:35 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] can: C_CAN: add bus recovery events
Message-ID: <20191001133735.GA32369@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH 2/2] can: C_CAN: add bus recovery events
Mail-Followup-To: Jeroen Hofstee <jhofstee@victronenergy.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190926085005.24805-1-jhofstee@victronenergy.com>
 <20190926085005.24805-3-jhofstee@victronenergy.com>
 <20191001074057.GA28813@x1.vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191001074057.GA28813@x1.vandijck-laurijssen.be>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 77.109.119.18.adsl.dyn.edpnet.net[77.109.119.18]
X-Barracuda-Start-Time: 1569937057
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 685
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 0.9980 1.0000 4.3191
X-Barracuda-Spam-Score: 4.32
X-Barracuda-Spam-Status: No, SCORE=4.32 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.77000
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On di, 01 okt 2019 09:40:57 +0200, Kurt Van Dijck wrote:
> On do, 26 sep 2019 08:50:51 +0000, Jeroen Hofstee wrote:
> > While the state is update when the error counters increase and decrease,
> > there is no event when the bus recovers and the error counters decrease
> > again. So add that event as well.
> > 
> > Change the state going downward to be ERROR_PASSIVE -> ERROR_WARNING ->
> > ERROR_ACTIVE instead of directly to ERROR_ACTIVE again.
> 
> This looks like a proper thing to do
> Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>

Thanks for this, now I see when the bus is normal again.

Tested-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
