Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C062C5BBFE8
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 22:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIRUlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 16:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIRUlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 16:41:19 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE0512AE6;
        Sun, 18 Sep 2022 13:41:19 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id j8so9645609qvt.13;
        Sun, 18 Sep 2022 13:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=68oOJwrty1S4PfQgc+rerk9pd5nDs7jnNI5Sftt1xeA=;
        b=VvK9DdfqNWO2HPX6RnxB+xGleSLKhakCpH2ePTjeb9EJ/fc7ecaCZohO0xXq7ys3Qf
         iv1U7wNwD53CEDLrE/BJDNHGxJvnW+7VSc4oF726ZFLQMS7tGm5NUqQ0je9q7uc0KQX1
         K4i9rHPJMAbtl4i7wQ/o7F+FVxGOu9nsZwLjhzmVSI8WU9r8L3Uplo9cfZIwiFIbt/mj
         oB8MKkLHR9zqyOfPxnrlGxi6AJLucfrWGDgthTet2hp99tqSSH4VaaRLVQ3LsI4p5Y9w
         o8SxPV+J1of9mYEUAq74jt/h2Ycjip+r14E6Sdqi+vdRVk90iXZdlwClh5EOzEK84zh1
         I1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=68oOJwrty1S4PfQgc+rerk9pd5nDs7jnNI5Sftt1xeA=;
        b=iRsW+dBD+Wmn05Pf+fCo3zSCiIEi6wDb2mkfLACr2Nqo1QOOCuyzCvX4v+TLl7SRSC
         Pazcee0sL/8x6Y5t1EUGdN979eEd6rTcM2G4nHHXMqyux9N2Pqa4oCoQdkQTON4zXTlw
         eMI1Vu2pbeIyto9LCLe0AJ4EA/UOKiXgAMzRDIVuvE0sgHpbAfuVucameL8++NNBUl+9
         otlp/hyLcrFQ5Ufaelp2RHozK3MqNLUxolY7A4qJnjAdRXxurFuekMU+gya9NOTMOfkl
         +tY0hgeV0zdSB7rS+BqXwuiMEApJJajSyk+kxIL/Zss39WihRZuuQPYjPSPde+kPgAZC
         OOFw==
X-Gm-Message-State: ACrzQf37OYXhwisQDugVwZQaLH49XL9m1O7HBACUVHvpz9XSkZvK3J1g
        cfK9xiWI6XvlXN30L3EiSoM=
X-Google-Smtp-Source: AMsMyM6kUKPKAKo9gJjRn4Wp3WksIZheNzSXtiGstNUNmBv6H3DL+CUrEJUKHWQqa1UShzpABa/iIA==
X-Received: by 2002:a05:6214:20ac:b0:4ac:ad56:a9f4 with SMTP id 12-20020a05621420ac00b004acad56a9f4mr12006317qvd.78.1663533678246;
        Sun, 18 Sep 2022 13:41:18 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bl10-20020a05620a1a8a00b006b5d9a1d326sm10607696qkb.83.2022.09.18.13.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 13:41:17 -0700 (PDT)
Message-ID: <d963b1a3-e18d-25d5-f07c-42d17d382174@gmail.com>
Date:   Sun, 18 Sep 2022 13:41:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
To:     Lukas Wunner <lukas@wunner.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
References: <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
 <20220826071924.GA21264@wunner.de>
 <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
 <20220826075331.GA32117@wunner.de>
 <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
 <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
 <20220918191333.GA2107@wunner.de>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220918191333.GA2107@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2022 12:13 PM, Lukas Wunner wrote:
> [cc += Florian]
> 
> On Mon, Aug 29, 2022 at 01:40:05PM +0200, Marek Szyprowski wrote:
>> I've finally traced what has happened. I've double checked and indeed
>> the 1758bde2e4aa commit fixed the issue on next-20220516 kernel and as
>> such it has been merged to linus tree. Then the commit 744d23c71af3
>> ("net: phy: Warn about incorrect mdio_bus_phy_resume() state") has been
>> merged to linus tree, which triggers a new warning during the
>> suspend/resume cycle with smsc95xx driver. Please note, that the
>> smsc95xx still works fine regardless that warning. However it look that
>> the commit 1758bde2e4aa only hide a real problem, which the commit
>> 744d23c71af3 warns about.
>>
>> Probably a proper fix for smsc95xx driver is to call phy_stop/start
>> during suspend/resume cycle, like in similar patches for other drivers:
>>
>> https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/
> 
> No, smsc95xx.c relies on mdio_bus_phy_{suspend,resume}() and there's
> no need to call phy_{stop,start}() >
> 744d23c71af3 was flawed and 6dbe852c379f has already fixed a portion
> of the fallout.
> 
> However the WARN() condition still seems too broad and causes false
> positives such as in your case.  In particular, mdio_bus_phy_suspend()
> may leave the device in PHY_UP state, so that's a legal state that
> needs to be exempted from the WARN().

How is that a legal state when the PHY should be suspended? Even if we 
are interrupt driven, the state machine should be stopped, does not mean 
that Wake-on-LAN or other activity interrupts should be disabled.

> 
> Does the issue still appear even after 6dbe852c379f?
> 
> If it does, could you test whether exempting PHY_UP silences the
> gratuitous WARN splat?  I.e.:

If you allow PHY_UP, then the warning becomes effectively useless, so I 
don't believe this is quite what you want to do here.
-- 
Florian
