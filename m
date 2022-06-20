Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC599550F85
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 06:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiFTEuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 00:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiFTEuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 00:50:16 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4232DF;
        Sun, 19 Jun 2022 21:50:15 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1o39MZ-0007A2-Mm; Mon, 20 Jun 2022 06:50:11 +0200
Message-ID: <1198479a-ed0a-ae45-4aef-d750113aa3b0@leemhuis.info>
Date:   Mon, 20 Jun 2022 06:50:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Anton Makarov <am@3a-alliance.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.lebrun@uclouvain.be,
        regressions@lists.linux.dev, stable@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <7e315ff1-e172-16c3-44b5-0c83c4c92779@3a-alliance.com>
 <20220606143338.91df592bbb7dc2f7db4747e6@uniroma2.it>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] net: SRv6 End.DT6 function is broken in VRF mode
In-Reply-To: <20220606143338.91df592bbb7dc2f7db4747e6@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1655700615;6ebfc65e;
X-HE-SMSGID: 1o39MZ-0007A2-Mm
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.22 14:33, Andrea Mayer wrote:
> On Fri, 3 Jun 2022 15:23:26 +0300
> Anton Makarov <am@3a-alliance.com> wrote:
> 
>> #regzbot introduced: b9132c32e01976686efa26252cc246944a0d2cab
>>
>> Seems there is a regression of SRv6 End.DT6 function in VRF mode. In the 
>> following scenario packet is decapsulated successfully on vrf10 
>> interface but not forwarded to vrf10's slave interface:
>>
>> ip netns exec r4 ip -6 nexthop add id 1004 encap seg6local action 
>> End.DT6 vrftable 10 dev vrf10
>>
>> ip netns exec r4 ip -6 route add fcff:0:4:200:: nhid 1004

#regzbot fixed-by: a3bd2102e4642

> thank you for reporting this issue. I am already working on a fix patch which I
> will send shortly.

@Andrea: when you fix a reported issue, next time please include a
"Link: <url>" that links to the report, as explained in the
documentation (see submitting-patches.rst). Linus wants these tags(¹)
and my regression tracking efforts rely on them (that'S why I had to
write this mail to tell regression tracking bot with above command that
the issue has been fixed). tia!

Ciao, Thorsten

(¹) see for example:
https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
