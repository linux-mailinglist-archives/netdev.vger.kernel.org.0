Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699831824B3
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbgCKWVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:21:49 -0400
Received: from balrog.mythic-beasts.com ([46.235.227.24]:50643 "EHLO
        balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbgCKWVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:21:49 -0400
Received: from [146.90.33.204] (port=40436 helo=slartibartfast.quignogs.org.uk)
        by balrog.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <peter@bikeshed.quignogs.org.uk>)
        id 1jC9jT-0006iO-6N; Wed, 11 Mar 2020 22:21:47 +0000
Subject: Re: [PATCH 1/1] Reformat return value descriptions as ReST lists.
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
References: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
 <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
 <20200311203817.GT25745@shell.armlinux.org.uk>
From:   Peter Lister <peter@bikeshed.quignogs.org.uk>
Organization: Quignogs! (Bikeshed)
Message-ID: <db5f6d8f-beb0-b9bd-e47d-2a8e3dd513a2@bikeshed.quignogs.org.uk>
Date:   Wed, 11 Mar 2020 22:21:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311203817.GT25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-BlackCat-Spam-Score: 14
X-Spam-Status: No, score=1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

> Is this really necessary?  This seems to be rather OTT, and makes the
> comment way too big IMHO.

The existing form definitely gets the formatted output wrong (I'll send 
you a screen grab if you like) and causes doc build warnings. So, yes, 
it needs fixing.

ReST makes free with blank lines round blocks and list entries, and I 
agree this makes for inelegant source annotation. I tried to retain the 
wording unchanged and present the description as just "whitespace" 
changes to make a list in the formatted output - as close as I could to 
what the author appears to intend.

If you're OK with a mild rewrite of the return value description, e.g. 
as two sentences (On success: p; q. On failure: x; y; z.), then we can 
fix the doc build and have terser source comments and a happier kerneldoc.

All the best,

Peter Lister

