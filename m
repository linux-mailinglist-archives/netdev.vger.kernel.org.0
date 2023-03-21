Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF986C3BFB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCUUjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCUUjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:39:44 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174573E1C9;
        Tue, 21 Mar 2023 13:39:34 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id t13so10695573qvn.2;
        Tue, 21 Mar 2023 13:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431173;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HGyUxdj/Lp65x5LrMfbN6yHtalYpshYTCf2SeZA/f44=;
        b=V8sy3C7DwSMDJYaT8nJf8hfsLIXhDpmNWEqo7BK1Tgw5usVXWDzgWyLBMjWBdU/o6B
         E0pokEgO1CdwiEEjx+sQD0XpgVUXaPvV7EPlEN6lLUB0Lk+ceIyU1bk7DS5L2RAkf7DN
         nagLjZgyT+EUxRfm7o9HhLnMxRo5FCLCLe10BojRxzXFEE3WTna1lNR4wPWmx3ls+xdA
         OcnqduXY+qRSR7UzxBOvb2pdPqyBr+OmKFtzgqyU+n/IpL7wz8qyaphV1xM2n2a+vvqr
         dVrLUebjY3dg5TCdJF7pvi7Io7ID/O0oroDBLA2Ms/hMnTL/gcdRZLqVi7YB8jQDVFvY
         uhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431173;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HGyUxdj/Lp65x5LrMfbN6yHtalYpshYTCf2SeZA/f44=;
        b=V+6gbrpXF2zstBhPobuEv/3IOjwdJKaMQA7eeirp6RZRK7YDwdeRKQPhmIC8VWRL7X
         FGF7joOFzF4OavrJNXq0JJTikBFvxl4ICrF3DFX069xBSAUBFsuwC1fmfdfP8wQy4hyD
         EiWIDqcbngAMnYHSxoREwtywy64clDGhcz/O7QgV9Kxgmr5eoS1JOddgoWDystgqZDrr
         IlyXa6DANz+/XpC6es9a4Y9Q63ROgbi4Ydt/nbHxtWbsZhUpfCybxxv6Efw9906Z+6KU
         74/Kz6V7EN4dRIDO5bmFcpxp6WJyLR7tWOh6o6Mh1T9KUKnPZKp2IwaQq/61Ogo8yLIB
         LTEw==
X-Gm-Message-State: AO0yUKU2ipu7zuPHn8GPIza+uONlOp/v7fsYYZYqN75ePzXsi9W1hmmc
        u0Cs8Z6FuT0e3fcPlF/WWdotktD+SjY=
X-Google-Smtp-Source: AK7set+da2uXW3p+YVhyn/MAGPh4vsrGPdb3/mWfdqp+CgAgkvwVDha1d5iFjvvqhdiS9xq54Q0VOQ==
X-Received: by 2002:a05:6214:1942:b0:5ac:d0dc:8ec0 with SMTP id q2-20020a056214194200b005acd0dc8ec0mr2588014qvk.26.1679431173157;
        Tue, 21 Mar 2023 13:39:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z9-20020a376509000000b0074283b87a4esm2777178qkb.90.2023.03.21.13.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:39:32 -0700 (PDT)
Message-ID: <4d841ff2-706b-960d-1b59-a77fb849bb83@gmail.com>
Date:   Tue, 21 Mar 2023 13:38:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] ethernet: remove superfluous clearing of phydev
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Wells Lu <wellslutw@gmail.com>, linux-kernel@vger.kernel.org
References: <20230321131745.27688-1-wsa+renesas@sang-engineering.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321131745.27688-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 06:17, Wolfram Sang wrote:
> phy_disconnect() calls phy_detach() which already clears 'phydev' if it
> is attached to a struct net_device.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

