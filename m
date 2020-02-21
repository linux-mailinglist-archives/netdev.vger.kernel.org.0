Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AC8167DA0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBUMlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:41:31 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59042 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgBUMlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 07:41:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j57cU-00FGMO-BX; Fri, 21 Feb 2020 13:41:26 +0100
Message-ID: <1cbc48003d249d3ce14941adbb32089b57573cd0.camel@sipsolutions.net>
Subject: Re: [PATCH 09/10] cfg80211: align documentation style of
 ieee80211_iface_combination
From:   Johannes Berg <johannes@sipsolutions.net>
To:     =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Date:   Fri, 21 Feb 2020 13:41:24 +0100
In-Reply-To: <10411162.7U3r8zC6Ku@pc-42>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
         <20200221115604.594035-9-Jerome.Pouiller@silabs.com>
         <bc10669e0572d69d22ee7ca67a19c7d03bacd6ed.camel@sipsolutions.net>
         <10411162.7U3r8zC6Ku@pc-42>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-02-21 at 12:38 +0000, Jérôme Pouiller wrote:
> 
> > > -      * = 0
> > > -      *   all beacon intervals for different interface must be same.
> > > -      * > 0
> > > -      *   any beacon interval for the interface part of this combination AND
> > > -      *   GCD of all beacon intervals from beaconing interfaces of this
> > > -      *   combination must be greater or equal to this value.
> > 
> > This generates the nicer output, not with bullets but as a definition
> > list or something.
> Indeed.
> 
> Unfortunately, I hasn't been able to use the same syntax in struct
> description: if sphinx find a blank line, it considers that the rest of
> the input is the long description of the struct.

So let's just leave it as is. I don't consider using the same style
(inline or header) everywhere to be even nearly as important as the
output :)

johannes

