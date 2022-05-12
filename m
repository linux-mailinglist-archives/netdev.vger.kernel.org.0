Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C45254F0
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357681AbiELSfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350956AbiELSfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:35:06 -0400
X-Greylist: delayed 1320 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 11:35:03 PDT
Received: from carlson.workingcode.com (carlson.workingcode.com [50.78.21.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668C569487;
        Thu, 12 May 2022 11:35:03 -0700 (PDT)
Received: from [50.78.21.49] (carlson [50.78.21.49])
        (authenticated bits=0)
        by carlson.workingcode.com (8.17.0.3/8.17.0.3/SUSE Linux 0.8) with ESMTPSA id 24CIBt8t021385
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 12 May 2022 14:11:56 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 carlson.workingcode.com 24CIBt8t021385
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=workingcode.com;
        s=carlson; t=1652379117;
        bh=fRLMsd/sUWYsl3gSss7SMn/poCCV3dWb8TFq8WtRz9s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=vuudb8HLwzFiPoaejTPIwz5siefmhEK7MK7mi9bUPAMgP4GbhqNhYO3oFjeTAyk3N
         CDHjPiRFe4eN1TgPiKPzRA7Jk3EMwDXkELCU6x5wWdwdbH5tYtcONOqjl+5vrSK+Bh
         CIAF5oQzSCLoAYTM1YiR+di9wfFOUmbddWc94AF4=
Message-ID: <0078ff43-f9fa-1deb-b64d-170d3d93ee6f@workingcode.com>
Date:   Thu, 12 May 2022 14:11:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk
 PC support
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Doug Brown <doug@schmorgal.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org
References: <20220509150130.1047016-1-kuba@kernel.org>
 <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
 <20220509103216.180be080@kernel.org>
 <9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com>
 <CAK8P3a1AA181LqQSxnToSVx0e5wmneUsOKfmnxVMsUNh465C_Q@mail.gmail.com>
 <d7076f95-b25b-3694-1ec2-9b9ff93633b7@schmorgal.com>
 <CAK8P3a3Tj=aJM_-x17uw1yJ-5+DgKX6APgEaO0sa=aRBKya1XQ@mail.gmail.com>
From:   James Carlson <carlsonj@workingcode.com>
In-Reply-To: <CAK8P3a3Tj=aJM_-x17uw1yJ-5+DgKX6APgEaO0sa=aRBKya1XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DCC--Metrics: carlson 1102; Body=12 Fuz1=12 Fuz2=12
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/22 04:23, Arnd Bergmann wrote:
> indication of appletalk ever being supported there, this all looks
> IPv4/IPv6 specific. There was support for PPP_IPX until it was
> dropped this year (the kernel side got removed in 2018), but never
> for PPP_AT.
> Adding Paul Mackerras to Cc, he might know more about it.

I waited a bit before chipping in, as I think Paul would know more.

The ATCP stuff was in at least a few vendor branches, but I don't think
it ever made it into the main distribution. These commits seem to be
where the (disabled by default) references to it first appeared:

commit 50c9469f0f683c7bf8ebad9b7f97bfc03c6a4122
Author: Paul Mackerras <paulus@samba.org>
Date:   Tue Mar 4 03:32:37 1997 +0000

    add defs for appletalk

commit 01548ef15e0f41f9f6af33860fb459a7f578f004
Author: Paul Mackerras <paulus@samba.org>
Date:   Tue Mar 4 03:41:17 1997 +0000

    connect time stuff gone to auth.c,
    don't die on EINTR from opening tty,
    ignore NCP packets during authentication,
    fix recursive signal problem in kill_my_pg

The disabled-by-default parts were likely support contributions for
those other distributions. (Very likely in BSD.)

I would've thought AppleTalk was completely gone by now, and I certainly
would not be sad to see the dregs removed from pppd, but there was a
patch release on the netatalk package just last month, so what do I know?

(The only possible reason I can see to keep any ATCP bits around at all
is to make sure we can write nice-looking log messages -- to say we're
rejecting "AppleTalk Control Protocol" rather than "unknown 8029." But
that'd be a very minor feature.)

-- 
James Carlson     42.703N 71.076W FN42lq08    <carlsonj@workingcode.com>
