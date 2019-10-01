Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7279DC35FC
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 15:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388634AbfJANkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 09:40:01 -0400
Received: from relay-b02.edpnet.be ([212.71.1.222]:34888 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfJANkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 09:40:01 -0400
X-ASG-Debug-ID: 1569937198-0a7b8d53c1e88220001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (77.109.119.18.adsl.dyn.edpnet.net [77.109.119.18]) by relay-b02.edpnet.be with ESMTP id IODp9MwrRJmoWr37; Tue, 01 Oct 2019 15:39:58 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.119.18.adsl.dyn.edpnet.net[77.109.119.18]
X-Barracuda-Apparent-Source-IP: 77.109.119.18
Received: from x1.vandijck-laurijssen.be (74.250-240-81.adsl-static.isp.belgacom.be [81.240.250.74])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 555E6A1ED6B;
        Tue,  1 Oct 2019 15:39:57 +0200 (CEST)
Date:   Tue, 1 Oct 2019 15:39:56 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Jeroen Hofstee <jhofstee@victronenergy.com>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] can: D_CAN: perform a sofware reset on open
Message-ID: <20191001133956.GB32369@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH 1/2] can: D_CAN: perform a sofware reset on open
Mail-Followup-To: Jeroen Hofstee <jhofstee@victronenergy.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190926085005.24805-1-jhofstee@victronenergy.com>
 <20190926085005.24805-2-jhofstee@victronenergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190926085005.24805-2-jhofstee@victronenergy.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 77.109.119.18.adsl.dyn.edpnet.net[77.109.119.18]
X-Barracuda-Start-Time: 1569937198
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 627
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 0.9475 1.0000 3.7440
X-Barracuda-Spam-Score: 4.74
X-Barracuda-Spam-Status: No, SCORE=4.74 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=BSF_SC2_SA016_OB
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.77000
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        1.00 BSF_SC2_SA016_OB       Custom Rule SA016_OB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On do, 26 sep 2019 08:50:44 +0000, Jeroen Hofstee wrote:
> When the C_CAN interface is closed it is put in power down mode, but
> does not reset the error counters / state. So reset the D_CAN on open,
> so the reported state and the actual state match.
> 
> According to [1], the C_CAN module doesn't have the software reset.
> 
> [1] http://www.bosch-semiconductors.com/media/ip_modules/pdf_2/c_can_fd8/users_manual_c_can_fd8_r210_1.pdf
> 
> Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>

I observed no problems after applying the patch.

Tested-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
