Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B68167D08
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBUMCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:02:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:58304 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgBUMCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 07:02:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j570O-00FBK8-Bv; Fri, 21 Feb 2020 13:02:04 +0100
Message-ID: <bc10669e0572d69d22ee7ca67a19c7d03bacd6ed.camel@sipsolutions.net>
Subject: Re: [PATCH 09/10] cfg80211: align documentation style of
 ieee80211_iface_combination
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Date:   Fri, 21 Feb 2020 13:02:03 +0100
In-Reply-To: <20200221115604.594035-9-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
         <20200221115604.594035-9-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-02-21 at 12:56 +0100, Jerome Pouiller wrote:
> 
> + *	intervals:
> + *	    * = 0: all beacon intervals for different interface must be same.
> + *	    * > 0: any beacon interval for the interface part of this
> + *	      combination AND GCD of all beacon intervals from beaconing
> + *	      interfaces of this combination must be greater or equal to this
> + *	      value.

Hmm. I have a feeling I actually split this one out because

> -	 * = 0
> -	 *   all beacon intervals for different interface must be same.
> -	 * > 0
> -	 *   any beacon interval for the interface part of this combination AND
> -	 *   GCD of all beacon intervals from beaconing interfaces of this
> -	 *   combination must be greater or equal to this value.

This generates the nicer output, not with bullets but as a definition
list or something.

johannes

