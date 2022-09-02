Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDBA5AB631
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbiIBQIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237696AbiIBQIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:08:07 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B809B12BF45;
        Fri,  2 Sep 2022 09:01:44 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id j6so1719257qvu.10;
        Fri, 02 Sep 2022 09:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=JClXwZoTfaXuBwXhgprZ+soSsQMpY97LHOFOymhsvPs=;
        b=EvpUwSPfQLEB4N6VUWWvyfKTBefctgE0jbELSJSZvaYzSmiif42cPRZwAItXNH+dMM
         MA/ISa+r8KDFcqc40+J0w03jEvfZNibWRH7OyXua43FOqUXws2dRbehWRmR9M4+wrYuT
         Jr45ddvPe1dwK1RQvTPgnqSkQ5tUgz5dcZm1hZ6QEeYFrV69uBTx08d5dHyMpIf6OVmF
         teEV6/23DLKvuDI0kcnI/gwreSn2InPzY1ETfYdz96vMkg+UAQgmxEJueqFaGpCc9Hdn
         3EVLfBwwa9a9SejAJxCaglpS5ooiA6MsBh4aYl3mDtfTBbS+jmI1vdt3lxiCOzlqZGbX
         RyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=JClXwZoTfaXuBwXhgprZ+soSsQMpY97LHOFOymhsvPs=;
        b=dd55Z27k0V0hpMAmIBW8yQGw8m5fanHRBCzKmEwBEIVghzFgs3yk0vDhf9RJllYEVF
         i4QXXaEaMO1vKjJg+JMW+LKmOx9DZOkt0aQvQfoWjv8Ce5hAfnRuzefL8v0Osu/qZAR/
         n21Y9eJO0ZyURhgbRgJcsdXKfMaGGZfTx7yv4lwcTL9mQlVn+vC6lrOZWCvFmwPPNfhF
         gmhF9O/zfva1n+YLHLmWr9EYwaPlGi/H51v152NQgcju84LCpqH99QFZIzFcBfUJHdwC
         +9CXd8i2hb6SfJrHihdUGJY5l3e3ZssXSQpiaSZ9Qj3zgvOOXpjo9cFMOyItLqzCjdPn
         ioew==
X-Gm-Message-State: ACgBeo31SX7Y/swsbYCw9hWPfH3bPPEBj8e89clVMDJQZpj3Y/baGkds
        JM6QTJBBiRGZSXVo7oJ3qWY=
X-Google-Smtp-Source: AA6agR4YBehGmDDaB/lQkRt4wqnmniyvn125xQ3AWF0PQLQES9s/hoSawjoBG7mDaL9j6M2sZX/YMA==
X-Received: by 2002:a05:6214:19e1:b0:476:95b7:1dc9 with SMTP id q1-20020a05621419e100b0047695b71dc9mr29172370qvc.124.1662134453000;
        Fri, 02 Sep 2022 09:00:53 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m7-20020a05620a290700b006b9593e2f68sm1700006qkp.4.2022.09.02.09.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 09:00:52 -0700 (PDT)
Message-ID: <a02f9bf8-cfa5-931e-c2da-d4ce79c6412d@gmail.com>
Date:   Fri, 2 Sep 2022 09:00:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [Patch net-next 1/3] net: dsa: microchip: add reference to
 ksz_device inside the ksz_port
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
References: <20220902103210.10743-1-arun.ramadoss@microchip.com>
 <20220902103210.10743-2-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902103210.10743-2-arun.ramadoss@microchip.com>
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



On 9/2/2022 3:32 AM, Arun Ramadoss wrote:
> struct ksz_port doesn't have reference to ksz_device as of now. In order
> to find out from which port interrupt has triggered, we need to pass the
> struct ksz_port as a host data. When the interrupt is triggered, we can
> get the port from which interrupt triggered, but to identify it is phy
> interrupt we have to read status register. The regmap structure for
> accessing the device register is present in the ksz_device struct. To
> access the ksz_device from the ksz_port, the reference is added to it
> with port number as well.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
