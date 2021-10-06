Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D0A424037
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhJFOjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhJFOja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:39:30 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1709C061749;
        Wed,  6 Oct 2021 07:37:38 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id i13so3099659ilm.4;
        Wed, 06 Oct 2021 07:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jaQ0D/1iPp2/9BhYWQ6FMfz0USEUkVUO7PI9i63kb6k=;
        b=q0ANyJLQNrF3syrf4DQ2FRRqTqrgGtQGbHUzSUiVpEgT2SUlMQRl8bSal6z5rbIY60
         i1BP6slTrE93PqCN0l+hBrmINoq/aKG3RGEZ6zRbX9nWvSHOdpo6VLP1LfbrAtGe8sAQ
         UfPPREeyLqXzI8PakdNnXAHnjWlbwFHosI4mxAD+DxnYWoMSvomBD3MkenJBU2ALd4Kp
         kXJtmtTN3eaPsgWPd1xIRy/CjEFP/ouOrF5R2NqX5PV74btwJdm4zI0uUqJ4i3poWZY3
         A9ye2U4RSRGOVyneHecJ8i3kcvNBaWNpQ5mq7tYhiFA/ICkC9O7I9W9Gk/pCyx48ZWDM
         lUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jaQ0D/1iPp2/9BhYWQ6FMfz0USEUkVUO7PI9i63kb6k=;
        b=lB3TAWXZai182SejcZUOhKEvrTaCs51MKLpyASURH9zMGviua/qAQHQBdfKe2vLu+j
         JhiPUcsOTLGFV1jE+1ZSaayj7FcyxkJb+N7/ljnmZfeYrb7V5wBCHzOtZUUkMZ8gOdq2
         EpQy0eCq1eNzhNXB1+04w4t9dxckYU9MnEqbH+27uYJt7n/13Ynw6/plKralxfg15Clp
         6vtRHg6IN8D8O7kS/imYwn2pZio6qKzBUMI86GkVLr8QSbIXn4vkygntG5/Q0vEFpNVs
         /ceXn0vB8ghBU/wCXGuCg8Kw44jvMcaEEQLYk6DVa/IbicRjoMmJdIySvk8635hwTdnz
         gOJA==
X-Gm-Message-State: AOAM5307CLzLh5Grx0Y06dQ/Mw1zUnlw58+HTeaXUKSiovdD+bz/Srwn
        M59oO6+oeiSR9DzAekgIrEppTAfAyVPuQw==
X-Google-Smtp-Source: ABdhPJxM8C/VJ39BcvJ4gI236It0j8HYyk86415XY4aF1siTr0KpfQR8rG5SCYvp3/7LjUFO9N1atw==
X-Received: by 2002:a05:6e02:1caa:: with SMTP id x10mr7663858ill.280.1633531058060;
        Wed, 06 Oct 2021 07:37:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id j10sm13123143iow.33.2021.10.06.07.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:37:37 -0700 (PDT)
Subject: Re: [PATCH 02/11] selftests: net/fcnal: Mark unknown -t or TESTS
 value as error
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ba13bcf10f6deecadaf8a243993a273dd2761422.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <38f1f3b6-fe46-0943-adcb-ffe177847fb8@gmail.com>
Date:   Wed, 6 Oct 2021 08:37:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba13bcf10f6deecadaf8a243993a273dd2761422.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Right now unknown values are completely ignored which is very confusing
> and lead to a subset of tests being skipped because of a mispelling.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 3 +++
>  1 file changed, 3 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


