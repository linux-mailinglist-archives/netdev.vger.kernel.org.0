Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F0F281D49
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgJBVAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBVAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 17:00:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D10FC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 14:00:18 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOSA4-00FSmY-Fc; Fri, 02 Oct 2020 23:00:16 +0200
Message-ID: <6adbdd333e2db1ab9ac8f08e8ad3263d43bde55e.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Date:   Fri, 02 Oct 2020 23:00:15 +0200
In-Reply-To: <47b6644999ce2946a262d5eac0c82e33057e7321.camel@sipsolutions.net>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
         <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
         <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
         <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
         <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cc9594d16270aeb55f9f429a234ec72468403b93.camel@sipsolutions.net>
         <20201002135059.1657d673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <47b6644999ce2946a262d5eac0c82e33057e7321.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 22:59 +0200, Johannes Berg wrote:
> On Fri, 2020-10-02 at 13:50 -0700, Jakub Kicinski wrote:
> > My thinking was that until kernel actually start using separate dump
> > policies user space can assume policy 0 is relevant. But yeah, merging
> > your changes first would probably be best.
> 
> Works for me. I have it based on yours. Just updated my branch (top
> commit is 4d5045adfe90), but I'll probably only actually email it out
> once things are a bit more settled wrt. your changes.

Forgot the link ...

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/log/?h=genetlink-op-policy-export

johannes

