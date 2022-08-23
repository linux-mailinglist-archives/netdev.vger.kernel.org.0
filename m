Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C2B59EEFB
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiHWWX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiHWWXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:23:55 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC9211A18;
        Tue, 23 Aug 2022 15:23:54 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aec8f.dynamic.kabel-deutschland.de [95.90.236.143])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0472961EA192D;
        Wed, 24 Aug 2022 00:23:51 +0200 (CEST)
Message-ID: <b0f17259-680c-7bc0-b941-26dc54214b86@molgen.mpg.de>
Date:   Wed, 24 Aug 2022 00:23:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [Intel-wired-lan] [PATCH v1] drivers/net/ethernet: check return
 value of e1e_rphy()
Content-Language: en-US
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220823060200.1452663-1-floridsleeves@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220823060200.1452663-1-floridsleeves@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Li,


Thank you for your patch.

Am 23.08.22 um 08:02 schrieb lily:
> e1e_rphy() could return error value, which need to be checked.

need*s*

> 
> Signed-off-by: Li Zhong <floridsleeves@gmail.com>

The From header field does not match the Signed-off-by line. Could you 
configure git with your user name?

     $ git config --global user.name "Li Zhong"
     $ git commit --amend --author="Li Zhong <floridsleeves@gmail.com>"

> ---
>   drivers/net/ethernet/intel/e1000e/phy.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)

[…]


Kind regards,

Paul
