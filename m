Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21FC5BCE14
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 16:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiISOJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 10:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiISOI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 10:08:59 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8682A96B;
        Mon, 19 Sep 2022 07:08:58 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id d17so19743134qko.13;
        Mon, 19 Sep 2022 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8LaIJ9LDHeewPQEIhj9bZ79DH+Uk0uNLtUcy0IwGtC4=;
        b=m8SwXeoH1c6RAKlYGdWljLxCDDojvoHe1KR2RWkFgr7VjFxl6Zl2dJ6HRVFK93a1Q4
         oxS1YGplZraKQbB5IKZeAK6sBUiO7WGmPyK+OQ70/8szjjJJwIlyI1W/33DrunU/1HOi
         NHdXxh3rHprIvxVU8bPHhohAlR8xEhOCUk9uDwj6mVAQXmBd1VQnOcDpCtIzzmgj9Kn9
         PrI+/M4BZ3jcs1nETZfue8agBJXkKlA1mVXsrazUBjEZ1rdk15f3ylh9BgddfjzIyjOd
         tepj8k6LHHYgRahNli9mBzhm+ZL/4u1BqO2jxrfDhI3ckcyxywLpE1PPPB3Xr4md124p
         TX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8LaIJ9LDHeewPQEIhj9bZ79DH+Uk0uNLtUcy0IwGtC4=;
        b=IVaIOnF7g6/+FFlbljudP7aaUZ31hAYbKCx0zOF75+AXQruSK4UIgE+XVgFrxr1+TQ
         vH1W8M+oJIRc+JqYs4WKF50YMnBhEJN/n6yOzz5mx5oZPPd3UlYtm4JVR6AmxjkEy2mx
         I7jec8lMiDbtUp5cQweHDHVVYEYVtZlfO+dIGrTCkiopYF1pBthCefIZ63P6yQSCjnDl
         CIvIMCZRO+wNlnsfivAkA2GkHcQmF5F76iUKmhJSkCL5r7WbQRC7U4AHx4z/uXf3pCW3
         aYm24r3vucXF87PwIvIPkrn0Fhlos89Lbkx6CnG2PxGXoRSYmRqVZ7K5DEa8OqWoFfDB
         2yQw==
X-Gm-Message-State: ACrzQf18We8E5jTEutg9V27HOT2IhfBy2QO3QkzIj1R5PyT5N2pT5H17
        NdLO35+i9tNUxTiwuxKqN7g=
X-Google-Smtp-Source: AMsMyM6dy8hgXORB128fW4j9eG2171xGW3bn8pBRaZcBk1oB2KAwKDh9QrRDT2uQMuyEhVTf3KxbLw==
X-Received: by 2002:a05:620a:1917:b0:6ce:ee57:efb3 with SMTP id bj23-20020a05620a191700b006ceee57efb3mr6446108qkb.633.1663596537465;
        Mon, 19 Sep 2022 07:08:57 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id y6-20020a05620a25c600b006ccc96c78easm13436893qko.134.2022.09.19.07.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 07:08:56 -0700 (PDT)
Message-ID: <0ffba41b-3808-c2d8-e180-d865c8d5d306@gmail.com>
Date:   Mon, 19 Sep 2022 10:08:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 04/13] sunhme: Return an ERR_PTR from
 quattro_pci_find
Content-Language: en-US
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>
References: <20220918232626.1601885-1-seanga2@gmail.com>
 <20220918232626.1601885-5-seanga2@gmail.com>
 <14346017.muaEW6z1dk@eto.sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <14346017.muaEW6z1dk@eto.sf-tec.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 09:11, Rolf Eike Beer wrote:
> Am Montag, 19. September 2022, 01:26:17 CEST schrieb Sean Anderson:
>> In order to differentiate between a missing bridge and an OOM condition,
>> return ERR_PTRs from quattro_pci_find. This also does some general linting
>> in the area.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
>> ---
>>
>>   drivers/net/ethernet/sun/sunhme.c | 33 +++++++++++++++++++------------
>>   1 file changed, 20 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c
>> b/drivers/net/ethernet/sun/sunhme.c index 1fc16801f520..52247505d08e 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2569,30 +2569,33 @@ static void quattro_sbus_free_irqs(void)
>>   #ifdef CONFIG_PCI
>>   static struct quattro *quattro_pci_find(struct pci_dev *pdev)
>>   {
>> +	int i;
>>   	struct pci_dev *bdev = pdev->bus->self;
>>   	struct quattro *qp;
>>
>> -	if (!bdev) return NULL;
>> +	if (!bdev)
>> +		return ERR_PTR(-ENODEV);
>> +
>>   	for (qp = qfe_pci_list; qp != NULL; qp = qp->next) {
>>   		struct pci_dev *qpdev = qp->quattro_dev;
>>
>>   		if (qpdev == bdev)
>>   			return qp;
>>   	}
>> +
>>   	qp = kmalloc(sizeof(struct quattro), GFP_KERNEL);
>> -	if (qp != NULL) {
>> -		int i;
>> +	if (!qp)
>> +		return ERR_PTR(-ENOMEM);
>>
>> -		for (i = 0; i < 4; i++)
>> -			qp->happy_meals[i] = NULL;
>> +	for (i = 0; i < 4; i++)
>> +		qp->happy_meals[i] = NULL;
> 
> I know you are only reindenting it, but I dislike moving the variable up to
> the top of the function. Since the kernel is C99 meanwhile the variable could
> be declared just in the for loop. 

Hm, I thought this style was discouraged.

> And when touching this anyway I think we
> could get rid of the magic "4" by using ARRAY_SIZE(qp->happy_meals). Or just
> replace the whole thing with memset(qp->happy_meals, 0, sizeof(qp-
>> happy_meals)).

Yeah, that avoids the whole problem.

--Sean

