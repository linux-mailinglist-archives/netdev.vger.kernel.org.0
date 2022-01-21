Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21F49659A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiAUT2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiAUT2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:28:51 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5310DC06173B;
        Fri, 21 Jan 2022 11:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=5Rto3uScPhoQz+ANP90QDAtL8pw87Qal3oKsCCdk+fo=;
        t=1642793331; x=1644002931; b=DwRmdrDurqFbA99uRI5rSK6ptNjgZDDZA8GvIYhxxmP2fZ+
        or2FVZ3lftTxT5DsymLnh6JSEHDony4+opFDEpjVFt1XKf01KTG09+2BXNjGVjWbsNkvz0pbxmni2
        vApGQ0FIpc/D0K6DwZaHP54niOKxRzrhEOyj4iUtjaUvgMEHYrac2KGRPrMyzC3UDbrQw0qiH9BB/
        4/6vNRuWu1l7mdAi6yHzfa0oQivq1xmP6cGLqob5VFW8cepuYlBl04lyEj8OtAxPV3TPtSrOu1AM7
        9I90OO2uERXQzGCmpjPGX18YE9f7EVAo+GGPz4daQLU2lPCBTsoVph5xXOyv+QZA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nAzaX-008ap4-5S;
        Fri, 21 Jan 2022 20:28:45 +0100
Message-ID: <25f2b7aad73e65a38c6203c400425c2489332dec.camel@sipsolutions.net>
Subject: Re: [PATCH 27/31] net: mac80211 : changing LED_* from enum
 led_brightness to actual value
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luiz Sampaio <sampaio.ime@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Fri, 21 Jan 2022 20:28:44 +0100
In-Reply-To: <20220121165436.30956-28-sampaio.ime@gmail.com>
References: <20220121165436.30956-1-sampaio.ime@gmail.com>
         <20220121165436.30956-28-sampaio.ime@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-01-21 at 13:54 -0300, Luiz Sampaio wrote:
> The enum led_brightness, which contains the declaration of LED_OFF,
> LED_ON, LED_HALF and LED_FULL is obsolete, as the led class now supports
> max_brightness.
> 

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

and particularly

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_messages

would be a good thing to read.

Also, clearly you need to actually sign off your patches:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#developer-s-certificate-of-origin-1-1

(but yeah read the entire page)

Anyway, I'm with the other comments - what's the point in replacing
things like "LED_FULL" with arbitrary "255". I guess your commit message
should explain that, I don't see how it really is so obviously
"obsolete" that this needs no more comments.

johannes
