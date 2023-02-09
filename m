Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9606903C8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBIJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjBIJc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:32:27 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39940627B5
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:32:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e3so1095314wrs.10
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 01:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3eL7i9b5wRY0WQmCcwLWaepV6oMtyTPsC0kIIjAbWos=;
        b=BRQ7FvOa7WzSiV9lkz2IJt8gO7JaWUx8exju0lZChG71KN1KtoPl+nRG2tNFgvNh+Y
         dNXXQ6b0oEhKK6B/zFwlCax2PavvZxrkry8H5BejD/nVC9fcWi2wlKpkJkwXsrul8qHj
         eI6IeiZGDUWE9y3z3wx2qE6JOSi8RsUPHLS/P0P97DW0GgSN9izSzHKQVKQMrwaNOVmr
         EVzu+BlHkixgNObqr177mOh3BOTcp9Cxsg6r5BU84mAf8VvLzQyi7/z6io0bMMIt5/O2
         WeW7kCJVzjDXho+Dj94lBcWidpEFZ3N0rYVewGdYnOwMQRh3t/ay1L+C2FVI67c9xIoV
         AKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3eL7i9b5wRY0WQmCcwLWaepV6oMtyTPsC0kIIjAbWos=;
        b=VotLyfRzJkFNULk94IkuWIg1RRmaA7tizFb8TB2M8S7XfSznrt5CnRnrb7d8dnI8lH
         SQ2ESldKK/HjbLQ/kYOTI9yAQbRh3xFuby7+Kvbt524hq4gKn+ECK7PsOt1May9WRS5E
         rRzVqSH8bLFOfWwfkbN8liLpaTsNT9fvV/LExhBWbGC9YHMyKZZLjlbxWksCVjmr6Arj
         AtJGLRctm+lmIpaF4oIk4zjxk8smsf9oxLqnaeLoTurzkTryIEzBFE9O5wS18OBZzmOA
         Jj2SrGwuM6htFBHrho8tLszbi7CUMCC7GO3ApEUvrquqjLSvebpG5Jx2sAdjhr3w6WfV
         InDQ==
X-Gm-Message-State: AO0yUKXLmYW6w3PXyMX8gjxx/9bq4oN81rECpSaB7lvKnk5N6N3OCryC
        ZmjRzEZFiEqAAuzBnt4hvY7pHw==
X-Google-Smtp-Source: AK7set8I2xZbbr8G3cp/CpHdQlhfy0CfuBS3MAzNnpmRXGn+oP+zQZcQ4KmZTBzwEZBwmmC6Ow2r0Q==
X-Received: by 2002:a05:6000:136c:b0:2c3:db87:977c with SMTP id q12-20020a056000136c00b002c3db87977cmr9632412wrz.12.1675935144773;
        Thu, 09 Feb 2023 01:32:24 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe44c000000b002c3dd9bb283sm803503wrm.37.2023.02.09.01.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:32:24 -0800 (PST)
Message-ID: <9f0a1202-1a98-22e1-873b-2d70ed63de72@linaro.org>
Date:   Thu, 9 Feb 2023 10:32:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 10/11] dt-bindings: clock: remove stih416 bindings
Content-Language: en-US
To:     Alain Volmat <avolmat@me.com>, Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20230209091659.1409-1-avolmat@me.com>
 <20230209091659.1409-11-avolmat@me.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230209091659.1409-11-avolmat@me.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2023 10:16, Alain Volmat wrote:
> Remove the stih416 clock dt-bindings since this platform is no
> more supported.
> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

