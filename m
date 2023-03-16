Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCB46BCB52
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCPJr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCPJr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:47:27 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7703B19C41;
        Thu, 16 Mar 2023 02:47:25 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aede0.dynamic.kabel-deutschland.de [95.90.237.224])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 475B961CC457B;
        Thu, 16 Mar 2023 10:47:22 +0100 (CET)
Message-ID: <116b1db5-bf75-9fbf-c37b-2fe1028ddaeb@molgen.mpg.de>
Date:   Thu, 16 Mar 2023 10:47:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
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
References: <20230316151018.v1.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230316151018.v1.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Howard,


Thank you for your patch.

Am 16.03.23 um 08:10 schrieb Howard Chung:
> From: howardchung <howardchung@google.com>

Please configure your full name:

     git config --global user.name "Howard Chung"
     git commit -s --amend --author="Howard Chung <howardchung@google.com>"

> The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
> length argumenent. This patch adds right the field.

argument

Were you seeing actual problems? If so, please describe the test setup.

> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
> Signed-off-by: howardchung <howardchung@google.com>
> ---
> 
>   net/bluetooth/mgmt.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 39589f864ea7..249dc6777fb4 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9357,7 +9357,8 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
>   	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
>   						HCI_MGMT_VAR_LEN },
>   	{ add_adv_patterns_monitor_rssi,
> -				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE },
> +				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
> +						HCI_MGMT_VAR_LEN },
>   	{ set_mesh,                MGMT_SET_MESH_RECEIVER_SIZE,
>   						HCI_MGMT_VAR_LEN },
>   	{ mesh_features,           MGMT_MESH_READ_FEATURES_SIZE },

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
