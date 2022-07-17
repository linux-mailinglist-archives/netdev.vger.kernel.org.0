Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CAC577763
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiGQQ6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiGQQ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:58:07 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DF413FB0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:58:06 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f65so8668480pgc.12
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vq+taBipN1pqm5gycaVar+Pwbq8o+HiEz1hUTU7uk0Q=;
        b=eIb+zM7Ok1jFFbq+t9TdPZpNKVz14zJVCIMOcHBp9jL70CL/7kYVzZjf1OZe3u+Ml9
         zFDUt9ZJUSSuDCQTVP57Kzl7BJaaZQad78X7mML+jNyHxQvgoAVd9NLacy68lW2XVsxO
         A3BSuSXqMFvQipZ21PUk/9YmlPyhpstliBsxeFiFv6rJlb9kG2qk8SWjObozxbhS6irg
         tGguj7ZqURseNhHT611e6VjERL3Gy82NhK6Nwxyn1Y2gprJuammU1iSKcvGZX12dV2fW
         mhYWjGkbzmGbF3vQnmK+0giH0kIxiT4xTpaXiiIoHptHiFoCPqezZ5WIen7peIPF8BrC
         +AKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vq+taBipN1pqm5gycaVar+Pwbq8o+HiEz1hUTU7uk0Q=;
        b=FRl6AZ4YS59Kfou2HdgBEpBFBsf7d7T9CZGzOQcpdm3J5H8gJDRp3YyzRMjvm4K0SS
         amBOhGODKA7NqIiJkEwUcjnhmgBvUntqvZiu/OeLi8dz7eVjCVsWMjN2W+iH+c+O7lSZ
         RNq04GauCJDxWTTB1pX908Z/3A8q2YaYwnbGwoC98edZ3i68d9uDpS3GT+L+da9Z4VeM
         XaZjWWxhB4tOTDha0FFj4oXhErLNXFe9W3jiHtjOz0JsU4NqUH3cZ9KRZZ3Fv/HHinDP
         EnVga6kYK5pW/viRJZN7VJiC8OZe1hzjhJs+PAOAin4+r98Sb5w5snLwHFN8OtLgVbdN
         0HWw==
X-Gm-Message-State: AJIora8PBAtm0VXVj77lEVoLD+k6bS24uNsTsVNg6OYRauefXHVpSmPt
        GapzECcivem4wJCZScdXNAk=
X-Google-Smtp-Source: AGRyM1vEsrlQCb+q8ABrVS8b46jfT8BgFL0WaZprlxnxgNml1Rm28wpQBIxkVyDVL5GWGPYvAZvjPA==
X-Received: by 2002:a05:6a00:c91:b0:52a:cad7:d755 with SMTP id a17-20020a056a000c9100b0052acad7d755mr24541979pfv.66.1658077085651;
        Sun, 17 Jul 2022 09:58:05 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id w20-20020a627b14000000b0052ab912b0fasm7518158pfc.2.2022.07.17.09.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:58:05 -0700 (PDT)
Message-ID: <d3af43a8-beb7-0558-8a4a-7c80a029a7e7@gmail.com>
Date:   Sun, 17 Jul 2022 09:58:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 04/15] docs: net: dsa: add more info about the other
 arguments to get_tag_protocol
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-5-vladimir.oltean@nxp.com>
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



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> Changes were made to the prototype of get_tag_protocol without
> describing at a high level what they are about. Update the documentation
> to explain that.
> 
> Fixes: 5ed4e3eb0217 ("net: dsa: Pass a port to get_tag_protocol()")
> Fixes: 4d776482ecc6 ("net: dsa: Get information about stacked DSA protocol")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
