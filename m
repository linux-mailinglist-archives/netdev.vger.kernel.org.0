Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B826E4096
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDQHUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjDQHUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09C540F0;
        Mon, 17 Apr 2023 00:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84DD661E72;
        Mon, 17 Apr 2023 07:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D45AC433EF;
        Mon, 17 Apr 2023 07:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716005;
        bh=GIlq1xazAppk+4PJdlj+79u9JtEaGtPambHTZuB/bFQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=t/Wm+Z4lufEoglmsAGChmQMgJpQoB4XNwtH5NxGv6kKl2ec78W1E4q7AwMj1t0Ov4
         71f9rzU6VJyeLhGZ4RxAMPf6XmUuDE+tj8Sgn82UffxPhDbOes+n0Nm3YEiV6Uta/w
         vNYOr/Mrg0JuqM9gjhhmlA6TpbiSmNUjQ5YZZX1JXsb2YUc0T60uToZ07m37ouHPgm
         xSMgy6IafpXkwa0mgKQg/ocvLqN0COG4iFUpGis67h3kS7UwSCUFp1Quto1MsbDzcy
         guiNCaCQgPY4IgnbYX25LM1yGjkj+jFirD1k9mHiXa0fuM2DaBW1ZRKfe2shPNPCZl
         ahFbB02ub2RDw==
Message-ID: <dd1525de-fa91-965f-148a-f7f517ae48f9@kernel.org>
Date:   Mon, 17 Apr 2023 09:19:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: wireless: ath9k: document endian
 check
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        chunkeey@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230417053509.4808-1-noltari@gmail.com>
 <20230417053509.4808-2-noltari@gmail.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230417053509.4808-2-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/04/2023 07:35, Álvaro Fernández Rojas wrote:
> Document new endian check flag to allow checking the endianness of EEPROM and
> swap its values if needed.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

You missed the lists so this won't be tested. Resend following Linux
kernel submission process.


> ---
>  .../devicetree/bindings/net/wireless/qca,ath9k.yaml          | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
> index 0e5412cff2bc..ff9ca5e3674b 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
> @@ -44,6 +44,11 @@ properties:
>  
>    ieee80211-freq-limit: true
>  
> +  qca,endian-check:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      Indicates that the EEPROM endianness should be checked

Does not look like hardware property. Do not instruct what driver should
or should not do. It's not the purpose of DT.


Best regards,
Krzysztof

