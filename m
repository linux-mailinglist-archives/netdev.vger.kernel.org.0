Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E1E461077
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 09:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349174AbhK2Ivv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 03:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240525AbhK2Its (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 03:49:48 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC48C061378;
        Mon, 29 Nov 2021 00:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=BcgNBJ9HP80YhdHS2G7Gf7ThE36M72dxztlVKZ+y/iA=;
        t=1638174905; x=1639384505; b=s9kg7p3UkUuprvBiw0y/Vz0NL+LOtTyi12e0mTory9EubXC
        x9/iA9iOauQoAemGCSo52IcvhpyIlnO8BouPIq2LoFfHPrfLRvdYHXDukgmqq3bZYXP0CtaMiIzMG
        jATNTXepzSaGYecpVgii/02jcWr9JaFeDXvd0/c7cBBeX78xqQmTrMZFFDnBSWiX/O7QcNL/s8wL8
        jdcvWQaxvg49bI8kR716zVD8sGBvF63HFEC6Ym9YVaE1sRdo+ymMPkdRgovB1HRvD4NOVUxspi1v7
        DZlnLC12V5+3g4SxN9QIbdUxncgtKqzI16hQ/QtHwl6i8Ax0lfhUy/WsdrD+oJ+g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mrc7i-004LRT-Or;
        Mon, 29 Nov 2021 09:34:54 +0100
Message-ID: <e257568948a1af079275df1a904ae04805ead4c7.camel@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: minstrel_ht: do not set RTS/CTS flag for
 fallback rates
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Peter Seiderer <ps.report@gmx.net>, Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 29 Nov 2021 09:34:53 +0100
In-Reply-To: <20211126152558.4d9fbce3@gmx.net>
References: <20211116212828.27613-1-ps.report@gmx.net>
         <e098a58a-8ec0-f90d-dbc9-7b621e31d051@nbd.name>
         <20211126152558.4d9fbce3@gmx.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-11-26 at 15:25 +0100, Peter Seiderer wrote:
> 
> > 
> > If you don't want this behavior, I'm fine with adding a way to
> > explicitly disable it. However, I do think leaving it on by default
> > makes sense.
> 
> I expected this (as otherwise the flag setting would not be there) ;-)
> 

To be fair, that setting (RTS threshold) has been there for 20 years or
more, and comes from a much simpler time when the reasoning for RTS/CTS
was mostly about hidden stations, not about protecting the transmissions
from older clients that don't understand the newer PHY protocols, etc.

johannes
