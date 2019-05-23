Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD22848E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbfEWRKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:10:04 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43614 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfEWRKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:10:04 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0619E1C007A;
        Thu, 23 May 2019 17:10:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 23 May
 2019 10:09:57 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
 <267b6dc6-b621-3278-58cf-562452d9450f@solarflare.com>
 <20190523093304.0e6230f2@cakuba.netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <15ba74a8-2fa0-6e57-cb6c-4a6e0f24e2ea@solarflare.com>
Date:   Thu, 23 May 2019 18:09:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523093304.0e6230f2@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24632.005
X-TM-AS-Result: No-5.263300-4.000000-10
X-TMASE-MatchedRID: rYpa/RC+czHmLzc6AOD8DfHkpkyUphL9APiR4btCEeY7e2YyTwFSIgFK
        sDvaUiE9y/owLDEpnFFq6DxmfNwo/aK6LSHyZV2RsFkCLeeufNvujGgmSxndolAoBBK61Bhc3HB
        fr2OH2GGBUlpoukEnmP/0a5PJRWQ959cTbDyIW7O20BbG4zmyXrCouBF2/ACKI0YrtQLsSUzEOb
        3Mgo89SLGsE+aDBEFlAHCUsCitkndf7y77NDsmYlD5LQ3Tl9H7yeUl7aCTy8h7eGs179ltWQ92y
        3TKZucESh7/WsAfq7hlvD8wsEm9tHwNn2edtXrGlTsGW3DmpUvFdEMoTK7bMT2mEJylgvfB2fXQ
        mevz4QEgV8GcLhV21W3W2DNW5B+AmDHh7m9C3Hu5kFk6DtF9fxiDIOPlOJG11R/ptYWR8C67LAA
        thI3XRs7ZPgBVWExDpA12q7wOhpdz4sVWKF9cY3YZxYoZm58FRiPTMMc/MmmZfDRE1uqSghEamn
        VaSH89Pv0NEGEHk8ltbzKxJmpIjYCL5oadIvIDEWc+zY28CNJvgVu+WIEzG5soi2XrUn/JmTDwp
        0zM3zoqtq5d3cxkNdc9yPzvsuyMc4NRd3/OcWa66DzNpO5Fy4ZqOhby9HWx0Yc9r79KbiTAvpLE
        +mvX8g==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.263300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24632.005
X-MDID: 1558631402-AJ5Bnsg04yfz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2019 17:33, Jakub Kicinski wrote:
> On Thu, 23 May 2019 17:21:49 +0100, Edward Cree wrote:
>> Well, patch #2 updates drivers to the changed API, which is kinda an
>>  "upstream user" if you squint... admittedly patch #1 is a bit dubious
>>  in that regard;
> Both 1 and 2 are dubious if you ask me.  Complexity added for no
> upstream gain.
Just to explain the pickle I'm in: when this hw finally ships, we intend
 to both submit a driver upstream and also provide an out-of-tree driver
 that builds on older kernels (same as we do with existing hardware).  Now
 there are already some kernel releases (5.1 and, when it comes out of -rc,
 5.2) on which we'll just have to say "yeah, shared actions don't work here
 and you'll get slightly-bogus stats if you use them".  But I'd like to
 minimise the set of kernels on which that's the case.
I realise that from a strict/absolutist perspective, that's "not the
 upstream kernel's problem"; but at the same time it's qualitatively
 different from, say, a vendor asking for hooks for a proprietary driver
 that will *never* be upstream.  Does a strict interpretation of the rules
 here really make for a better kernel?  There *will* be an upstream gain
 eventually (when our driver goes in), just not in this release; it's not
 like the kernel's never taken patches on that basis before (with a
 specific use in mind, i.e. distinct from "oh, there *might* be an
 upstream gain if someone uses this someday").

> 3 is a good patch, perhaps worth posting it separately
> rather than keeping it hostage to the rest of the series? :)

If the series gets a definitive nack or needs a respin then I'll do that;
 otherwise posting it separately just makes more work for everyone.
 

> Side note - it's not clear why open code the loop in every driver rather
> than having flow_stats_update() handle the looping?
Because (as I alluded in the patch description) we don't *want* people to do
 the looping, we want them to implement per-action (rather than per-rule)
 stats.  Having such a loop in flow_stats_update() would encourage them to
 think "there is a function to do this, other drivers call it, so it must be
 what you're meant to do".  Whereas if we make the Wrong Thing be a bit ugly,
 hopefully developers will do the Right Thing instead.
(Perhaps I should add some comments into the drivers, instead, basically
 saying "don't copy this, it's bogus"?)
IMHO the original (pre 5.1) tcf_exts_stats_update() never should have had a
 loop in the first place, it was a fundamentally broken API wrt TC semantics.

-Ed
