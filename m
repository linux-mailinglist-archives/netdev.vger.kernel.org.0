Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7433950AC37
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbiDUXrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352487AbiDUXrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:47:22 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E273EBB5
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:44:32 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id e15-20020a9d63cf000000b006054e65aaecso4369155otl.0
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ipi7vy/XqKXxDevk9uzIafC4wO5mSq+VuTBT1AV0Idw=;
        b=i/IncPbeY3mMMXRDoGqvCwthe4k7VlYSofs4KmSPRvvy7f5ezHS8zz7Y9GgztcT+cO
         fKdy5HO0O1Qdoy2kaER3R0HS5MWC81nFL4zm9nBFlT2S4wiEqqfTt/rUABtt3w5GzZ7m
         VNc4JWeZK/K7zBRtNm3W/DyIt64YZI+RDgChUb9AFrOOYnZR+AB4kG3VVv7Oe9VC9MCu
         m4YeuCwoVIeBcFKTVCDhkdM53plrFE9lJ1Ut6waDMK7hnvtXc2yaZFR9cWygbu4vkuhN
         upP8hP4Ex1UVpklFF+i7VQAiSP28fHWDVMiof6wX4oUtsSEglti/8MiO8JCEYTnd6xBZ
         IwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ipi7vy/XqKXxDevk9uzIafC4wO5mSq+VuTBT1AV0Idw=;
        b=ixjvkun2CjsU+UTZMlNbvgbAecemSIGTsBLcAlM+H9jB1COm4U8qR6LdwXBiRaJcmP
         TUsWf8YS6po4nSVEPX7B/YWf37F1q4hNh8E99+8QvdYqIWFqczqOysnCwNAlERcTIfh/
         iCee588a9MGB8Dk4+Mqs+dlOBPXCkFrxMuoHbvYpUicwwY4iirahkB0B/buwuMiwsPBV
         46Pt6NzqLBopQPDB1YtXOyvow5ETv1DUyH1Q2KrUh/fuqqZBBGWS/qqMq4oPD7rib8An
         kgSQxm3mfkw8020xj5GY7NWibEbGcZ4WdiUQFDggB+vYbxr2wRRdDtMGh+N1Eg+HTrrq
         TyLg==
X-Gm-Message-State: AOAM532AhxUfIhNbl9dL4dtqW3GR8GnEyYfJEtQgbvP85bu+LPvb7ks5
        xQyPd6ViW8WwAK5spiU1MSTjaSQSB5mYtg==
X-Google-Smtp-Source: ABdhPJzEPWWd8KcQQqjpRUO73IO22ZcFSJKDJhCglS20P93Txo54NGNY8Y34aFLbMEZmhaiOj4Z/sg==
X-Received: by 2002:a05:6830:2810:b0:605:689d:4fd9 with SMTP id w16-20020a056830281000b00605689d4fd9mr822293otu.212.1650584671500;
        Thu, 21 Apr 2022 16:44:31 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id g8-20020acab608000000b002ecf38fb699sm189399oif.38.2022.04.21.16.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 16:44:30 -0700 (PDT)
Message-ID: <b5eedf0d-1866-2b8c-10a7-d682060ae6cd@gmail.com>
Date:   Thu, 21 Apr 2022 17:44:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: IPv6 multicast with VRF
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20220420165457.kd5yz6a6itqfcysj@skbuf>
 <97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com>
 <20220420191824.wgdh5tr3mzisalsh@skbuf>
 <a5fdf1dc-61ef-29ba-91c3-5339c4086ec8@gmail.com>
 <20220421092429.waykidesd7de4q3o@skbuf>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220421092429.waykidesd7de4q3o@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 3:24 AM, Vladimir Oltean wrote:
>>>  ip -6 route get ff02::1%eth0
>>> Error: inet6 prefix is expected rather than "ff02::1%eth0".
>>
>> ip -6 ro get oif eth0 ff02::1
>>
>> (too many syntax differences between tools)
> 
> Could you explain why specifying the oif is needed here? If I don't do

multicast and linklocal are local to a device, so you need to specify
which interface to use.

> it, I still can't find the route. Either that, or what would an
> application need to do to find the route from the VRF FIB?

applications bind their sockets to a VRF device or a port device.

