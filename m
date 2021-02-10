Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACE8316ACA
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhBJQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:12:25 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:40310 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBJQMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:12:18 -0500
Received: from [51.148.178.73] (port=65008 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l9s5R-00EyLe-Md; Wed, 10 Feb 2021 16:11:29 +0000
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Jesse Brandeburg'" <jesse.brandeburg@intel.com>
Cc:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>    <20210204113121.29786-2-john.efstathiades@pebblebay.com> <20210204124314.00007907@intel.com>
In-Reply-To: <20210204124314.00007907@intel.com>
Subject: RE: [PATCH net-next 1/9] lan78xx: add NAPI interface support
Date:   Wed, 10 Feb 2021 16:11:09 -0000
Organization: Pebble Bay Consulting Ltd
Message-ID: <005101d6ffc7$6409d8b0$2c1d8a10$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIpfIuWVWp4oXxuaZJopfPMH/GLnQECyV9lAbFJeiOpluv9sA==
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

Apologies for taking a while to respond.

> -----Original Message-----
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Sent: 04 February 2021 20:43
> 
> NB: I thought I'd have a close look at this since I thought I
> understand NAPI pretty well, but using NAPI to transmit frames as well
> as with a usb device has got me pretty confused. 

I'll try to add some more rationale in the next revision of the patch.
However, the short answer is that using NAPI for transmit under high load is
the most effective way of getting the frames into the device's internal
buffer RAM.

> Also, I suspect that
> you didn't try compiling this against the net-next kernel.

I thought I had but it appears not. I won't let that happen again.

> I'm stopping my review only partially completed, please address issues
> https://patchwork.kernel.org/project/netdevbpf/patch/20210204113121.29786-
> 2-john.efstathiades@pebblebay.com/

Thanks, will do, but it will take me a few weeks to sort everything out due
to my other commitments.

> It might make it easier for reviewers to split the "infrastructure"
> refactors this patch uses into separate pieces. I know it is more work
> and this is tested already by you, but this is a pretty complicated
> chunk of code to review.

I appreciate this is a complicated patch, a point made by another reviewer. 
Could you explain what you mean by "infrastructure" refactors, please?

I'll certainly look at how to split this patch into smaller chunks but that
might be quite hard to do.

If that turns out not to possible, do you have any suggestions on how I can
make the patch easier for reviewers to understand and review?

John

