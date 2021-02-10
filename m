Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B9316A0A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBJPYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:24:43 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:49472 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhBJPYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:24:42 -0500
Received: from [51.148.178.73] (port=60078 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l9rLK-00E2eo-Mm; Wed, 10 Feb 2021 15:23:50 +0000
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com> <20210204113121.29786-2-john.efstathiades@pebblebay.com> <YBv4VVhsswYtX6qc@lunn.ch>
In-Reply-To: <YBv4VVhsswYtX6qc@lunn.ch>
Subject: RE: [PATCH net-next 1/9] lan78xx: add NAPI interface support
Date:   Wed, 10 Feb 2021 15:23:30 -0000
Organization: Pebble Bay Consulting Ltd
Message-ID: <004601d6ffc0$bbf46c90$33dd45b0$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIpfIuWVWp4oXxuaZJopfPMH/GLnQECyV9lAv5icKSpjHpHoA==
Content-Language: en-gb
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies for taking a while to reply.

> This patch is big. Given your description, it sounds like it can be
> split up. That will make reviewing a lot easier.

The patch changes the way the driver works in a fundamental way so finding
ways to split out the modifications into self-contained parts might be
tricky. I need to discuss with colleagues on how to best do this.

If that's not possible or results in some ugly patches do you have any
suggestions how we can make it easier for reviewers to understand and review
the patch?
 
> It would also be nice to include in the 0/X patch some performance
> data.

Yes, I can do that.

Thanks for the other comments. I'll sort out the issues before preparing an
update but it will take a few weeks to re-test the driver and prepare a new
patch.

John



