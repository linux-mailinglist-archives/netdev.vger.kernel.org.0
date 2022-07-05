Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E533566AD2
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiGEMCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 08:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiGEMBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 08:01:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FDA1834F;
        Tue,  5 Jul 2022 05:01:22 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8hEp-000Eyk-No; Tue, 05 Jul 2022 14:01:07 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8hEp-000Uzq-CA; Tue, 05 Jul 2022 14:01:07 +0200
Subject: Re: [PATCH] MAINTAINERS: adjust XDP SOCKETS after file movement
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <20220701042810.26362-1-lukas.bulwahn@gmail.com>
 <Yr7mcjRq57laZGEY@boxer>
 <CAJ8uoz16yGJqYX2xOcczTGKFnG4joh8+f1uPGMAP4rmm3feYDQ@mail.gmail.com>
 <Yr78Md1Nqpj+peO0@boxer>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c9c2d7b3-7d29-252d-6070-77d562ee4c3b@iogearbox.net>
Date:   Tue, 5 Jul 2022 14:01:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Yr78Md1Nqpj+peO0@boxer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26594/Tue Jul  5 09:24:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/22 3:52 PM, Maciej Fijalkowski wrote:
> On Fri, Jul 01, 2022 at 03:13:36PM +0200, Magnus Karlsson wrote:
>> On Fri, Jul 1, 2022 at 2:38 PM Maciej Fijalkowski
>> <maciej.fijalkowski@intel.com> wrote:
>>>
>>> On Fri, Jul 01, 2022 at 06:28:10AM +0200, Lukas Bulwahn wrote:
>>>> Commit f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf") moves
>>>> files tools/{lib => testing/selftests}/bpf/xsk.[ch], but misses to adjust
>>>> the XDP SOCKETS (AF_XDP) section in MAINTAINERS.
>>>>
>>>> Adjust the file entry after this file movement.
>>>>
>>>> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>>>> ---
>>>> Andrii, please ack.
>>>>
>>>> Alexei, please pick this minor non-urgent clean-up on top of the commit above.
>>>>
>>>>   MAINTAINERS | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index fa4bfa3d10bf..27d9e65b9a85 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -22042,7 +22042,7 @@ F:    include/uapi/linux/xdp_diag.h
>>>>   F:   include/net/netns/xdp.h
>>>>   F:   net/xdp/
>>>>   F:   samples/bpf/xdpsock*
>>>> -F:   tools/lib/bpf/xsk*
>>>> +F:   tools/testing/selftests/bpf/xsk*
>>>
>>> Magnus, this doesn't cover xdpxceiver.
>>> How about we move the lib part and xdpxceiver part to a dedicated
>>> directory? Or would it be too nested from main dir POV?
>>
>> Or we can just call everything we add xsk* something?
> 
> No strong feelings. test_xsk.sh probably also needs to be addressed.
> That's why I proposed dedicated dir.

Could one of you follow-up on this for bpf-next tree? Maybe for selftests something
similar as in case of the XDP entry could work.

Thanks,
Daniel
