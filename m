Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01306C3C3A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCUUvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjCUUvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:51:18 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC0E18B3F;
        Tue, 21 Mar 2023 13:51:17 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id n2so19636100qtp.0;
        Tue, 21 Mar 2023 13:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lh9Hs0isBxzuCKJQVIKEJE4SkYUwyi63tcarRuwKgmI=;
        b=W4AucURA5plvhs1NJg5iC8cUHG33iOh5IJwbjj/WF4l3zC1dHfKb+cwUQ/6wzI82Cy
         YaTApFCahsdyfAFzGjVIJ7DQTB3e573gUpOA/EC+TwfAJSht2Krcz9pVOv2Fhsf09VQL
         QiVOtxPOxeXvzZFtXS5QLheBgpN73y9+oK2BpMykOuX0RtQNKmj9Lw4YAigXMRB1uDS0
         jK+RYvtrp5zELBd22kqEr+QyWt9Hr+UuMI0sE3ahaV2aFOLgXQ8cLf9pz57gkWmSttNW
         fcXgyAnVEmedshP6zX92Jjyuzb5bLmH/w465+7Up4hc+eAErq6igFjYFcTPriyA+iPIc
         JYvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lh9Hs0isBxzuCKJQVIKEJE4SkYUwyi63tcarRuwKgmI=;
        b=7Ad7A+y3LV3EitTgzJYQEaXe5VmG/CJhOTih68/HhilyBbws2A0lnT/yBUKNMidoV5
         FnwCsSriflN4bamFzdbtgmYZgzrxxCjQe5qMfYADwSdVBNOgKN4aBs+paA2HuJOOptlS
         KQUFqAiM7W/Ywe7yECnbfmzAsIvJDE5x3FaKh8xoMg+FcMmrcy287LdRcRRTs6yVK6EK
         TscOqjkuHyIOGxFxjeNoGpBOGyXFM50WjXKR+5IhTmeqUWp8xigqALxJppBBqUwb+7yt
         OYJSdCUMPm0lMj4M63VTwed/8gHXUfJg4i/629ylzDLS7CNJKQc51dj9Art+/mCVEK5/
         ZRSw==
X-Gm-Message-State: AO0yUKUDye34SjKiyUSEK5QT5/hVwsFP0E2ENubj0L0URSySSrRfX7D1
        lr8HHYPWSw4f+nJad4mc5l0=
X-Google-Smtp-Source: AK7set+UaJIls3IoADiSVOTzsbB9EZCVRpjqWe2OuIRvMgmm/0E6ahZEgUZubyH/HMYA2uj3GhfG1A==
X-Received: by 2002:ac8:5c09:0:b0:3e3:894e:f0ab with SMTP id i9-20020ac85c09000000b003e3894ef0abmr1492677qti.6.1679431877123;
        Tue, 21 Mar 2023 13:51:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v10-20020ac873ca000000b003e29583cf22sm3546468qtp.91.2023.03.21.13.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:51:16 -0700 (PDT)
Message-ID: <90908e6e-75e6-7e6f-d896-b4ccbbd9820a@gmail.com>
Date:   Tue, 21 Mar 2023 13:51:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        andrew@lunn.ch, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
References: <20230317120815.321871-1-noltari@gmail.com>
 <20230319095540.239064-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230319095540.239064-1-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/23 02:55, Álvaro Fernández Rojas wrote:
> When BCM63xx internal switches are connected to switches with a 4-byte
> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
> based on its PVID (which is likely 0).
> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
> tag is properly processed. The next step would to decode the corresponding
> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
> 6-byte tag and the 4-byte tag handling fails.
> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
> tag before passing it to the 4-byte tag decoding.
> 
> Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

