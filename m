Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BCE660BEA
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbjAGCZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGCY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:24:59 -0500
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6118B512;
        Fri,  6 Jan 2023 18:24:57 -0800 (PST)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pDytD-001M0C-Hf; Sat, 07 Jan 2023 03:24:55 +0100
Received: from p57bd9807.dip0.t-ipconnect.de ([87.189.152.7] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pDytD-002QBV-7n; Sat, 07 Jan 2023 03:24:55 +0100
Message-ID: <2a0071c6-20cf-42f2-f708-60c273fdb316@physik.fu-berlin.de>
Date:   Sat, 7 Jan 2023 03:24:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/7] Remove three Sun net drivers
Content-Language: en-US
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
 <800d35d9-4ced-052e-aebe-683f431356ae@physik.fu-berlin.de>
 <50dfdff7-81c7-ab40-a6c5-e5e73959b780@intel.com>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
In-Reply-To: <50dfdff7-81c7-ab40-a6c5-e5e73959b780@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.152.7
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/23 03:04, Anirudh Venkataramanan wrote:
> On 1/6/2023 5:36 PM, John Paul Adrian Glaubitz wrote:
>> Hello!
>>
>> On 1/6/23 23:00, Anirudh Venkataramanan wrote:
>>> This series removes the Sun Cassini, LDOM vswitch and sunvnet drivers.
>>
>> This would affect a large number of Linux on SPARC users. Please don't!
> 
> Thanks for chiming in. Does your statement above apply to all 3 drivers?

Yes!

>> We're still maintaining an active sparc64 port for Debian, see [1]. So
>> does Gentoo [2].
>>
>>> In a recent patch series that touched these drivers [1], it was suggested
>>> that these drivers should be removed completely. git logs suggest that
>>> there hasn't been any significant feature addition, improvement or fixes
>>> to user-visible bugs in a while. A web search didn't indicate any recent
>>> discussions or any evidence that there are users out there who care about
>>> these drivers.
>>
>> Well, these drivers just work and I don't see why there should be regular
>> discussions about them or changes.
> 
> That's fair, but lack of discussion can also be signs of disuse, and that's
> really the hunch I was following up on. Given what you and Karl have said,
> I agree that we shouldn't remove these drivers. I'll stop pursuing this unless
> there are new arguments to the contrary.

It's a common problem in my opinion on the LKML that many kernel developers assume
that users of certain drivers and kernel subsystems are present and active on the
kernel mailing lists to be able to raise their voices in these discussions.

If you want to find out whether some parts of the kernel are actively being used,
it's better to ask on distribution mailing lists because it's way more likely
to find any users there.

I try to be present on as many kernel mailing lists as I can to be able to answer
these questions, but sometimes there is just too much traffic for me to handle.

Adrian

-- 
  .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
   `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

