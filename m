Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A0551C10D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379755AbiEENpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379767AbiEENpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:45:51 -0400
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6039C57154;
        Thu,  5 May 2022 06:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1651758126;
        bh=fPiJwfOW/gGoRloz7AL6aSnAMUdo8ZEyLTBfOxLh9ug=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=GCcUz1hDkd/UkHKXsJ5iWk8Zp7xyzpMMdsAajIyr9eWMzBZi34+NNRIGyN+W8SV3Q
         0O6186afoDKNLjhqrPHdX+lwhjPxCXfCY+2S5zSWs+sybozYbpybJKWc7rHHSbJIxf
         V1lFgVZrJwg1hqLwA1ch5Y+2aQTonpKT8IIwzxFc=
Received: from [127.0.0.1] ([58.213.83.156])
        by newxmesmtplogicsvrszc10.qq.com (NewEsmtp) with SMTP
        id A8396C9F; Thu, 05 May 2022 21:42:03 +0800
X-QQ-mid: xmsmtpt1651758123tfn4lrijf
Message-ID: <tencent_3A7D58D1E919ED045A0C40D4CE489320080A@qq.com>
X-QQ-XMAILINFO: OKKHiI6c9SH347vcVTR3u+T1V+5WYp0K0Y+MKcaLakoJbxtXpcxDtIlVddoFSS
         EL/1vCE8fD4fet9MCeG4rh7itidp741an5opQOfxIs93ddS+86YXWkjlnfOprvoTUOO5xKvttMI/
         wbiIBQO6aoh8H1vf/MNGw6u6N+J8ooOSiA0SbsWm4JD+HOTUQYCNpqcORhflD7GB5Lqu8FhxcqGw
         I7Q+heWtufuPZfSIzw8QcIuCq7S0kFulUj2ulPyYSNIOaj1AfeAN+7oqegJhMgQNb2l+hHjo5/ha
         62/XxLQuj8iagGMb/jz+x8Er1BZ1MySMlvDsDyPG7ropg6yPiC/9zHlRtM/OfJ1Xl+CT2Wev5LRv
         yfkcOIMHWidVo4kRLbYTVdFVL5snkNRxeUwDuTCUtpvdgwhGLOj2pMG1tQV/DIOSOdkUa+20Z6Pr
         PcIRM0MKNnjXOsfSGqBIbSpil0j3SVRBQqwHEB3EvFZDLw4Wku5rn7BUqxPclnIjTmSU25i7tkY0
         yAT4W5UvEQQdhsz9CSo1vwzdUF2NiydKoXFaaC1yd82dqZeX7k7utmuDo/z0y34TF3gts2Jn96eQ
         9uTYbYC/HjXtwTpI2nuaz9OFU8pqFtUXK+1zX1YBNKQe6t35bCk65vEcMTpY2XoUb/P9F5vJ4VQ5
         GROIGPxmjTk9yTP1Ov7+XcBT1II3bxxhmDW5omPiw2EXkSClleHruW676HAVtIYD+EYNr11DSVm4
         v3HNj2naDrAktJWdtRmfrphT5mk4XI9WzrqO0SszM2dhidg/PF5mRbGn8Lr8a+E0lBbJcxvHtURF
         F6VrJch5/haxNJ2JWHJIkPTmGwE/FSZnjd2wiTe7MzlfESHQNAkP5W4UJOyQPU1gQmjubzRdcvmz
         OT8fLxceD+uRp6GX8fFnc=
X-OQ-MSGID: <ebd0e1b1-e36d-65eb-c8a7-e54d08a81ba4@foxmail.com>
Date:   Thu, 5 May 2022 21:42:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: phy: micrel: Remove unnecessary comparison in
 lan8814_handle_interrupt
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Jiabing Wan <wanjiabing@vivo.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220505030217.1651422-1-wanjiabing@vivo.com>
 <YnO/VGKVHfFJG7/7@lunn.ch> <2ec61428-d9af-7712-b008-cf6b7e445aaa@vivo.com>
 <YnPHdzegs33G4JJ8@lunn.ch>
