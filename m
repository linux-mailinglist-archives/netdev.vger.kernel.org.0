Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3C6C399D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCUSzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCUSzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:55:45 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C50457E5;
        Tue, 21 Mar 2023 11:55:43 -0700 (PDT)
Received: from maxwell ([109.42.112.2]) by mrelayeu.kundenserver.de (mreue107
 [213.165.67.113]) with ESMTPSA (Nemesis) id 1McHQA-1qCdqL3pO8-00ck85; Tue, 21
 Mar 2023 19:55:02 +0100
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-2-jh@henneberg-systemdesign.com>
 <20230317222117.3520d4cf@kernel.org>
 <87sfe2gwd2.fsf@henneberg-systemdesign.com>
 <20230318190125.175b0fea@kernel.org>
 <87r0tj23eh.fsf@henneberg-systemdesign.com>
 <20230320113643.53bbf52d@kernel.org>
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2 1/2] net: stmmac: Premature loop termination
 check was ignored on rx
Date:   Tue, 21 Mar 2023 19:53:50 +0100
In-reply-to: <20230320113643.53bbf52d@kernel.org>
Message-ID: <871qli0wap.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:KdbgHBcFP7ENYOGj4j5tDpIgCjXXqUk+EwngGihK4vkttv+cp0R
 qSqDvDOQvhSuZhs84ECOySyI61dgSyHppBzIELI0Gw8FkrUxoYnYbNmsbvXnIMFhRiMkvE9
 5MHgIhJ0o/noyhmrd/LSCccOE8m5C80MDnvIx1LdYHpENXL0pc5exq7DT4Ac/sCqGT7eUc3
 VDToeJG6O8laZxcN4JHNA==
UI-OutboundReport: notjunk:1;M01:P0:3Ex7bFj/Tfg=;d5A5dUmXhInR5VVZ29OjL3ZGHiu
 deOrKtD1SC1udStfgXdttdrq8l/bJUAPPWYRO5Ul3OZerTk+3UQc3SXrIq4beN7mEq810XPFA
 8PuhidDtNDUnBND1N/yEzzFWD/bmt+hvqxmNUyoz75vDVTf2SzQg7FAEWIgro+Xg57fAGiz8b
 Nd8LnmxoSPbreZbIVBH8TI6z5GYajfNi4RxrZgadUyNV5kyl5FT5vHwJUsHViFQ+A/9lnr95c
 OCFgPoS4bKUCwqVUyAiGK9T7PhmtmhXs6cVtQ5iWjLPUSSPylu7lL8YaFf49yhvlvyrd7pOBd
 6zBlPhfBvjOdmQew456q1Yg46APkeZidREPR5RRqDjeikSh8KTkikIjemecsTdRM0RLormCGt
 /U6r8GF/2qmXV/rcQhM73pbip0hnHjMI9GLitKgNd/YzofkiI2IVzoQCKQSlyuIYLv6uNVs2y
 d7F3wtFjn6nAfe0WgIBLHFgIRHbum4IVUnLuFaWU/SwvKuM7KLOOK8NXfcIlO169HMRX60N8K
 CcvUXOl5zSBZoJ0Us0K5aQ6n8BzduFDG0Xqp0w4rCdyEybI7DVFJCcZte8l57k/Jw6PlKagCz
 oPyr6g9vMEgBwJfFSFEOiG5SlnawA0j1NWN1lnLaFgiJfPMDKssioMI71OLCgqygWxxdEAx+I
 YlnwK1ZiE2e3we/tuuYDVv+SzQa4KIoWoI+DtkVF2g==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 20 Mar 2023 10:04:54 +0100 Jochen Henneberg wrote:
>> For the ST and Synopsys people:
>> I could imagine that you would be able to fix this much faster than
>> I can, so if they want to work on this please let me know so I don't
>> waste my time on doing double work.
>
> Don't hold your breath, we haven't heard from any of the maintainers 
> in 2 years :( 
>
> The drivers for CoTS IPs are really not great in general, I'm guessing
> delivering solid code is both difficult for them (given customer
> parametrization of each instance) and hard to fit into their business
> process :(

Thanks for your response. I will try to figure out the issue and work on
them, however, be patient as I can only limited time on this.
