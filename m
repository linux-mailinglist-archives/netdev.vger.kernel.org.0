Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972216BCBDA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCPKDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCPKDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:03:02 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7E626C32;
        Thu, 16 Mar 2023 03:03:00 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aede0.dynamic.kabel-deutschland.de [95.90.237.224])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 83D1861CC40F9;
        Thu, 16 Mar 2023 11:02:58 +0100 (CET)
Message-ID: <4b7a52d4-8d89-76ea-62bc-3dfc5072a116@molgen.mpg.de>
Date:   Thu, 16 Mar 2023 11:02:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
Content-Language: en-US
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Archie Pusaka <apusaka@chromium.org>,
        Brian Gix <brian.gix@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230316175301.v2.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230316175301.v2.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
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

Dear Yun-hao,


Am 16.03.23 um 10:53 schrieb Howard Chung:
> The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
> length argumenent. This patch adds right the field.

There is still the typo in argument.

> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> Hi upstream maintainers,
> Host is not able to register advmon with rssi due to the bug.
> This patch has been locally tested by adding monitor with rssi via
> btmgmt on a kernel 6.1 machine.

I would add that information to the commit message.

[…]


Kind regards,

Paul
