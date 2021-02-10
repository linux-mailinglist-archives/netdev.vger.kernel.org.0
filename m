Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D49316A56
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhBJPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:36:30 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:41630 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhBJPg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:36:29 -0500
Received: from [51.148.178.73] (port=61283 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l9rWj-00EFWS-R7; Wed, 10 Feb 2021 15:35:37 +0000
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com> <20210204113121.29786-8-john.efstathiades@pebblebay.com> <YBv6/zr82VZcgGMG@lunn.ch>
In-Reply-To: <YBv6/zr82VZcgGMG@lunn.ch>
Subject: RE: [PATCH net-next 7/9] lan78xx: set maximum MTU
Date:   Wed, 10 Feb 2021 15:35:17 -0000
Organization: Pebble Bay Consulting Ltd
Message-ID: <004d01d6ffc2$616f7100$244e5300$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIpfIuWVWp4oXxuaZJopfPMH/GLnQMInxISAaBq8Uyph0LKkA==
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

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: 04 February 2021 13:48
>
> >
> > This was missed in the work to add the NAPI support.
> 
> git rebase? Please squash it into the correct place.

Yes, will do.

John

