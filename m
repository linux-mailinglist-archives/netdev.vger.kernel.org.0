Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1652B526CF8
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiEMWkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiEMWkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:40:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8150C5EDE6
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 15:40:44 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m1so13089706wrb.8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 15:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5N+4M6IA0vLFAD77tfKB6GuewtmXXXB69TW6Hza/7PI=;
        b=O6YLr/R0IXamLWY9hWyb+K1puIUD+Cm+n+DDPOc+fKWQzoul7Gxik89kKjMQ2AVkJs
         /7d0un4o5WaRTffjldfQCjk108M1m4gOCZw7vBvzF9moQSxdkmG8/Nim9z0UZlRQVOzW
         CG41XeK8cPFhQWOX7jxQ5HaMtzYv4aU884vuxDkQhKqIClr2+XT7zwrkXErWEBhUrNiX
         Wrxc/zK3QPNFvSnAZ6CkQzKGJh9KTpPXMv4Q6QZDCpUlfPfmWsPbrV1u6NbrN+kFavzj
         s9PckU6QhFsNRX+g0ihIm3wIQnBiSpizTdEh1Rc9MZw9qnoKzYAZvraAYPmG+WM7cSRn
         Sqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5N+4M6IA0vLFAD77tfKB6GuewtmXXXB69TW6Hza/7PI=;
        b=Mt8xR6nupjHpI69l2z5nNsfbaCjyESkS+EeoDhwGVhj2gxSrBdyTKuMKmzr5zVGZWB
         ASBXkJhgRUVslPq2N4nqQ8+aSS71GRdSACHGZa+zqm2otlki24EqBaDG+K8X4i44mlUX
         j8VZWHbnKX2JJ8NURN22AFCM5TmGqt4eXcpRbJwACNgX+hb1jG+1LBPEk0U7yCA5w9iM
         ix9Hd6YBhwYQEL8VlWFVVjogFy6gYN7pLqj1SorTTahmViHR6VnXLsUl1RExhnZ5CBgO
         v+sBkAoaN0X65lSy+P3jx33itz+Iy0Y1lx07/+EBHSMVymlEkUtWy8c+g3je+lpMbVQE
         rstQ==
X-Gm-Message-State: AOAM533hrspuUDcbA4DmpTVTTfbZpnIyhZHyAsx/CzPWvhnsFPGAWAcP
        5JY7RA5O72WNhnoGHUAaNHI=
X-Google-Smtp-Source: ABdhPJzlrvaEzPXU4qx9JmtpB7cNL+oJyshFP1jZB4qIshlQ49pRpbGoNnvJHhSeX72w4205PV51mQ==
X-Received: by 2002:a5d:6daa:0:b0:20c:6476:db2d with SMTP id u10-20020a5d6daa000000b0020c6476db2dmr5586228wrs.266.1652481643000;
        Fri, 13 May 2022 15:40:43 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d10-20020adfa34a000000b0020cdec3d6dfsm3046271wrb.53.2022.05.13.15.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 15:40:42 -0700 (PDT)
Subject: Re: [PATCH net-next] eth: sfc: remove remnants of the out-of-tree
 napi_weight module param
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        habetsm.xilinx@gmail.com, hkallweit1@gmail.com, ihuguet@redhat.com
References: <20220512205603.1536771-1-kuba@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <818fbec5-8a04-1278-aeae-17ea84bc70b5@gmail.com>
Date:   Fri, 13 May 2022 23:40:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220512205603.1536771-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2022 21:56, Jakub Kicinski wrote:
> Remove napi_weight statics which are set to 64 and never modified,
> remnants of the out-of-tree napi_weight module param.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
