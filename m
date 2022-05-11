Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED1523A47
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244893AbiEKQ00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiEKQZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:25:57 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28753340F4
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:25:56 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id n6so1758570ili.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h5ZgkqhZZ3FQRhe44vaqQwyfKdnhgByHa8KzMVAkb3E=;
        b=LMuYvzmAn5l/HIj5V+BLw0xm1CGdVVum476ox/esF9cujzkORE1KYtoEH6pXbKVDp9
         kfyE3oPXet20gXNokeiWX29Jm/Qd/vNKlX3hDKUNVR5fHP/kNCAMwfbC/ubkxe9e2Br5
         43eMcziAA3Z2I/+zfjGc6o3bN/E1I+c6nDMdAzKWn7rT4AcgalHXzAJ7YnoabYET4r4r
         YrjxXeXpf386v8ErW0t0lcub9NOYqCTjUtrHVm4i21672i1npy2Rz29pOAP1lcUszBk4
         gkeRdf623fV1rTeXI4nOynA4kqqdQoD6oQ6zUCTOSVgwnlklKDhLHfUFF5sAhZRmuNZQ
         pc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h5ZgkqhZZ3FQRhe44vaqQwyfKdnhgByHa8KzMVAkb3E=;
        b=OvNmBjNLCO5w7RVv/sxgvA9gZT1eMCwZqY1SQAU1vWY0jt3TtaJbiOWy7QnReicJoK
         mUKNL+Y5JcL4Uld3liOHD1QB7frCAfv5P4bNQC6QhZk44IdsNom5ZQdrO6s2jOndY9d0
         loyLosj9N7LsR05U0sNB62ra+Q89to8l+vFd07Ev7+F4YhNVBNFxuxj8GIIWLQFfce52
         NHI4MDre8k2vue3jAw5l+aC4oeHGUFPDahwaZI8p+Bx48DOdt1K0f/aKhhefWUnct6e0
         auNlYgbDAW4ryJcFkC/iraeQiqBahx18wfbUTbLPsBHy6V2Zsn4DZihQx8uJNk46abfJ
         aQpg==
X-Gm-Message-State: AOAM533nC2CSjwRyvR9wmMxTEZpwwwgKl8npLbmnR7X32mgOqIGZc8oQ
        /Rh/2rpph+2DZ/s/NmiRjE8=
X-Google-Smtp-Source: ABdhPJwb3pJYZQmepGmTGlY3QbNOekj0JBzn1qisSADlt2A8CuqsVCgDix3xbLA7NJvV8+3bH+tCpw==
X-Received: by 2002:a92:6c09:0:b0:2c7:a105:d426 with SMTP id h9-20020a926c09000000b002c7a105d426mr12215276ilc.111.1652286355608;
        Wed, 11 May 2022 09:25:55 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:e970:4f57:6d9a:73c8? ([2601:282:800:dc80:e970:4f57:6d9a:73c8])
        by smtp.googlemail.com with ESMTPSA id a12-20020a92c70c000000b002cde6e35307sm714402ilp.81.2022.05.11.09.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 09:25:55 -0700 (PDT)
Message-ID: <3a9a491d-81fa-af56-8f30-20dc1df735aa@gmail.com>
Date:   Wed, 11 May 2022 10:25:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: gateway field missing in netlink message
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Magesh M P <magesh@digitizethings.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504223100.GA2968@u2004-local>
 <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504204908.025d798c@hermes.local>
 <DM5PR20MB20556090A88575E4F55F1EDAAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <DM5PR20MB2055F01D55F6F7307B50182EAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220505092851.79d3375a@hermes.local>
 <DM5PR20MB2055542FB35F8CA770178F9AAEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220509080511.1893a939@hermes.local>
 <DM5PR20MB2055EBCA16DFB527A7E9A32FAEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
 <DM5PR20MB2055B826355ED50BFCF602C8AEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220511085619.4b549ee1@hermes.local>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220511085619.4b549ee1@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/22 9:56 AM, Stephen Hemminger wrote:
> On Wed, 11 May 2022 05:35:21 +0000
> "Magesh  M P" <magesh@digitizethings.com> wrote:
> 
>>  
>> Hi Steve/Dave
>>  
>> Could you please confirm that VPP during synchronization of routing table with Linux kernel in case of dual gateway ECMP configuration gets only single route in the netlink message is a known bug ?? 
>>  
>> I am using VPP 21.06 version.
>>  
>> Regards
>> Magesh 
>>  
> 
> I don't work on VPP.
> 
> There is no kernel bug here.

 +1

if there was a bug, FRR would not work. Bird would not work. iproute2
would not show multipath routes, etc. That's why we gave you references
to known working code.
