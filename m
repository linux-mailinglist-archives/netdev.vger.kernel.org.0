Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6376B9B72
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCNQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCNQ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:29:06 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0B4AB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:28:40 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v16so14965350wrn.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678811318;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=088HML2+yaR7fPL/wnUjkyP/4ibGlSpntDG0tuLos2Y=;
        b=faTt21JFeC6psA9UEvePBpZs5Z+GwElAjeKDdLU7mpBxYhOWPXHWvFifiLGKQpCZdm
         phLhuwfRKI1WrXyEJcwNtecS4uf8LaU2SpMBkDcCygLmtWRndStnA9kvt4pDdJ9qTwvy
         lA7B5JHkHYspWu5r9I3DjLUIzoAr8/kVWfdpRVljrwyrKIJI66BGmrD0LqIlg8i+7TAj
         wC5NleF/PzjIlu8+iBST4R/CaUUyQ2RAm2q8bjMTYnDJuvtx3o7iNiTDHb8BJIYGK7qY
         MwQuIAp13eQDOe3J21I/E1q1nv+bqNas/hEJpGtpuabAWBlHScN2PYfqvNJzyiS4/D8b
         R/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811318;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=088HML2+yaR7fPL/wnUjkyP/4ibGlSpntDG0tuLos2Y=;
        b=E4YmLQj4M/T+ULmejZTJrqU48Sc4GMNok9TaHJRBYjppqXt26QEZm3ZjfLGcmv4Ii5
         dEb3JgcIaFB3cZfiDwCIOK10obako7LnmywiLECq6Zieo9Zjqo1IPeX4ZHQ7ksT7NlYm
         V7UXfbTDJdkFAs+UKpzhYloheVA/Nh0RnyGldeTO2M+rEg8iCH+ybc2VP2PtrStS10I1
         rV5U3e1uj5915/4Q6O8Q+5UE6VCwKEEBSXZ9v9oXpSBfOOlI3zocQa3XuCX0CQkJLlIS
         HuJO4lDwUTVOEX+IWwq6gouUQFVQrqonofyXXJX7EZCt0vte19S7pXgdZj+AqtsKhgEX
         DX0w==
X-Gm-Message-State: AO0yUKWHXd9xX0maFIQ52RiJa2P7aqsMRrAK6J8hPbi1E+RtorUM0GIL
        rj0Z6n3XCjRiz2JliRHt3jU=
X-Google-Smtp-Source: AK7set9TxsVRlRNLTCDl1vTwQ5CVCILh2GdW+VQbdjjFWFV3xeIEIv6Vw94Q4WBhwRUllmpPgopqeA==
X-Received: by 2002:a5d:634e:0:b0:2c9:850c:6b13 with SMTP id b14-20020a5d634e000000b002c9850c6b13mr27477980wrw.67.1678811318507;
        Tue, 14 Mar 2023 09:28:38 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id e6-20020adffc46000000b002c561805a4csm2478418wrs.45.2023.03.14.09.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 09:28:38 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next v4 2/4] sfc: allow insertion of filters
 for unicast PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-3-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1b25b297-e427-9c83-89ee-80efc6f206eb@gmail.com>
Date:   Tue, 14 Mar 2023 16:28:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230314100925.12040-3-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 14/03/2023 10:09, Íñigo Huguet wrote:
> Add a second list for unicast filters and generalize the
> efx_ptp_insert/remove_filters functions to allow acting in any of the 2
> lists.
> 
> No filters for unicast are inserted yet. That will be done in the next
> patch.
> 
> The reason to use 2 different lists instead of a single one is that, in
> next patches, we will want to check if unicast filters are already added
> and if they're expired. We don't need that for multicast filters.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

> -static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
> +static void efx_ptp_remove_filters(struct efx_nic *efx,
> +				   struct list_head *ptp_list)

Personally I'd name these something like filter_list rather than
 ptp_list, but no need to respin just for that.
