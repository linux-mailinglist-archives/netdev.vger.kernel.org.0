Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC884E8C58
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 04:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiC1CxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 22:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiC1CxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 22:53:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655794F9D6;
        Sun, 27 Mar 2022 19:51:39 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b15so11353385pfm.5;
        Sun, 27 Mar 2022 19:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gQ261RI2Cp+P10H+WpY/iFBXQys4qPm/vC9yh0f0/5w=;
        b=kcvKa9HRrD9xApF1/0hhsKpwtnt0zgbak1C3/01igYYflJOJnOOzm2pI0W3OoRarhG
         XU0JK+zVR+6TKTaMKOpKsA0Hq2Zr1s4cliaxJqjI1t/xutg2jPEx+wGgL0pLu9pd+nJg
         rKwnXwPZxjVHTuMxlUxXuUbE1SnyKCyGlTciPp8N2p+ZS/GjvPK7rWfAmlu+kKK+w07G
         TbyCgCQm5PxPbapiWpk2Cgeb1o9awwcqMfmnNvh+fNK6WcfVSd/vrqtOiQj06JdtuKz/
         3QVAIPnRF/fPJlCIE7NZ101bVZLG8eQ1CVyakM6iiWU4saBGVpvIUiNII9hfLegBro7w
         uztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gQ261RI2Cp+P10H+WpY/iFBXQys4qPm/vC9yh0f0/5w=;
        b=157zkW+wGpX+WJRhKf+MrIph0fKdC4/lNdm/IG6bHGtI5NHRyPgObcNjelbMG0+qBz
         HQiyO9M5frTG9fPeN4gkyA2Y+QhEiK+9JNjUYRwSs/AVr+DhTIlleHZI3lKRnmkPxyIG
         ZfkE27g2tbniXRiVQakT4pld7r+XFtX1aUBZcd06au4x/cVlvIBpnZZdmvSi3kDpybcZ
         RrS6VM2jtH7kQvv8iIeIOvQg+QOe3R4Y3u4lkuSzEe/LnlsmjSv+8F5XlA/os0M9/+lC
         sIWH0koFacuX9lUR58bHitApJQv311AIea8ekEvDCHGPt4nFkKtj4IhIHCGAzkS3ITGJ
         Nx8g==
X-Gm-Message-State: AOAM533VlLmW4TtgF+djgpPmAgT1Hk8gq3NCO8S4yi13gxEy6DNZY0J9
        kWE/ChSzRvIJ0iud6cIbNfsub8PxTgs=
X-Google-Smtp-Source: ABdhPJzTAHtbZaHGDduzYup9evEOUCvQrN7AGdlDz+V6pTx6P1juspcdwgIDy/rKHzJiX8rPrqPp7w==
X-Received: by 2002:a65:6941:0:b0:381:fea7:f3d8 with SMTP id w1-20020a656941000000b00381fea7f3d8mr8802699pgq.235.1648435898753;
        Sun, 27 Mar 2022 19:51:38 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:b1c4:d244:b609:ac10? ([2600:8802:b00:4a48:b1c4:d244:b609:ac10])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f7728a4346sm14125681pfj.79.2022.03.27.19.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Mar 2022 19:51:38 -0700 (PDT)
Message-ID: <0dd59973-a4da-51db-5234-d4cc48ec13ee@gmail.com>
Date:   Sun, 27 Mar 2022 19:51:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dsa: bcm_sf2_cfp: fix an incorrect NULL check on list
 iterator
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220327055547.3938-1-xiam0nd.tong@gmail.com>
 <20220327185805.cibcmk4rejgb7jre@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220327185805.cibcmk4rejgb7jre@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2022 11:58 AM, Vladimir Oltean wrote:
> On Sun, Mar 27, 2022 at 01:55:47PM +0800, Xiaomeng Tong wrote:
>> The bug is here:
>> 	return rule;
>>
>> The list iterator value 'rule' will *always* be set and non-NULL
>> by list_for_each_entry(), so it is incorrect to assume that the
>> iterator value will be NULL if the list is empty or no element
>> is found.
>>
>> To fix the bug, return 'rule' when found, otherwise return NULL.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: ae7a5aff783c7 ("net: dsa: bcm_sf2: Keep copy of inserted rules")
>> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
>> ---
> 
> The change looks correct, but from a process standpoint for next time
> (a) you should have copied Florian, the driver's maintainer (which I did now)
>      who appears on the top of the list in the output of ./get_maintainer.pl
> (b) networking bugfixes that apply to the "net" tree shouldn't need
>      stable@vger.kernel.org copied, instead just target the patch against
>      the https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
>      tree and mark the subject prefix as "[PATCH net]".
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

If you could please resubmit with the subject being:

net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator

and add Vladimir's and my tag below:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

That would be great! Thanks
-- 
Florian
