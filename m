Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253BA633EAA
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiKVORZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiKVORY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:17:24 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E8845A12;
        Tue, 22 Nov 2022 06:17:22 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BFF7B61CCD898;
        Tue, 22 Nov 2022 15:17:19 +0100 (CET)
Message-ID: <24fd3d18-0c09-8235-c88d-d7e151110ebe@molgen.mpg.de>
Date:   Tue, 22 Nov 2022 15:17:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [Intel-wired-lan] [PATCH] igbvf: Regard vf reset nack as success
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        intel-wired-lan@lists.osuosl.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20221122092707.30981-1-akihiko.odaki@daynix.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221122092707.30981-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Akihiko,


Thank you for your patch.


Am 22.11.22 um 10:27 schrieb Akihiko Odaki:
> vf reset nack actually represents the reset operation itself is
> performed but no address is not assigned. Therefore, e1000_reset_hw_vf

Is … no … not assigned … intentional?

> should fill the "perm_addr" with the zero address and return success on
> such an occassion. This prevents its callers in netdev.c from saying PF

occasion

> still resetting, and instead allows them to correctly report that no
> address is assigned.

In what environment do you hit the problem?

[…]


Kind regards,

Paul
