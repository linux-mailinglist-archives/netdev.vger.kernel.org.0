Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BEC15348F
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgBEPsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 10:48:42 -0500
Received: from mx1.cock.li ([185.10.68.5]:36725 "EHLO cock.li"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbgBEPsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 10:48:42 -0500
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on cock.li
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NO_RECEIVED,NO_RELAYS shortcircuit=_SCTYPE_
        autolearn=disabled version=3.4.2
Date:   Wed, 5 Feb 2020 18:48:29 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
        t=1580917711; bh=YpQAOhC6zw8KkgDRwc/Chjw22SjapGWj8KZDT6YUh08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CrlkeOUt2vM5TosW5QTQIUNJkNFcAgcUy78QQI55D0r9c/GTV8eOZ4wRe68i1xwe5
         hDO6dATizGy1uUQLiAtFrkxa+DuGVwJHF4r92yjzRQDVnn+zAJfRHvJh5AUal8cFQU
         ICfzGOy6mJaePLx3l/YRO+3kOXHF4A2Ox4HEBdG7IBGSPNsJf5rkScU1jhbC+UG1fy
         g07PjICV/5Ygf8uvwrMGvP7WpYr2J09wRuHCpaN9WHwRrlFpEfT/cTK+u2z9i4d9l7
         8a4eZrntBmoQOP2WdCrcwB9KZCMvLNPm7a7CFyt6nIp8TNWXnLy9YPs0Qdh0+JmMW6
         kep5BFc6A/2rA==
From:   l29ah@cock.li
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] 9pnet: allow making incomplete read requests
Message-ID: <20200205154829.wbgdp2r4gslnozpa@l29ah-x201.l29ah-x201>
References: <20200205003457.24340-1-l29ah@cock.li>
 <20200205073504.GA16626@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205073504.GA16626@nautica>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 08:35:04AM +0100, Dominique Martinet wrote:
> Sergey Alirzaev wrote on Wed, Feb 05, 2020:
> > A user doesn't necessarily want to wait for all the requested data to
> > be available, since the waiting time is unbounded.
> 
> I'm not sure I agree on the argument there: the waiting time is
> unbounded for a single request as well. What's your use case?

I want to interface with synthetic file systems that represent arbitrary data streams.
The one where i've hit the problem is reading the log of a XMPP chat client that blocks if there's no new data available.

-- 
()  ascii ribbon campaign - against html mail
/\  http://arc.pasp.de/   - against proprietary attachments
