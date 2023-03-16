Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A86BCBBA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjCPJ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjCPJ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:58:48 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73F1166F2;
        Thu, 16 Mar 2023 02:58:24 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aede0.dynamic.kabel-deutschland.de [95.90.237.224])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D7B8061CC457B;
        Thu, 16 Mar 2023 10:58:22 +0100 (CET)
Message-ID: <f7be8db9-0bdd-644d-c7a0-4321041c5028@molgen.mpg.de>
Date:   Thu, 16 Mar 2023 10:58:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Content-Language: en-US
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Johan Hovold <johan@kernel.org>
References: <20230316034759.73489-1-steev@kali.org>
 <20230316034759.73489-3-steev@kali.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230316034759.73489-3-steev@kali.org>
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

Dear Steev,


Thank you for your patch. Some nits.

Am 16.03.23 um 04:47 schrieb Steev Klimaszewski:
> Added regulators,GPIOs and changes required to power on/off wcn6855.

Please add a space after the comma.

> Added support for firmware download for wcn6855.

You might want to use imperative mood (Add …).

How did you test this? What firmware files did you use?

Maybe mention, that the assumption is, that it’s identical to WCN6750?

> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> Tested-by: Bjorn Andersson <andersson@kernel.org>
> ---

[…]


Kind regards,

Paul
