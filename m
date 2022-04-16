Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37CF5037EB
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiDPTcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiDPTcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:32:09 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB3164719;
        Sat, 16 Apr 2022 12:29:36 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q19so11989820pgm.6;
        Sat, 16 Apr 2022 12:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/BjQcKMSDpf6lmiVBQLJmYeoCiRDmu7xV/pJ44ZnW90=;
        b=XWUs9NjXbkOGguNEF20D+RRHlWIYhvJ7lvqgCAH9Q7Q4auORjrZtYxTiFy3EarvtLS
         4NEt9N6FW1u9i1Fkry6VTe9qZ9thmU5/3F4fTY9sKsRF0tvQHvSddOWRD1S+gVtdnxL2
         S+jefNoSKvIyHNX5YaVq6Pb4/Y5Q39Rxth3KSKvj0g4MJGGXesKGJUTfjYBGgqAvP5YM
         Ebvu+n2vMxzNGW9mYY30PUu2edXo6ZN+SCShmk7RgbB9LY5VnNaPuOSKzjGXnKJk0djn
         3B6fgg3Md958BBGZFNIOuOien6x72+/15mvqxFoAtMpYwZ/W6PIX/IzMIs60I3O5AArx
         8Agg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/BjQcKMSDpf6lmiVBQLJmYeoCiRDmu7xV/pJ44ZnW90=;
        b=j7M5ljoCjeVCJiy493lGu6ZRk1rFo/ztgK6NC6I5v/TmI7bYwGcm7vnnR0S5H5r+rn
         XwBGxbgy+hplZaVUOiEKs83lTYdrhv5U1HlAPynZGWX5XJ0pHyZfBb72kFn5muCB/MkB
         9mRE04dRrC53hHIkXeEg6IAZZZQt03fM/TygFZbZmL2XVs+SX8bz7d9PpL3VuYOs7Qz7
         YLfmGt1Q1PSt2WwVRbPIdGYx3sIssJZBYq7izSIA4nhnK6V9V6J9BVHHtYPAl+3vhzqJ
         atavSCuXue+bj2WM3XPRfKPp1nYc4FxJEVaNS3voAlTWPdQNYtAwWRAg6XNDD6p2RkNj
         9k1A==
X-Gm-Message-State: AOAM532GJ/z6n0uLuqBIwcceCNk3Hie2HW0vrZISPg63wkX1CB7puceY
        Biu0qSf7vesOrq9ZFxHvAeo=
X-Google-Smtp-Source: ABdhPJxdn769OvVq9eNtDKecb7ES7BNuMzkn1YDbaXJCCdilsJanqpA40oHRThkZaNOEPOpebxxv+A==
X-Received: by 2002:a05:6a00:cc4:b0:505:6998:69b8 with SMTP id b4-20020a056a000cc400b00505699869b8mr4618837pfv.19.1650137375805;
        Sat, 16 Apr 2022 12:29:35 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w60-20020a17090a6bc200b001cbc1a6963asm8611728pjj.29.2022.04.16.12.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:29:35 -0700 (PDT)
Message-ID: <d4419373-c576-a7ef-09f7-2bf18ad8f0db@gmail.com>
Date:   Sat, 16 Apr 2022 12:29:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v3] docs: net: dsa: describe issues with checksum
 offload
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, tobias@waldekranz.com, andrew@lunn.ch,
        vladimir.oltean@nxp.com, corbet@lwn.net, kuba@kernel.org,
        davem@davemloft.net
References: <20220416052737.25509-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220416052737.25509-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 10:27 PM, Luiz Angelo Daros de Luca wrote:
> DSA tags before IP header (categories 1 and 2) or after the payload (3)
> might introduce offload checksum issues.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
