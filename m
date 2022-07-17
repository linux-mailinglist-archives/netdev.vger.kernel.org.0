Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F37577761
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiGQQ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiGQQ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:57:17 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0F313FA9
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:57:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s27so8668121pga.13
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ckIVTOfpzS5KCdfupn+2cbh700fa9dGAXFpXVNdLRmA=;
        b=neT53yxSHsjIfMgvAW3W9ymIf6IUwoqWrfKYYI8WYucalMZKvtszIL4RhhMokqsTIk
         ta2InwE1rADGZnx7Bwltd1kFxYPyIOV0QhU6CTtLxS29ec5qnAdhnEMSw2e+QFbH9zIz
         AStNSkO7TqHF1/KgPOPs0B/ozVPn1cQdmtBlHavK+NQ9HTJg1JrKvbM9bRZVuu6OHnrL
         mcSDjk93AbD249xOJOnxeHaxw/DIUhUPZLMjNYwdtWERvG2axb2ElPpSC4UXxHi8oUyJ
         QGhPtJrcN81eSuKv1u9cFZ4EX6YxrdJ48AAOAGzfZnVve/KZHYo/75ioWVFi/NAm4ziW
         ZSDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ckIVTOfpzS5KCdfupn+2cbh700fa9dGAXFpXVNdLRmA=;
        b=EQEA7NYmr8fDX9W0Y4m73r9pwCB4jzFG/UHOBM9WHrsTnmhJRmRK/HjgkXc1SSfDt+
         Xj23rbRtDC9Ea38gl3nk1mktZ8/kDrb/RY7qYVYMUTzPutAlqbRfUaIPfjHtqnBYFgXu
         wCriL0oqHGn4dGi7UvqJIoXs/NeMqJ6+Dm0w49IMd+BMqWyiUZ7bPc6bujZIlzpRX4/W
         q/OAdFD21qLbuAUUiVtd9IkufzeFOYQU0ILtgb9qRiFtqWGs4WBC8GAyg3yoRW2/WGnx
         e7XlUw8XTR2YDaiy01ODIFNBIEvviNsBaY84S8kz7Yqs1gHCIGHCLVgAsbCGgOIQoiCQ
         cKQA==
X-Gm-Message-State: AJIora/8rhYzFkLmQ9n/IzpdM6Hlo9ZKedE/+5al+q19R3njCo63+g/i
        SrNB2O34dFHnNm5K4nOea6c=
X-Google-Smtp-Source: AGRyM1v4vkUqfkHSZQGWwvbmCcRJmsbzPe/0wx3ieeqRNeQSW7Obn7Jnjkf435syBtvlEWAm2tM0Fg==
X-Received: by 2002:a05:6a00:224b:b0:52a:b918:e757 with SMTP id i11-20020a056a00224b00b0052ab918e757mr24673694pfu.38.1658077036243;
        Sun, 17 Jul 2022 09:57:16 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id l15-20020a17090a384f00b001ef81574355sm9597968pjf.12.2022.07.17.09.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:57:15 -0700 (PDT)
Message-ID: <1997c84e-572e-8f08-853e-a0882b95b2db@gmail.com>
Date:   Sun, 17 Jul 2022 09:57:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 02/15] docs: net: dsa: document the shutdown behavior
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> Document the changes that took place in the DSA core in the blamed
> commit.
> 
> Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
