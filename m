Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC720EEE7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgF3HB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgF3HB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:01:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1A7C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:01:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jqAGV-00EeYa-Ln; Tue, 30 Jun 2020 09:01:11 +0200
Message-ID: <51efec1d1c3c8cf0c8ae9b54939e59caf23db62e.camel@sipsolutions.net>
Subject: Re: [PATCH net] genetlink: take netlink table lock when
 (un)registering
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "stranche@codeaurora.org" <stranche@codeaurora.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Tue, 30 Jun 2020 09:00:54 +0200
In-Reply-To: <8eba464937d34d8330a82332ebd672eb@codeaurora.org>
References: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
         <CAM_iQpXXdpdKvVY4G=y8=R4TsYE0ovac=OCNfiaMmD=Rgn2utQ@mail.gmail.com>
         <8eba464937d34d8330a82332ebd672eb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-29 at 20:18 +0000, stranche@codeaurora.org wrote:
> 
> Thanks Cong. Yes, removing the genl_bind()/genl_unbind() functions
> eliminates the
> potential for this deadlock. Adding Johannes here to comment on removing
> these,
> as the family->mcast_bind() capability added by commit c380d9a7afff
> ("genetlink: pass multicast bind/unbind to families") would be lost.

I really don't remember what I/we added this for, but evidently we're
not using this now, neither in-tree nor anywhere I could find in new
not-yet-in-tree code (not a surprise, given the age, that would've
landed in the tree long ago).

So:

Acked-by: Johannes Berg <johannes.berg@intel.com>

johannes

