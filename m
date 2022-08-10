Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584F158F279
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 20:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiHJSkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 14:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiHJSkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 14:40:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4946C120
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:40:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x21so20230072edd.3
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=QZ9ZtsjJrzcjOd1SrD7hyJb5wcKu+C0MspNQVOUI6/8=;
        b=H8yWkOw/qqfc7+DPEAHYXQdAFTfmYPDc3ErBFbBJ6VB0skyzBygmXX/09Rfua9fc2b
         QHJR2OgaA7JnbIm0MGuugEwB3KYbE1d2OxQdRiErYxxveSqVGu0Dm6hfrB6XHVe2JG38
         VxowCNGP9CfBtX1tKcaKN3kHV50PyzrGtHymmAb3v6OiRgd1IPCDJubbAp1zbDq7sPyw
         uoSaRcl74/Jcg5OkDb3gPAOrjwAeprdX5f94y1LQh2JjzhaOV7Hmi2y0BDU/zdE09eRh
         QIjItQv5t5zqKcdBuAYBz6Ning4oaGyQwxvRxFdfI+zQNySCbaVMSwujtr78jwxRgrHl
         Izxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QZ9ZtsjJrzcjOd1SrD7hyJb5wcKu+C0MspNQVOUI6/8=;
        b=sfMM9J+gn5L2TTHcFwZIK64iPNVTTJcXs1fKPhS89/5gCljC80kZbpjhlswy1l9ba4
         6SZhG4DHfuHdbr9yzrnrWO3eu0btY7Q3WzJiby9ePVfvoXFXl2Cis+ZS5q59LV/Ye0g+
         3cXboi4IHSnQkJ3HRIEhBaHm3hwJzjjcDrtc8BnyniVbqQoCpcHNZFuCX2YIpDdxAmOc
         qrHTeGO9zS9X7yoIKBThgAcFeFudkbdugCjDzoH9iPlQc1/3VyiEJPRQLQ6Hwubch/WA
         78QktXedNY415pzEORmDC5MKI0H+wSFfZKAKhCCkC6Q/jhaoyGBEcqjV2xlSGqMy6+/a
         8trw==
X-Gm-Message-State: ACgBeo00hJGMs2I1tbahW1d7tNPll46NG2lBhStoxGP8QU+R0TverZbw
        0U20oDQ4OvgeEyJS7tJfxm8=
X-Google-Smtp-Source: AA6agR6+fNx59rO0opcRaIrSz8b9O+DbaOpNlRxKDuTD7DYInHK36Izo0EAQQejIonqU1e0aKKaaQg==
X-Received: by 2002:a05:6402:34c6:b0:43d:8cea:76c0 with SMTP id w6-20020a05640234c600b0043d8cea76c0mr28271487edc.268.1660156805786;
        Wed, 10 Aug 2022 11:40:05 -0700 (PDT)
Received: from [192.168.2.114] (p5b3dd6ec.dip0.t-ipconnect.de. [91.61.214.236])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906201100b00721d8e5bf0bsm2594850ejo.6.2022.08.10.11.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 11:40:05 -0700 (PDT)
Message-ID: <47c884e9-e5ea-16a2-38e5-7b7f61e77e80@gmail.com>
Date:   Wed, 10 Aug 2022 20:40:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Content-Language: en-US
To:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>
Cc:     "philipp.rossak@formulastudent.de" <philipp.rossak@formulastudent.de>,
        "guoniu.zhou@nxp.com" <guoniu.zhou@nxp.com>,
        "aisheng.dong@nxp.com" <aisheng.dong@nxp.com>,
        "abel.vesa@nxp.com" <abel.vesa@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
 <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
From:   Philipp Rossak <embed3d@gmail.com>
In-Reply-To: <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
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

Hi Marcel,

thanks!

With the removed line it is working now!

I hope there will be a mainlined solution soon.

Cheers
Philipp

On 10.08.22 10:05, Marcel Ziswiler wrote:
> Sali Philipp
> 
> On Wed, 2022-08-10 at 00:55 +0200, Philipp Rossak wrote:
>> Hi,
>>
>> I currently have a project with a Toradex Colibri IMX8X SOM board whith
>> an onboard Micrel KSZ8041NL Ethernet PHY.
>>
>> The hardware is described in the devictree properly so I expected that
>> the onboard Ethernet with the phy is working.
>>
>> Currently I'm not able to get the link up.
>>
>> I already compared it to the BSP kernel, but I didn't found anything
>> helpful. The BSP kernel is working.
>>
>> Do you know if there is something in the kernel missing and got it running?
> 
> Yes, you may just revert the following commit babfaa9556d7 ("clk: imx: scu: add more scu clocks")
> 
> Alternatively, just commenting out the following single line also helps:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/clk/imx/clk-imx8qxp.c?h=v5.19#n172
> 
> I just found this out about two weeks ago before I went to vacation and since have to find out with NXP what
> exactly the idea of this clocking/SCFW stuff is related to our hardware.
> 
> @NXP: If any of you guys could shed some light that would be much appreciated. Thanks!
> 
>> Thanks,
>> Philipp
> 
> Cheers
> 
> Marcel
