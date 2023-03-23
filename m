Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77676C6C10
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjCWPQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjCWPQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:16:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C72820C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:16:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r11so88128114edd.5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7NV0FdCdmpTPR4tUEgXXTQ1imvpne0TUG9SVufmldfw=;
        b=CtrQDIr9YtafPxdosVX1CxpjjXbkrdPOriSNw/KO+zDBnl0+Fq95wh6YK/if8wlHA4
         wMNkZ4Fk4bBYsYQ/4V3QjeZViqP24XX20QvkIjLmQZbHc9EbCbkR9nJNzGgtdc6UUEPx
         +9hnU15VnDmwaoNg3palWrQteE3EiwTdfClaUQFbRxeG4DkMUWaFJhB5kATuKj8efYfy
         roDeKxoMliVkVlGy9h8Esf35n9eWWUdggOqZY1vWHA8Rb9BiM50E4bLLrlbojXLGpNI/
         SNdFeRDhb9EKoQ7Wg4eRpDlLetUqEn2EN2fBhPdFhikw4rMdsB0D3AbxSkvVZdSf9rQ2
         8diQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NV0FdCdmpTPR4tUEgXXTQ1imvpne0TUG9SVufmldfw=;
        b=HnrYupOqFZDjrJJYOtx//YA9y2vEjkHTGZVILEYjWuvkxnlLRfqVXLYrP+XHLVyqSr
         DJKVfzfZgC5nHkB7HxES5knTklSN3GfEVyFLVUlpx6Wa9dmUcM/O7UtxrBPTc5xYl2GH
         SY/nZOJEY56NTu7+paLR9ZPtuaMfdaOi0bwhuhh3fHZvMpxjaPecZV3QgqE58Yn56Fss
         0MdBwFUfQwBzO5rLnucUd/LdjE80YiT5I6oltIcKr97jS2SpOSVgASlUWYFwPZW0+tlm
         CPecrcjNfjqP7/TKcoO5Ek106mg9biE3RifwKE4MyVoSjiVpnezNBs9we5/WqnYxc2//
         9gRA==
X-Gm-Message-State: AO0yUKUPgWrVYm69M9QogRJqa/QW+NMNsH42CnsdafcocMBKWiVQVQvh
        z8MZn+fa9gVk03M5LvyQ7SxPrg==
X-Google-Smtp-Source: AK7set89nottzD5EmBaHXou1Ja6Ha/INX9/SP9O1tPCuMeGGNFpWd4AG8WZz08PEe6cXjjCRrlTy4w==
X-Received: by 2002:a05:6402:2061:b0:4af:6e95:861b with SMTP id bd1-20020a056402206100b004af6e95861bmr5761814edb.2.1679584601215;
        Thu, 23 Mar 2023 08:16:41 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id r3-20020a50d683000000b004c0239e41d8sm9298559edi.81.2023.03.23.08.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:16:41 -0700 (PDT)
Message-ID: <b858c5e3-0f35-1630-2726-b6d1c59e5119@blackwall.org>
Date:   Thu, 23 Mar 2023 17:16:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 1/7] Update kernel headers
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 15:01, Ido Schimmel wrote:
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/uapi/linux/if_bridge.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

