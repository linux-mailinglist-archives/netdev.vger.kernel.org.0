Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206372EEBA2
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbhAHDGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbhAHDGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 22:06:04 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3497CC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 19:05:24 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y8so4930006plp.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 19:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Uft2otr4Ur4ZFETvfR7iVdl2uA4G6h5Cajepz/SrFeU=;
        b=KSiKpMjjPvB5WanmCQy4MOBOZ4/nDlSauH/lysz68ujVwETopXhlI+TdyZH6HlPHIu
         MCweoV34upgM0GAZMy5/xvpSzSi34ZG2IAxBQAQpYV/26j5LlhjmqSJW48uT7ERuBSEc
         8VEG+dyClkfec6UdZovk0/pKVqLqRSrx2KazMpsxgdrnc+FB+hVLuJr3odjgJ3gxTZPp
         qaeyecmRiVTki770mz3hpdhPCJNS8Qh69XaCP18eWkPcqBzaZqzkYgMNuYNFx/9LLKc0
         EATc3U4PQA2tSFInf5n4xe9do4kdRcincwTqAns8I5v05yM1ceMMtG3GSY1LbOih0PJT
         a7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uft2otr4Ur4ZFETvfR7iVdl2uA4G6h5Cajepz/SrFeU=;
        b=sBkbY9G9PHR7+PVsJK2Z3Xfnr59lK4S8Mutw5vY/1L6uLLIpoimkRB5pAJcDtrYZH1
         5BJM2w4YcWYLJChfqwleEJGSrTZdjslr1SOj5dmPQFL13h7OLBDCVm651xDAcF7XNU62
         WAiK7z7MNkvdGJtL+n/MKIzDMzXIbpSoWj9p6Rs55wJ+RmelImXOFx64sWY0WICTSuSN
         N51sYURSR3dCHq4bk0WBB21PBsJvAnrVr7HvwEeRl+fzbnHO7GFvKn6waQc0SktV1JAn
         +46cBxcOft2HRzwjA4AHWYouT2Xn+Z6YmTef4laBnIXZ2BR3DZ4tvDiC+qvp//Xq5FJL
         jvyQ==
X-Gm-Message-State: AOAM530S0nSYSQPrnwNxTnCCcSTaCJH2LktZ5FsWnOeo+VJMnpWVu93F
        TNq6rnar/528bXAteQ+w8qq5vtY6heQ=
X-Google-Smtp-Source: ABdhPJyRiuHw0PX4VbcpCP8hAUomEsNyk1pZrAhHdHq/E/x9nU7yfDfDNprx6eNbH5TtLInSAIBz5A==
X-Received: by 2002:a17:902:7085:b029:dc:c69:e981 with SMTP id z5-20020a1709027085b02900dc0c69e981mr1759743plk.37.1610075123656;
        Thu, 07 Jan 2021 19:05:23 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k25sm6852450pfi.10.2021.01.07.19.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 19:05:22 -0800 (PST)
Subject: Re: MDIO over I2C driver driver probe dependency issue
To:     Brian Silverman <silvermanbri@gmail.com>, netdev@vger.kernel.org,
        andrew@lunn.ch
References: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com>
Date:   Thu, 7 Jan 2021 19:05:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/2021 6:22 PM, Brian Silverman wrote:
> I've written a very small generic MDIO driver that uses the existing
> mdio-i2c.c library in drivers/net/phy.  The driver allows
> communication to the PHY's MDIO interface as using I2C, as supported by
> PHYs like the BCM54616S.  This is working on my hardware.  
> 
> The one issue I have is that I2C is not up and available (i.e. probed)
> at the time that the MDIO interface comes up.  To fix this, I've changed
> the device order in drivers/Makefile to put "obj-y += i2c/"
> before "obj-y += net/".
> 
> While that works, I prefer not to have to keep that difference from
> mainline Linux.  Also, I don't understand why i2c drivers occur
> arbitrarily late in the Makefile - surely there are other devices
> drivers that need i2c to be enabled when they are probed?
> 
> Is there a way to do this that doesn't change probe order?  Or is there
> a way to change probe order without patching mainline Linux?

Linux supports probe deferral so when a consumer of a resource finds
that said resource's provider is not available, it should return
-EPROBE_DEFER which puts the driver's probe routine onto a list of
driver's probe function to retry at a later time.

In your case the GEM Ethernet driver should get an -EPROBE_DEFER while
the Ethernet PHY device tree node is looked up via
phylink_of_phy_connect() because the mdio-i2c-gen i2c client has not had
a chance to register the MDIO bus yet. Have you figured out the call
path that does not work for you?

Which version of the kernel are you using? What I am referring to is
assuming mainline, but maybe this is not your case?

> 
> 
> ---
> 
> For reference, here's the driver (excluding headers and footers):
> 
> static int mdio_i2c_gen_probe(struct i2c_client *client,
>     const struct i2c_device_id *id)
> {
> struct mii_bus *bus;
> 
> bus = mdio_i2c_alloc(&client->dev, client->adapter);
> if (IS_ERR(bus)){
> return PTR_ERR(bus);
> }
> bus->name = "Generic MDIO bus over I2C";
> bus->parent = &client->dev;
> 
> return of_mdiobus_register(bus, client->dev.of_node);
> }
> 
> static int mdio_i2c_gen_remove(struct i2c_client *client)
> {
> return 0;
> }
> 
> static const struct of_device_id mdio_i2c_gen_of_match[] = {
> { .compatible = "mdio-i2c-gen", },
> { }
> };
> MODULE_DEVICE_TABLE(of, mdio_i2c_gen_of_match);
> 
> static struct i2c_driver mdio_i2c_gen_driver = {
> .driver = {
> .name= "mdio-i2c-gen",
> .of_match_table = of_match_ptr(mdio_i2c_gen_of_match),
> },
> .probe= mdio_i2c_gen_probe,
> .remove= mdio_i2c_gen_remove,
> };
> 
> module_i2c_driver(mdio_i2c_gen_driver);
> 
> 
> ---
> 
> And here's a device-tree snippet:
> 
> &gem3 {
>     status = "okay";
>     phy-handle =  <&phy0>;
> };
> 
> &i2c0 {
>     mdio@40 {
>         compatible = "mdio-i2c-gen";
>         reg = <0x40>;
>         #address-cells = <1>;
>         #size-cells = <0>;
> 
>         phy0: phy@0 {
>             reg = <0>;
>         };
>     };
> };
> 
> 
> 

-- 
Florian
