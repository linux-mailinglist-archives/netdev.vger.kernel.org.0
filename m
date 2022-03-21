Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917E54E2B27
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349567AbiCUOrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349566AbiCUOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:47:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BF63D1EA
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 07:45:44 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so10853635pjm.0
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 07:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=aFtzHukDOsPh7oen/B4JvLuKORG3UNcB0KYqjhFfi0M=;
        b=Hi2UfaQ3RJtABhMxIXoCgcH2zJW3h3SOTzhmNhYw+0Q9b0FtGHGxLH2Rh30IqgPZNw
         ZOfw4P4gBX9EmqO2PisZWwgon51ROeIAMkCd/uhCd37GH+zpJTd3SQCr6fTEOUbi4vPD
         MO4fh8S57kvZLaqS7FS/umbpIaj5KigW0zyGIOB7XZiwa+irQmVda2GIKqkwP73tmXJe
         PANbIsOxgbGcBm75P3T58Sd9cSTW6stpQmBGCtmaND8JzYbhOoab8sfzaYsinEbQiBp8
         HbBBZ9Ei2wuLIl46nEa+3EBP9nRBh43X5iUiunjBN3cWnwdr3Omw0xKGy7XfipcDcnIN
         72xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=aFtzHukDOsPh7oen/B4JvLuKORG3UNcB0KYqjhFfi0M=;
        b=QJMwBtNqthRVQb7lvCN6w48ORMuxovCWP9s2PUcLl4l2+BJcByOMOudAyH231h874r
         t9Kcr/bDjse6Wsy2GH7etOdnhYvHISGtfADUTDz22H3VFc6gjJZ+U9WtTHxLFHs/IXob
         o5uWP4hyJyOkWwcE6XTtzOBYX0JqlwvRlcHU9yZaD6+wrsy4cMcSLcMzEe/gTvkOQmka
         0ii+V1ewNIkztOCGUq9XNXes9kezY6LXMnZYsJgQEeX2hAz0bUx4jqznyZ0cKO944DX9
         mhoKFKMk6W7O0YSyRkZMyDNKa3Qd+t2DFGiTWe/TuuEDT0/ewpdslE/WZM3GLrtrpR+j
         woCg==
X-Gm-Message-State: AOAM532ZgetQJFQrqUEhXz1EYcpb0YtMRCical1jLETwjLeEbTzAZ75W
        AuxgX0mv5xnlhh7TUUN+4Z4KdA==
X-Google-Smtp-Source: ABdhPJx/CEdsWkzqSdBvMtPn/oyRpsIriWlug1FWslnVxxagoCiwXmx0u8rRxKN7SlxC1vEOaVltEw==
X-Received: by 2002:a17:902:f68e:b0:154:6518:69ba with SMTP id l14-20020a170902f68e00b00154651869bamr3586480plg.60.1647873944044;
        Mon, 21 Mar 2022 07:45:44 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id t6-20020a63b246000000b0038085c0a9d7sm14812383pgo.49.2022.03.21.07.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 07:45:43 -0700 (PDT)
Message-ID: <4a96a044-5743-5a33-9812-bda4c12f0a25@linaro.org>
Date:   Mon, 21 Mar 2022 07:45:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: apply commit net: ipv6: fix skb_over_panic in __ip6_append_data to
 stable
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Please apply commit
5e34af4142ff ("net: ipv6: fix skb_over_panic in __ip6_append_data")
to stable: 5.15, 5.10, 5.4, 4.19, 4.14, 4.9.
It applies to all versions.

-- 
Thanks,
Tadeusz

