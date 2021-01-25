Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF0304A5B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbhAZFFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbhAYNEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:04:10 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC7FC061574;
        Mon, 25 Jan 2021 05:03:29 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l41We-00BQHR-Da; Mon, 25 Jan 2021 14:03:24 +0100
Message-ID: <69ff7946c0068ffdaa63a6f28626b7a07b9c18b6.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-01-18.2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Hans de Goede <hdegoede@redhat.com>,
        "Peer, Ilan" <ilan.peer@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Date:   Mon, 25 Jan 2021 14:03:23 +0100
In-Reply-To: <92c434bd-bf79-2b49-2a0a-8e538d55551c@redhat.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
         <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
         <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
         <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
         <348210d8-6940-ca8d-e3b1-f049330a2087@redhat.com>
         <666b3449fe33d34123255cc69da3aa46fc276dcb.camel@sipsolutions.net>
         <6c949dbe-5593-2274-7099-c2768b770aad@redhat.com>
         <671b0c37867803d7229ef0c4a33baf2c7778df08.camel@sipsolutions.net>
         <92c434bd-bf79-2b49-2a0a-8e538d55551c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-25 at 13:59 +0100, Hans de Goede wrote:

> Yes this fixes things, thank you that saves me from having to debug
> the NULL ptr deref.

:)

> Do you want to submit this to Greg, or shall I (I've already
> added it to me local tree as a commit with you as the author) ?
> 
> If you want me to submit it upstream, may I have / add your S-o-b
> for this ?

I'll send it out, with a note asking where it should go ... could also
take it through my tree since it fixes things from there.

johannes

