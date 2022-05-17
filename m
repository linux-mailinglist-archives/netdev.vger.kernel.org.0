Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE9252978F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiEQC6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiEQC6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:58:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF1A43EC6;
        Mon, 16 May 2022 19:58:09 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r71so15457345pgr.0;
        Mon, 16 May 2022 19:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mPJLslM5RRqiZiFY4BuepJBLd8qsiPvEF8+i3ozyicA=;
        b=dDgPx5lzeptkgdijXzbIWbMIr6uHOPhdPWaTbUDcee6zfWfVrgn4Fw6kB3AEjc6gW4
         UC+XtxFc9Ks47Bf2jEI4Kt2vYlVNxYIXrPeF4zfdOX3Pgw3uMD9brvYg3zK1R9wEGvkM
         q1N/D82Zamho8h4fjR1QE4TacaHKiazYB27n2Z4a3o1YndlIhD9FHDeeXOvz50TQy0C/
         ar4I46honPE73aXpRq8RYrs/3r9h1WG5r4SQ7IxM948jfLiH7mPjcp0pK23rm5gjmbS0
         5rGLqNVTI5rdqElnxUhknkzVvyc29fulptxlZPuwKq3Yd9RoTrqCqMBx3CtqdNSCtePx
         Bskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mPJLslM5RRqiZiFY4BuepJBLd8qsiPvEF8+i3ozyicA=;
        b=yQZiqzM7DfgvFC3q+Rd/Uko2uiyGeIDd2FB/cAwM9Q8DEyLpa5zQbuoftYBFAZ5Fjj
         ckIGdazu6nzoL5QWQP5OY3QY3mwrvkRYLxwK9EgewWwovK99gm8YxQGQmvZdMGZmOJR4
         +yqO0BvwGFG+bMkRXfDlEhZ3yXxO+3uk4x5VMo+oQP7WDOMwv4q8lNUz+jDRumfKWrSz
         JUDY7cLxjbLBjUIDe2Mf9qrhFP2YXetAroWSITIZu8lZ/G+tEtIqvxlpUFLZqGaNJmna
         rtTnR5ODyL6TfTXWc9KhUwayx8qNTWWCkK00Ehc3gqbgOYb9v0qiIai6+FDSGhHxScqk
         87GA==
X-Gm-Message-State: AOAM5307vd+VeThTzFkf/+dA1KxJaxPjX1Rek5bHt3+UkPtGk3EdNDed
        cf+kDcHWYo2CNkM/cPyQiw4=
X-Google-Smtp-Source: ABdhPJynGF4it03W/dSah9kpq3mWxgEPHpqOlev0WoIUo1dDi4DzUu2hXhnH845fHxHqNGOLVezzzw==
X-Received: by 2002:a63:4f48:0:b0:3c6:b640:6046 with SMTP id p8-20020a634f48000000b003c6b6406046mr17577517pgl.118.1652756288730;
        Mon, 16 May 2022 19:58:08 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z15-20020aa79f8f000000b0050dc762818dsm6584760pfr.103.2022.05.16.19.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:58:08 -0700 (PDT)
Message-ID: <9ef01dec-687f-6e16-1921-a1a4d5b08732@gmail.com>
Date:   Mon, 16 May 2022 19:58:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC Patch net-next v2 8/9] net: dsa: microchip: add the phylink
 get_caps
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-9-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513102219.30399-9-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2022 3:22 AM, Arun Ramadoss wrote:
> This patch add the support for phylink_get_caps for ksz8795 and ksz9477
> series switch. It updates the struct ksz_switch_chip with the details of
> the internal phys and xmii interface. Then during the get_caps based on
> the bits set in the structure, corresponding phy mode is set.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Many ways to skin a cat^w report what a given port can do to phylink, I 
would have probably used a bitmask for each type of interface, but this 
works as well.
-- 
Florian
