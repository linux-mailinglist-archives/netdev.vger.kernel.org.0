Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B914B6BEF35
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCQRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCQRIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:08:04 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCEC4C6F2;
        Fri, 17 Mar 2023 10:07:42 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id x1so6308266qtr.7;
        Fri, 17 Mar 2023 10:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679072862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GjRggQHjLlkcfZIKZDKtvqvna8vnRMDyqBk8XgqiML8=;
        b=U/mVHrA5p/nrWc5duQw8keuQkFr61FBKnfpqdX3BiLL7Kh3EVOc/QjL+6cHxSpsU5i
         2HYfFgRzN1h9G/+kXb7iaOI675xKW5r+68uQuK3/v54wPDzyjlD7W4m5qoqPsBtNxREB
         5CEm3cRG+/25Q6VPnI+kwzp7YENidbDX2tX3zW3SihDTv0+ZMOZ3ppLGv7jgIeliHXbV
         EMJeSqxp29Ksj8gqtWscH4seTqPl/5lMe/10SCOpPCIdrhJr1tXKJi+iFsHjAFIcc7IP
         bBGZZqmi80DEEBrhFvWsU6XktZuROKtNA7h/XmkLP+Ioql7JWSt/4tW8ZpHjASW6nZ60
         4dZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GjRggQHjLlkcfZIKZDKtvqvna8vnRMDyqBk8XgqiML8=;
        b=1LqMoMDApYjifRJyDRHQumbihGYESCPE2/oOR1N7fsxSXMUA5uF0W4ZVeZakBtu3fh
         FQCiIMDqzGjNWV2t8rXxRxlYQL3mwQb/ZELpt6I3HDok1kfDgZ66C0Z4ipc+egUEHzlH
         J2ocC9v0PpfaLHgQGKhKL26kGfE7SxwBl3yqho8eTObmU6bGYnHmeIKQm3PDZQelGLdl
         /0bPDFZFlBOo+/QsYMig5KoSxNc+9iVgzWVwBJzUhyWVfK86H82k/JGHPTYAA+vQ79zH
         SITBqAAaAOkN5dYgt2NTxb/xg8HSLZi3vZzlKbYcQauZJEBzkHHPnjBcF+JQ1sTHyyRw
         G0CQ==
X-Gm-Message-State: AO0yUKV9hBgBZXKdfdpA72LEDSdP6LQucO5MEBXwUibE81CfhfAModPH
        wyT8cS3KKNzcGnUWmkrNYF0=
X-Google-Smtp-Source: AK7set8CQcKDz2bV83IoY1aVKhzUnh8T8KzFpa4QGAG5H+rgQeLv1Y3IDYVfkDVh6+a6TRq47pt9EQ==
X-Received: by 2002:a05:622a:15d0:b0:3b8:385f:d72e with SMTP id d16-20020a05622a15d000b003b8385fd72emr14627251qty.48.1679072861797;
        Fri, 17 Mar 2023 10:07:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 132-20020a37058a000000b00745a78b0b3asm1952931qkf.130.2023.03.17.10.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:07:41 -0700 (PDT)
Message-ID: <7a8ac248-f6db-4bca-e909-10d52e079244@gmail.com>
Date:   Fri, 17 Mar 2023 10:07:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 3/4] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Content-Language: en-US
To:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-4-klaus.kudielka@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315163846.3114-4-klaus.kudielka@gmail.com>
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

On 3/15/23 09:38, Klaus Kudielka wrote:
> Call the rather expensive mv88e6xxx_mdios_register() at the beginning of
> mv88e6xxx_setup(). This avoids the double call via mv88e6xxx_probe()
> during boot.
> 
> For symmetry, call mv88e6xxx_mdios_unregister() at the end of
> mv88e6xxx_teardown().
> 
> Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

