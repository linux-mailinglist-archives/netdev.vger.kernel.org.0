Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA5E573E72
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiGMVCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiGMVCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:02:32 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6057A326E7;
        Wed, 13 Jul 2022 14:02:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 23so11524328pgc.8;
        Wed, 13 Jul 2022 14:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=IACsse4yCaH/W0ycTwk/vy14PGBR6WBNAjAh7uDmjMI=;
        b=ZH9aAKkAPQctAeJMJowNLygXykxGTHv5RinJh8kiwMO10P4lPoJioYFfTfC2M2M9x9
         alchSnHTwvnSsdJ/jYA6sVqYgyiZ9hobbdPi4Ex+QtkLt8A+A3RBeUKjDRQ6kOw5f1XW
         j8g4KLrpLO2YKF7FT/Tuwhwf1Oa9Wcesv8GJ6jCBSkUfK89mG3CzcHfUWzDCYAYvl9sq
         y/u1gKCI0oJxivP1s4y24+lAsygwnrpaY2ulaAuRUzSIbO7zJ2EQ0KLTiq++z3sZPqGt
         qKt9nz7jl6dgzHbRQcg62l4rVyGz0eqhpYYBUzuHdqqx1GaEVzfrzVACBtaymzXKyTP2
         OHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IACsse4yCaH/W0ycTwk/vy14PGBR6WBNAjAh7uDmjMI=;
        b=JkWUReTKGvUN/qRI1+Bg3VYb/A/gOIqzn2m1yz481hOoX1JJrDxwC38yB/6shiHva1
         b+iY7jtV7dslTZUPWAVQTG9fG6iHF4x2hpaA1sPU4i3jVXHIJGhn+dbAUjvlJePBCZIR
         cE/UQwoJeCgJoaKWgIf0Da45oybSyMYWDEDr7zGNZ3KGhYF/IRw1y50xaJA1Q06b4PiP
         UTjvX4OqXN76THwB81lWpo9bhBeskYO6m2dHP/CKF1oeXwXm401P6ZsVjgqft1fwEfj0
         eIINryVXzytiYafY8nJNTnR5qXVV5ctYnGRYywxnvg7myoUImrhYm/e2geBW3Saw0d44
         AfuA==
X-Gm-Message-State: AJIora98nDJ2Y9yUXTEu3MIUGILJxuY9tPYR6U0Cj2es/69hqca4TO8K
        Q2YaPRfvQRwxe1S8YMo67R4=
X-Google-Smtp-Source: AGRyM1sMBeNGf7BCwDsbQPzTpzivo7xoza87ytCquvdICLzlhbbw1COharHFaQ1uYbZFgi+sksLDtg==
X-Received: by 2002:a63:4d66:0:b0:419:8648:194c with SMTP id n38-20020a634d66000000b004198648194cmr4571530pgl.32.1657746149763;
        Wed, 13 Jul 2022 14:02:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d5-20020a623605000000b0052ac725ea3esm7696890pfa.97.2022.07.13.14.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 14:02:29 -0700 (PDT)
Message-ID: <0ce123c1-1826-ddd2-6ded-e8dd319ef6ed@gmail.com>
Date:   Wed, 13 Jul 2022 14:02:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220713205350.18357-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/22 13:53, Christian Marangi wrote:
> Move qca8k driver to qca dir in preparation for code split and
> introduction of ipq4019 switch based on qca8k.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
