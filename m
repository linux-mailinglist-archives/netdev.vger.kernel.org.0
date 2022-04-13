Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBCF4FFBF5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbiDMRDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbiDMRDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:03:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B0A396AB;
        Wed, 13 Apr 2022 10:00:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u2so2333927pgq.10;
        Wed, 13 Apr 2022 10:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LVT/IqTiL4DPI+1/TfUzzSpihSGgSvz9M/lMHXDrAk0=;
        b=DMFFp8zBk20loRKK6VrzU3XOnHeYdVsxMY/Y319ns+YlT17GGcq4mGYA+f8ybz3sS/
         VEeYxQK0QMzvDBdW4D8G1poSmSR7K6VrcL4TtFy5lcjz3lIPgzRLDqc00umBrohTbKCA
         Dua+AQoMzdM7cWdLEk0EBOYhX2nrc6uFPu96j+PtGo+gSSKKz8Kq5MQBDIoQ4yOCsZTw
         o0jr7uOJj4EuO3kb1nObIOc+W/oSkc89eqT+KBf6pz6O+og4eGA4tRR39DOOJOiDlUIx
         mX/3314tshocD1S3vQfviwIIfrY+ElFx62ogEMLNR8UvqlUKQnlRqxpQPKvJYETCGwRj
         zoIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LVT/IqTiL4DPI+1/TfUzzSpihSGgSvz9M/lMHXDrAk0=;
        b=J0mCGAiG1FKpwE4TwY8ouAr+730CEf7WWKBQ/H7zgfw6VNToi23S4eowEaoMtnqcTF
         xgxVn2A3q6PJcsik5wyg+3SQEAWt/9DfnsXn9SzeYNquaNnDj4hhACeaywWp9+pIEZhY
         rTsvNHRQkdRnmfiSNQ0p3PTonHDcBg0gpz2Ji8SNDrucHZBACDQsqUzcILArp9trCbQ1
         Hs6VjUJWb+5JwxmquDF4chdCbam3R+s3O0YvybEg25lkedOimJKeARN1HvbaKoJHF6RN
         yeS0g2qaTM9UDrYWi4QZb7EHCBcbFew8bR3WgbsfpDBUAUfmv4U/1iNSly09A8x/Aqqq
         OwJQ==
X-Gm-Message-State: AOAM531+qzBPvZiTFSE4yKy4vtNI0lswVXLqLYc7qRZ187cCYXa6QkuL
        gYGr0nBrUEkRgy0bZpTMn9M=
X-Google-Smtp-Source: ABdhPJxpsoiZu+y6nvhELKT78t1SuXGumeIs6lb3xq1rl+65Q5Odsu2ZORqFbqrxczmauyzRPAfYxQ==
X-Received: by 2002:a65:4081:0:b0:381:6ff8:f4ba with SMTP id t1-20020a654081000000b003816ff8f4bamr35186933pgp.457.1649869256819;
        Wed, 13 Apr 2022 10:00:56 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c74-20020a621c4d000000b00505be1ae39bsm11591013pfc.9.2022.04.13.10.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 10:00:56 -0700 (PDT)
Message-ID: <3f4972d1-ace1-0260-16e6-84fd0f475273@gmail.com>
Date:   Wed, 13 Apr 2022 10:00:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: bcmgenet: Revert "Use stronger register read/writes
 to assure ordering"
Content-Language: en-US
To:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, pbrobinson@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
References: <20220412210420.1129430-1-jeremy.linton@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412210420.1129430-1-jeremy.linton@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2022 2:04 PM, Jeremy Linton wrote:
> It turns out after digging deeper into this bug, that it was being
> triggered by GCC12 failing to call the bcmgenet_enable_dma()
> routine. Given that a gcc12 fix has been merged [1] and the genet
> driver now works properly when built with gcc12, this commit should
> be reverted.
> 
> [1]
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105160
> https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=aabb9a261ef060cf24fd626713f1d7d9df81aa57
> 
> Fixes: 8d3ea3d402db ("net: bcmgenet: "Use stronger register read/writes to assure ordering")
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
