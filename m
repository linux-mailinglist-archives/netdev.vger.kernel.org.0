Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A6615BC5
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 06:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiKBFXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 01:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKBFXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 01:23:43 -0400
Received: from omta037.useast.a.cloudfilter.net (omta037.useast.a.cloudfilter.net [44.202.169.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9A82409F;
        Tue,  1 Nov 2022 22:23:42 -0700 (PDT)
Received: from eig-obgw-5011a.ext.cloudfilter.net ([10.0.29.161])
        by cmsmtp with ESMTP
        id phouobCb77krOq6E1odTck; Wed, 02 Nov 2022 05:23:41 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id q6DzoG578bE09q6E0olbhu; Wed, 02 Nov 2022 05:23:40 +0000
X-Authority-Analysis: v=2.4 cv=V6xubMri c=1 sm=1 tr=0 ts=6361fedc
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=Qawa6l4ZSaYA:10
 a=wYkD_t78qR0A:10 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=Twlkf-z8AAAA:8
 a=Ajr8Ya8xPWvAgL_sw0AA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=xmb-EsYY8bH0VWELuYED:22 a=-74SuR6ZdpOK_LpdRCUo:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NrXbbGcVenpDWuMVBTnZqZTgRIfDXJVj9AsuNMNu/ac=; b=rxDYabtC4yFlIKvJZrzMTCtL9G
        yzmT8CVs65TAajvtCrKJccTM55ieXMGzE2ToKKDdUfdsoGeFt7Iy45KtxwGIwYGnIoRlujQGPFkqC
        rDnI0kqdID5eZkr6llOqnKsgfQ/QpKDgTkIkY5FwRQg2Jiog/QDzacrfrkcAsAH5kb67x+q2A6L0S
        fGy46jKMtWQTNw/G5k/eDFQFbbh+ttct6U9ORm6taA8k0bzQih1LpQxWB4xY86W1d/iI7zdMPvmD4
        SaYYEFg3z7wVMJYA1F9VhulYXE47s9WQ7JWuEJAZoYp6sYJMyIe7r5oNmO8JBjVo3HKosHfteBA7X
        VD+wY8gQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:38738 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1opZI6-003AiS-Gi;
        Mon, 31 Oct 2022 13:13:42 -0500
Message-ID: <f31ea73f-143c-ef24-8637-6d68430953bf@embeddedor.com>
Date:   Mon, 31 Oct 2022 12:13:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 5/6] bna: Avoid clashing function prototypes
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Rasesh Mody <rmody@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <cover.1666894751.git.gustavoars@kernel.org>
 <2812afc0de278b97413a142d39d939a08ac74025.1666894751.git.gustavoars@kernel.org>
 <202210290009.C42E731@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <202210290009.C42E731@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1opZI6-003AiS-Gi
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:38738
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDpNrm1HbivHzY8qNfAFAOOjIAw2i7zeiRkQ10Awb/0JNRbVHg/Jl3G1Y/aaZrD8Uv8feSTVHeZ2C6qT+6P/BzSZWljVpq79ZPq15vZXX90zNTQYE/w9
 g9OOBH37QbJ8tsUG9TZziY3vhZb1DZfTXDbhXJOuaobjiKKVEP02y5I0G/6beX+HbOPbQzgy5JWZ4OQN9QEH0cLeu09F9U5jU2Evov89YXi+EMoLHZ/mkwvo
 UflH4maDaDAXU5phiEkIeLD4dBs53elLEC3EfFcct1yNQMvLkLXdRrGt2cNjB65M
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/22 02:12, Kees Cook wrote:
> On Thu, Oct 27, 2022 at 03:20:47PM -0500, Gustavo A. R. Silva wrote:
>> When built with Control Flow Integrity, function prototypes between
>> caller and function declaration must match. These mismatches are visible
>> at compile time with the new -Wcast-function-type-strict in Clang[1].
>>
>> Fix a total of 227 warnings like these:
>>
>> drivers/net/ethernet/brocade/bna/bna_enet.c:519:3: warning: cast from 'void (*)(struct bna_ethport *, enum bna_ethport_event)' to 'bfa_fsm_t' (aka 'void (*)(void *, int)') converts to incompatible function type [-Wcast-function-type-strict]
>>                  bfa_fsm_set_state(ethport, bna_ethport_sm_down);
>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> The bna state machine code heavily overloads its state machine functions,
>> so these have been separated into their own sets of structs, enums,
>> typedefs, and helper functions. There are almost zero binary code changes,
>> all seem to be related to header file line numbers changing, or the
>> addition of the new stats helper.
> 
> This looks like it borrowed from
> https://lore.kernel.org/linux-hardening/20220929230334.2109344-1-keescook@chromium.org/
> Nice to get a couple hundred more fixed. :)

Yep; you're right. That's exactly the patch I was staring at
while doing these changes. :)

> 
>> [1] https://reviews.llvm.org/D134831
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>> Changes in v2:
>>   - None. This patch is new in the series.
> 
> This is relatively stand-alone (not an iw_handler patch), so it could
> also go separately too.

My criteria here was that all these patches avoid clashing function
prototypes. So, they could be put together into a series, regardless
if they are "iw_handler" related patches.

> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!
--
Gustavo