From:   Jiabing Wan <jiabing.wan@foxmail.com>
In-Reply-To: <YnPHdzegs33G4JJ8@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/5 20:47, Andrew Lunn wrote:
>> Yes, I actually check the lanphy_read_page_reg and I notice 'data' is
>> declared
>> as a 'u32' variable. So I think the comparison is meaningless. But the
>> return type is int.
>>
>> 1960  static int lanphy_read_page_reg(struct phy_device *phydev, int page,
>> u32 addr)
>> 1961  {
>> 1962      u32 data;
>> 1963
>> 1964      phy_lock_mdio_bus(phydev);
>> 1965      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
>> 1966      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
>> 1967      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
>> 1968              (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
>> 1969      data = __phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
>> 1970      phy_unlock_mdio_bus(phydev);
>> 1971
>> 1972      return data;
>> 1973  }
>>> So the real problem here is, tsu_irq_status is defined as u16, when in
>>> fact it should be an int.
>> Should the 'data' in lanphy_read_page_reg be declared by 'int'?
> Yes.
>
> Another one of those learning over time. If you find a bug, look
> around and you will probably find the same bug in other places nearby.
>
> This is actually a pretty common issue we have with Ethernet PHY
> drivers, the sign bit getting thrown away. Developers look at the
> datasheet and see 16 bit registers, and so use u16, and forget about
> the error code. Maybe somebody can write a coccicheck script looking
> for calls to and of the phy_read() variants and the result value is
> assigned to an unsigned int?
I write the coccicheck and find these reports:

For directly call __phy_read():

./drivers/net/phy/micrel.c:1969:59-60: WARNING: __phy_read() assigned to 
an unsigned int 'data'
./drivers/net/phy/mscc/mscc_macsec.c:49:50-51: WARNING: __phy_read() 
assigned to an unsigned int 'val'
./drivers/net/phy/mscc/mscc_macsec.c:52:51-52: WARNING: __phy_read() 
assigned to an unsigned int 'val_l'
./drivers/net/phy/mscc/mscc_macsec.c:53:51-52: WARNING: __phy_read() 
assigned to an unsigned int 'val_h'
./drivers/net/phy/mscc/mscc_macsec.c:89:50-51: WARNING: __phy_read() 
assigned to an unsigned int 'val'
./drivers/net/phy/mscc/mscc_main.c:1511:50-51: WARNING: __phy_read() 
assigned to an unsigned int 'addr'
./drivers/net/phy/mscc/mscc_main.c:1514:47-48: WARNING: __phy_read() 
assigned to an unsigned int 'val'
./drivers/net/phy/mscc/mscc_main.c:366:54-55: WARNING: __phy_read() 
assigned to an unsigned int 'reg_val'
./drivers/net/phy/mscc/mscc_main.c:370:55-56: WARNING: __phy_read() 
assigned to an unsigned int 'pwd [ 0 ]'
./drivers/net/phy/mscc/mscc_main.c:371:53-54: WARNING: __phy_read() 
assigned to an unsigned int 'pwd [ 1 ]'
./drivers/net/phy/mscc/mscc_main.c:372:55-56: WARNING: __phy_read() 
assigned to an unsigned int 'pwd [ 2 ]'
./drivers/net/phy/mscc/mscc_main.c:317:54-55: WARNING: __phy_read() 
assigned to an unsigned int 'reg_val'

Should all of them be added a check for error code?

>> Finally, I also find other variable, for example, 'u16 addr' in
>> lan8814_probe.
>> I think they all should be declared by 'int'.
> addr should never be used as a return type, so can never carry an
> error code. Also, PHYs only have 32 registers, so address is never
> greater than 0x1f. So this is O.K.

Oh, yes.  I miss the ' & 0x1F'.

Thanks,
Wan Jiabing



