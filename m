Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7261657775F
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiGQQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiGQQ4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:56:51 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EAC13FB0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:56:50 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y15so2437113plp.10
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kobgXmuTxbLuRVSMaf6NcCX7dbl7w7BFmrUF+ylIkTk=;
        b=LagfZ6N5FvXgCTPxKkVE/0P6AuqR41s5r57Ij9DtN7jwE3q1Ueqzye9mO4/4kPofz8
         VqRHW/DKVVCM3mP4A7kNORZpnfyErqfp8i6PLa2Ksdc6w+GB1EKpoQG5VGUJSUnbE0RG
         fo3sNMADIYlFJ8iNDf00vVbdTC7AylRNX59gd522pKGP8XAhhCg7MWyzohg1D1w7f0YI
         5nW92EzmZN9MVKh1MD2yltMqpGLb5n8IgLuC6dcpdn7SeSDmrO7mzpdg5bukLsKjGUyz
         utH45R6V7vPaD4SoUe0Ccicwjnro/dFznN7FqjdXJbUIUtzLDA3HJNxYmhrDaerklETT
         8TmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kobgXmuTxbLuRVSMaf6NcCX7dbl7w7BFmrUF+ylIkTk=;
        b=OxPVCXwduTkMycDFQYRDCs5yQvrVGCp5OOvoDTwbE2zKLaZjNro/niQYgv3GNZ0ZmQ
         wUVMmWkci0l9IKLiUZMUYZxid451gj62e/X2LBLEcxjgJnkE8yrDhFVq8T3a6+gRNsjS
         ec2kV11MILOJxYOtDBDi7S4LQb3oIZ/WJL4G+7CRv84EoU812U27gW04XHHjVjB9+2rM
         OH5jUJj/IXV0eDYENUy/ASp09MpfqPukLOdjx5kPfou/lRU7q3ShJ+PBph6tknpE/IIf
         3K0QdfhoeOTRqS7gLLWtWBBVoqoo5o1JhX9IRvSxkB9+06+K7vZbJJjworNIKgaEcleO
         Newg==
X-Gm-Message-State: AJIora9M7N3blMEo7l86e5IlYdF76K92QvJHH2xCkoG731q6YKJTQOzG
        JM+/x+xWAvYIHpyrYmW/7jI=
X-Google-Smtp-Source: AGRyM1vsE3RWR8NnSw7hgemAu4HerEXyivPssYBA892wYiulkprdvVaa0VdMMyLtJhDeSiFrztoDAw==
X-Received: by 2002:a17:90b:3848:b0:1f0:2686:87aa with SMTP id nl8-20020a17090b384800b001f0268687aamr28131415pjb.67.1658077010234;
        Sun, 17 Jul 2022 09:56:50 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id f6-20020aa79d86000000b0050dc762819bsm7464860pfq.117.2022.07.17.09.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:56:49 -0700 (PDT)
Message-ID: <8d99d06a-adfb-5976-4dbc-11fcfbcab7ae@gmail.com>
Date:   Sun, 17 Jul 2022 09:56:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 01/15] docs: net: dsa: update probing documentation
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-2-vladimir.oltean@nxp.com> <YtQnWsz/X6yGBo3g@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YtQnWsz/X6yGBo3g@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 7/17/2022 8:14 AM, Andrew Lunn wrote:
> Hi Vladimir
> 
>> +Switch registration from the perspective of a driver means passing a valid
>> +``struct dsa_switch`` pointer to ``dsa_register_switch()``, usually from the
>> +switch driver's probing function. The following members must be valid in the
>> +provided structure:
> 
>> +
>> +- ``ds->priv``: backpointer to a driver-private data structure which can be
>> +  retrieved in all further DSA method callbacks.
> 
> I'm not sure this is strictly true. The DSA core itself should not use
> ds->priv. And the driver could use other means, like
> dev_get_platdata(ds->dev->pdev) to get at is private data. But in
> practice it is true.

The former is a tad more compact and "usual" when DSA already provides a 
driver model IMHO.
-- 
Florian
