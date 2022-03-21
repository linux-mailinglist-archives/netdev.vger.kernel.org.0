Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3644E3038
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349161AbiCUSrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245651AbiCUSrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:47:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9133418CD10;
        Mon, 21 Mar 2022 11:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ND0CyLOksMKLoLHkfiRM/zDxGgGCQtwvO69imfnDR/A=;
        t=1647888382; x=1649097982; b=km2OoQavlws8NDplM6TIywHBllg6MChUFRs3PbyBvILBzIp
        RhfRKY4YcyFJTSZmGC3fT40XtJNF+bO1e6oVeSLBR6KXD+oQhfB2608HaLS02AMFLuvqRRi9/hudz
        R/cTtKf5+JjI5xbDOOGX0XieFYoflmXFI8XMQwd6W9kPm+7vklmagh6E+eFulQom+xE9UacS4OTc6
        +irrowJ1d6XhtiClDuhU+8L3FXX1mP5GIBmoXFQf3Zjp6votiOYmOurUElFTm+PQkBvsjuHFjHlLl
        KrQEpDAm/tSrNTWx9U+mx61KHXCduHI2cg3mK2i8Maa2gLNyFJTT6ST0mCyJ+2rA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nWN2j-00GJa0-0V;
        Mon, 21 Mar 2022 19:46:13 +0100
Message-ID: <70eeaa305a32e5e59759713ba842640ffb21956a.camel@sipsolutions.net>
Subject: Re: net-next: regression: patch "iwlwifi: acpi: move ppag code from
 mvm to fw/acpi" (e8e10a37c51c) breaks wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Matt Chen <matt.chen@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Luca Coelho <luca@coelho.fi>
Date:   Mon, 21 Mar 2022 19:46:11 +0100
In-Reply-To: <20220318102100.7dfeeced@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
         <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
         <20220318102100.7dfeeced@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2022-03-18 at 10:21 -0700, Jakub Kicinski wrote:
> 
> Hi Johannes, we're readying up for the merge window, feels like this
> may be something we want fixed before we ship net-next off to Linus.
> Do you have an ETA on the fix? Am I overestimating the importance?
> 
Hm, right. Depends on the machine if you need it or not!

Luca, any thoughts? Can we send out the patch quickly?

johannes
