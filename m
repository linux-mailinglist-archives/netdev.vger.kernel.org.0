Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E195764DD
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiGOQAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiGOQAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:00:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33176C119;
        Fri, 15 Jul 2022 09:00:45 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 70so5029326pfx.1;
        Fri, 15 Jul 2022 09:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5LGljlDRN/ydm3T3ODxiya+fJfbjgilfTW9xAoT3jJA=;
        b=EVG/TbMnsXixCI5bI8Tbl5G7fQB5z0fGv6UWiaASyO8WLHthHm3WMDO49oMXWS8YeK
         wZaFh1V4Vhe4cH821NUUZdjo2l3AoRXL5xvf89q0QPjU/eslPEM8CWreJqgXIzrY6msW
         KPSPWAp+ppSXRuGkn8UCmX2YD1w/C/vY0+sBwNZhVK7Ohz/KxbeO4HRSSzj24NlOvcqr
         cBUHzWLa9QSkSjhXmVtqFZQoUA3cjoPt0Fh9MzMYEOA3B35bztlfrYax929kryW8B/vj
         leKNSYVYewlvm6eT/jxTlzDqbgs+XaMO3n12TYfPqz9YIJydkzrynjpoYskxR5F8YRKW
         tIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5LGljlDRN/ydm3T3ODxiya+fJfbjgilfTW9xAoT3jJA=;
        b=BqflH+mxwzOZVihFQJwd+YkfnXqBx6NZgYGOyP/hzPQ2p42M1Nz1qP/4HTYXo51853
         DZUHem6XFQyPCsqlclY5oIeT6IAnfAIu9gu7fK8O85Vhe4FUsKcf2Ph7BcatLminSHqK
         9M35QWkEEAVLFDZT/B+KkQgnck5EpWD1hKT2SNfw4hq71SvSAcmO0w2Hb3kZ21LTWhcv
         9WAKdO+EPIMBOP3CBylefRF5fH8TCCjvKFbx1ULV+SDsRuddRPIGYStdVabriVUkumdR
         cTaYyf8odJdCGFaqIVq3hLLSqbhNnFeefzr7WjtUTKc8hm8LE9i8LhTgRiy2FY0hNJUh
         HURg==
X-Gm-Message-State: AJIora/clhRCK6oZD+43TU48NUU96+uKhanYbqqym0aE+Jn1jH+YNh62
        lZ+/PlWTFXC9QXnvUqFp8PQ=
X-Google-Smtp-Source: AGRyM1vyB8v4iIfJgL+68ZEpv0zfeBAs52DOSDB3LAww/+lbiWYnwrxaTGncp06e/qkV+bmJE9z+aA==
X-Received: by 2002:a05:6a00:1a01:b0:52a:d4dc:5653 with SMTP id g1-20020a056a001a0100b0052ad4dc5653mr14711000pfv.69.1657900844668;
        Fri, 15 Jul 2022 09:00:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i137-20020a62878f000000b0052542cbff9dsm4106444pfe.99.2022.07.15.09.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 09:00:44 -0700 (PDT)
Message-ID: <0c91388e-17a5-5304-d554-effb4bc4479a@gmail.com>
Date:   Fri, 15 Jul 2022 09:00:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] crypto: keembay-ocs-ecc: Drop if with an always false
 condition
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
References: <20220715103026.82224-1-u.kleine-koenig@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220715103026.82224-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/22 03:30, Uwe Kleine-König wrote:
> The remove callback is only called after probe completed successfully.
> In this case platform_set_drvdata() was called with a non-NULL argument
> (in wlcore_probe()) and so wl is never NULL.
> 
> This is a preparation for making platform remove callbacks return void.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

The subject appears to have been borrowed from another file/subsystem.
-- 
Florian
