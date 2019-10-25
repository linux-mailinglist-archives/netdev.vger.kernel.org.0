Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95528E4BFF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394597AbfJYNXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:23:39 -0400
Received: from relay-b02.edpnet.be ([212.71.1.222]:60985 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394592AbfJYNXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 09:23:38 -0400
X-ASG-Debug-ID: 1572009816-0a7b8d13c0fbc5e0001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (77.109.77.221.static.edpnet.net [77.109.77.221]) by relay-b02.edpnet.be with ESMTP id 7J0zprRRSY4Qgw0z; Fri, 25 Oct 2019 15:23:36 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.77.221.static.edpnet.net[77.109.77.221]
X-Barracuda-Apparent-Source-IP: 77.109.77.221
Received: from x1.vandijck-laurijssen.be (74.250-240-81.adsl-static.isp.belgacom.be [81.240.250.74])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 06EEFAA72A1;
        Fri, 25 Oct 2019 15:23:34 +0200 (CEST)
Date:   Fri, 25 Oct 2019 15:23:34 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, wg@grandegger.com, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] j1939: transport: make sure EOMA is send with the
 total message size set
Message-ID: <20191025132334.GB2031@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH v2] j1939: transport: make sure EOMA is send with the
 total message size set
Mail-Followup-To: Oleksij Rempel <o.rempel@pengutronix.de>,
        mkl@pengutronix.de, wg@grandegger.com, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20191025130413.1298-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191025130413.1298-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 77.109.77.221.static.edpnet.net[77.109.77.221]
X-Barracuda-Start-Time: 1572009816
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 309
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 0.9988 1.0000 4.3285
X-Barracuda-Spam-Score: 4.33
X-Barracuda-Spam-Status: No, SCORE=4.33 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.77581
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On vr, 25 okt 2019 15:04:13 +0200, Oleksij Rempel wrote:
> 
> We was sending malformed EOMA with total message size set to 0. So, fix this
> bug and add sanity check to the RX path.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
