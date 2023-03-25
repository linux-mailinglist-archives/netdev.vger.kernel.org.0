Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A276A6C8D59
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 12:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjCYLQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 07:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCYLQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 07:16:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83342126EE;
        Sat, 25 Mar 2023 04:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B86B802BE;
        Sat, 25 Mar 2023 11:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BE4C433D2;
        Sat, 25 Mar 2023 11:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679742960;
        bh=3+/UVshVQZdDXqD2zMkyBdRhnoFU0qpxJOK3gRa7WOE=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=WcxgF2+gtLt1xKDOLydIXNPBAKk0Us+pSnCITzB6PT0mlVfCbhCME0vTvy+ciayaW
         /VWZMWP5eYnGuvFqYQtIiz1JsPIwbD5Hqy/R46osyMkMwfUm8diIPl4ooqMIGAPzfM
         YCDReKa5qTGPCrd0yOF1TB2Fsx6jwsdMM5zkVIqNiXeGTB30VBBgPx1VOsbf733hbO
         L20XZ+JrDmO0Y54LhWHxVH8QMexZjNLK2s73O+wODJvCWDuPAEPbT0m/OYPLyG0P8X
         H05HiEQv1HnLywL/KWVif3l9GagUraMGuLPndOAIyZhhInjQbqDr5oisUYEQ4LWJtZ
         174K0zPIPck8Q==
Message-ID: <f28c46a8-eb93-6d22-1331-edb9155a1563@kernel.org>
Date:   Sat, 25 Mar 2023 12:15:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: dsa: b53: add BCM53134 support
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230324084138.664285-1-noltari@gmail.com>
 <20230324084138.664285-2-noltari@gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230324084138.664285-2-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2023 09:41, Álvaro Fernández Rojas wrote:
> BCM53134 are B53 switches connected by MDIO.

Do not attach (thread) your patchsets to some other threads (unrelated
or older versions). This buries them deep in the mailbox and might
interfere with applying entire sets.

> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>


Acked-by: Krzysztof Kozlowski <krzk@kernel.org>



Best regards,
Krzysztof

