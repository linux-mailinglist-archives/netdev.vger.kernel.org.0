Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAD25753FF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiGNR0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGNR0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:26:12 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3C8599D9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:26:12 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w7so1008508ply.12
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=VUWSmtbIge0Xs3jHcFB9NVzwUElNlUgxiPYrSPCa0eE=;
        b=IcwfXJYYbl24MGQCbii0VWN/6M/6ygna0R7ZSC33P8tZDeTOAeaq0YcRWlIyAwRMwR
         29y0qR1QrTJoeXJxK7zVmSVDMreMuydvEq0g7DW4pLGR7yatRG8SwcnywBOP2UFnw7bp
         cLfPhEaRg/CGiWT5pNddWYF29jjMojAp+ZvyVtYaB1OTZxjOkAzQMmgcn6hvcZ1jjcGi
         ED5G+F7HkKki7UmmAzykwJCg8lrRG+LheLyR1S/qhZD1xEk9/A8zI4+pBSWnKXTf130k
         rK1P/FnDzsnRC1qotUp2z14EznR3NYYeaiYZmiith9+xo+iQuuucAkbsRlez5fI7pds5
         X8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VUWSmtbIge0Xs3jHcFB9NVzwUElNlUgxiPYrSPCa0eE=;
        b=tjksAq7QuWIO4edawkaw9ehiKXOppDZybZJxYFx2X1E9jbh7x5yARZit+Zv9C6m46w
         ACvMz/iKoB/uMe0BWwb4S/a2LMbUYO4kuPFiqn3x61D51z6ck5zYMIdQK9qq+lSaWOko
         Fk3XmOnsJ4L0dRLlmDaPcFDPT16iTlFprTsfR/M98N+cLj98lkGNXP+tQypwtpmXb8c6
         +uimIhBGAl3h8lefsB+RB2do31ViSecFdzfP9G3pp0iu+LrgkIit8uTbGj1+HnTySF0Z
         h1V6vomxvvpS1UPOM3ROZ+RsmwkdV94S7f6DNxg2bNk88pUL+7ALqJTgwfaJh+TkdjfQ
         BNug==
X-Gm-Message-State: AJIora8CuE6inTaxP9lmVVZfgJGsgIQL0N8WpLWqsAc77tmsfajYCeyJ
        GA4PD64R+/zkS/9RL5b7/wQfNGjA/dY=
X-Google-Smtp-Source: AGRyM1tzl2MIjEuSVLxA/C+PMDuhEsDhFuy5YvPyqzzkB2WcGknU/v1W1mQRYWLn53TVV8+XUPffpQ==
X-Received: by 2002:a17:903:2347:b0:16c:5a7e:f511 with SMTP id c7-20020a170903234700b0016c5a7ef511mr9273299plh.89.1657819571579;
        Thu, 14 Jul 2022 10:26:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a16-20020aa794b0000000b00529bd84d7bcsm1987235pfl.156.2022.07.14.10.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 10:26:10 -0700 (PDT)
Message-ID: <0893c6fa-84f7-887d-784b-f27abf8868c6@gmail.com>
Date:   Thu, 14 Jul 2022 10:26:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: network driver takedown at reboof -f ?
Content-Language: en-US
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <997525652c8b256234741713c2117f5211b4b103.camel@infinera.com>
 <191adc26-28d3-758a-7c9a-53e71a62b0fa@gmail.com>
 <5156c006ee7c362ef26b2ad28eea2196c847a106.camel@infinera.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5156c006ee7c362ef26b2ad28eea2196c847a106.camel@infinera.com>
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

On 7/14/22 10:16, Joakim Tjernlund wrote:
> On Thu, 2022-07-14 at 07:58 -0700, Florian Fainelli wrote:
>>
>> On 7/14/2022 7:21 AM, Joakim Tjernlund wrote:
>>> Doing a fast reboot -f I notice that the ethernet I/Fs are NOT shutdown/stopped.
>>> Is this expected? I sort of expected kernel to do ifconfig down automatically.
>>>
>>> Is there some function in netdev I can hook into to make reboot shutdown my eth I/Fs?
>>
>> If you want that to happen you typically have to implement a ->shutdown
>> callback in your network driver registered via platform/pci/bus, if
>> nothing else to turn off all DMAs and prevent, e.g.: a kexec'd kernel to
>> be corrupted by a wild DMA engine still running.
>>
>> There is no generic provision in the network stack to deal with those cases.
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Fcommit%2F%3Fid%3Dd9f45ab9e671166004b75427f10389e1f70cfc30&amp;data=05%7C01%7CJoakim.Tjernlund%40infinera.com%7Cf107ea4c5731411a813d08da65a96a4d%7C285643de5f5b4b03a1530ae2dc8aaf77%7C1%7C0%7C637934075577842203%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=QerJo10uvNJW9aI4PaREvoWsZKAzn8SGx6HAP1Zr%2Bt0%3D&amp;reserved=0
> 
> Exactly what I need, thank you :)
> 
> Trying to add a shutdown I have a problem getting at priv ptr:
> static void ccip_shutdown(struct platform_device *pdev)
> {
> 	struct device *dev = &pdev->dev;
> 	struct net_device *ndev = (void*)dev->parent;
> 	struct ccip_priv *priv = netdev_priv(ndev);;
> 
> Above does not work, my probe has:
> 	ndev = alloc_netdev(sizeof(struct ccip_priv), if_name,
> 			    NET_NAME_UNKNOWN, ccip_init_dev);
> 	priv = netdev_priv(ndev);
>          SET_NETDEV_DEV(ndev, &pdev->dev);

How about platform_set_drvdata(&pdev->dev, priv) in probe, and in remove:

struct ccip_priv *priv = platform_get_drvdata(&pdev->dev);

does that work better?
-- 
Florian
