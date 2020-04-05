Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED24619EA11
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 10:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDEIwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 04:52:12 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:45730 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbgDEIwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 04:52:12 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jL10U-000A10-JV; Sun, 05 Apr 2020 11:51:55 +0300
Message-ID: <e43fb61905bcc31f93d6e72e5c470ad5585b6dfd.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Chris Rorvick <chris@rorvick.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 05 Apr 2020 11:51:53 +0300
In-Reply-To: <87mu7qfhiy.fsf@codeaurora.org>
References: <20200402050219.4842-1-chris@rorvick.com>
         <87mu7qfhiy.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH] iwlwifi: actually check allocated conf_tlv pointer
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-04-05 at 11:44 +0300, Kalle Valo wrote:
> Chris Rorvick <chris@rorvick.com> writes:
> 
> > Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> > conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> > ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> > check correctly.
> > 
> > Tweeted-by: @grsecurity
> > Signed-off-by: Chris Rorvick <chris@rorvick.com>
> 
> I'll add:
> 
> Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
> 
> > ---
> > In this wasn't picked up?
> 
> Luca, can I take this directly?

Yes, please take it directly.  This can happen in OOM situations and,
when it does, we will potentially try to dereference a NULL pointer.

Thanks!

--
Cheers,
Luca.

