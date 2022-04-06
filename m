Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49784F5E9E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiDFMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiDFMtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:49:40 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D755C4BF330;
        Wed,  6 Apr 2022 02:00:18 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aef4f.dynamic.kabel-deutschland.de [95.90.239.79])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9A31D61E64846;
        Wed,  6 Apr 2022 11:00:15 +0200 (CEST)
Message-ID: <d8571528-4202-e6d7-e8b2-f9feb7e6f8f7@molgen.mpg.de>
Date:   Wed, 6 Apr 2022 11:00:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Intel-wired-lan] [PATCH net 0/2] ixgbe: fix promiscuous mode on
 VF
Content-Language: en-US
To:     Olivier Matz <olivier.matz@6wind.com>
Cc:     netdev@vger.kernel.org,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        intel-wired-lan@osuosl.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20220325140250.21663-1-olivier.matz@6wind.com>
 <Yk1MxlsbGi810tgb@arsenic.home>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <Yk1MxlsbGi810tgb@arsenic.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Olivier,


Am 06.04.22 um 10:18 schrieb Olivier Matz:

> On Fri, Mar 25, 2022 at 03:02:48PM +0100, Olivier Matz wrote:
>> These 2 patches fix issues related to the promiscuous mode on VF.
>>
>> Comments are welcome,
>> Olivier
>>
>> Cc: stable@vger.kernel.org
>> Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
>> Olivier Matz (2):
>>    ixgbe: fix bcast packets Rx on VF after promisc removal
>>    ixgbe: fix unexpected VLAN Rx in promisc mode on VF
>>
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Sorry, the intel-wired-lan mailing list was not CC'ed initially.
> 
> Please let me know if I need to resend the patchset.

Yes, please resend.


Kind regards,

Paul
