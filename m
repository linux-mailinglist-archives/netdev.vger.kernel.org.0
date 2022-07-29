Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA8585683
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiG2Vds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239200AbiG2Vdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:33:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E7E8C146;
        Fri, 29 Jul 2022 14:33:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso6712999pjq.4;
        Fri, 29 Jul 2022 14:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=BbVFV3CzLjSBAtIW3aA4/l44zfKyATja+dAsWsQP5C4=;
        b=FiwD9lZRGjEo7PbZ1eZ4omDEV/3UnuBnYmVfoum02F5Gpu6I3CMneZxDYMJ+85kI2e
         xhVhE9Hm3boPGcxRlt5mFbkCMYRHaWMBunKBccRdYd87oFEkCrbcddMZEA1sKQynlj5H
         jfSqquG9LzYSJ2wiVR66PDCovYwJVdGY2wMuou4XIPf0BIiN5AXQ0BG2UAFUHxoHOYZf
         czNO7NfIpz5W77jAsxi05wXq0AVDOnzyll/+a0eK71+KoTHBTh1wisH5KkLwLv8/XqJw
         bY/QncLel1zcDpHKA9204Y/mWJTuK/ngakcqxrgX0OLHJ+HPQROb/zl13q7D0G1Z6KCN
         ILCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=BbVFV3CzLjSBAtIW3aA4/l44zfKyATja+dAsWsQP5C4=;
        b=YkCgn4Vo2oJ0dbv+Iu6ITme5Wr8Mbgmx7Db52FvS+0C4gv318Nh6ordp78YqQo6Asv
         FMCd51H6KH3RWP8YrEalhtcNzAeZhwFGl9IuKrUpm3NfYniB9xtAiTckM79j/Jo9EuJr
         9broEgXi5hmr+LRb4vFURmy2FwNR2X7HuuFB86OmBMh8/jm5xYwZSrwqgWJcdtek4Uzi
         mWTDIHfehquPtKzcgdADIAY+RqxWCDxyG6W+xSa0XGgPEDzfFOInNZuUJAjGLdR4AG8n
         nRmJys/4lGbj7HhxDHtTM983R6kmQOWWvIRnAK9sl0JwQuXqGutEluW2VaAr5GTkELix
         GjeA==
X-Gm-Message-State: ACgBeo0RcOqFjC/MRWyzK5s31qHmIaOxRRUGRhey5WDtE3D1aa3UF81U
        px54JBOirzdPMVgIRH3H75aVDjSbM1g=
X-Google-Smtp-Source: AA6agR7PT8CV9RVlF8hI0YW2yCuGdC1uHxPU0Jkgplh9SmMVTZEKBqFvHGV5hYu0K0DskPcX3oA1XA==
X-Received: by 2002:a17:902:ce09:b0:16b:ec52:760b with SMTP id k9-20020a170902ce0900b0016bec52760bmr5631876plg.155.1659130426700;
        Fri, 29 Jul 2022 14:33:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w10-20020a63490a000000b0041aeb36088asm2931249pga.16.2022.07.29.14.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:33:46 -0700 (PDT)
Message-ID: <d9d6eeb1-c0c5-12c2-71b1-93b236411c54@gmail.com>
Date:   Fri, 29 Jul 2022 14:33:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 03/14] net: dsa: qca8k: move mib struct to
 common code
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
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 04:35, Christian Marangi wrote:
> The same MIB struct is used by drivers based on qca8k family switch. Move
> it to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
