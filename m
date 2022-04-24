Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7EF50D5FF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239911AbiDXXcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239900AbiDXXcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:32:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD6A72E30
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:29:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so23276109plg.5
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8Kt92Qq39sgo1R/JG9HdB/qZXRtwngR9PqHAR/vfNMc=;
        b=etVkTMsdLaJexrZJL1O/1Z8aLncjXgCh55wU4ykE1skqUN6nJ/ZmXg26z9fCMMFrAH
         P5/aBn+llYfoow+cIlyBdJN2iss0gO19csOz62EySOZoaBJRWF6U2JsA1/Si7ImqSoeM
         uxQAihpjAw2lBOlQeK4lGb+qkBy/ZuUVYY2K3mCeWD71yWYYQpkckPdfIz4W/6x/bvLl
         6z3rWqjWGciiUIkwIQ+s9ZzM3DGa/GRlblkHAHJRF9YuMbcONyDPXwQ7kinjhzAsAlpZ
         CHS9HSGxAN1iVBVpgCZoNYqubgoibmq6DecoLYDcTnVtXOp6oSmcP37JwCRHhMocjs8m
         7vUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Kt92Qq39sgo1R/JG9HdB/qZXRtwngR9PqHAR/vfNMc=;
        b=VVdFF9F65tsMjG+yP/fq7sL59nZBEDRtx9NJSbLNOxFZliF6dUdaXOaem9qGBdcp2W
         75K7qW2IWz0nqVPXHPJF9rMpem1MW8nsCPJj5SrGuQ+67Yi7YnwWj+kjbLSYvKtbHgz8
         cXePMUF2OE0wYMJzQS/s4Uyv7wFR5MH13CeVELv3d8TCKDG8WATVH5DXrLdJoddTyJLs
         WTt2mFMh0IZ9gLo+UxezduTWh/hqw0efn5YOrZy2RYpTZ88nLQ9ySRkja49OhAORqDlN
         CDjqZOxcfuniBWASdcGh5F4vxkwlBKEC/J9d83glHqa0EDfPckDVV5/QFp+QHFCLZSR0
         vm/Q==
X-Gm-Message-State: AOAM531SQ5USqGdhLePch2FYwQHjHgGuMoODy1HV2RZD71pvFdM/Q9pJ
        BLiwbEtJmaM3XWk9QDL3Maw=
X-Google-Smtp-Source: ABdhPJxdx2mxQbNdzoSS/bXmpEML9zHOclZwryU4TOd0QvcSZnFjzrATBeU54t37b7OoI6vMdNROsw==
X-Received: by 2002:a17:902:f54e:b0:15d:7b2:2ff3 with SMTP id h14-20020a170902f54e00b0015d07b22ff3mr3956982plf.95.1650842983443;
        Sun, 24 Apr 2022 16:29:43 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm9940959pfl.141.2022.04.24.16.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 16:29:42 -0700 (PDT)
Message-ID: <c0c55a0d-3d85-7c78-c244-dadc21d67547@gmail.com>
Date:   Sun, 24 Apr 2022 16:29:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 4/4] net: phy: Kconfig: Add broadcom PTP PHY
 library
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-5-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220424022356.587949-5-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/2022 7:23 PM, Jonathan Lemon wrote:
> Add a Broadcom PTP PHY library, initially supporting the BCM54213PE
> found in the RPi CM4.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

This should be squashed into the first patch.
-- 
Florian
