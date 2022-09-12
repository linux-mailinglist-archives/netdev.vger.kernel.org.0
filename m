Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98A85B5E34
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiILQ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiILQ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:26:18 -0400
X-Greylist: delayed 1388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 09:26:16 PDT
Received: from fallback25.mail.ru (fallback25.m.smailru.net [94.100.189.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143761C109;
        Mon, 12 Sep 2022 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=8US1vgXixv7xa8A9nBZ4Deph+E3LZ8h4N6j7S9Yzc6k=;
        t=1662999976;x=1663089976; 
        b=wcANcI2P7EzntN+tzPMfpbbGOSnVV8INfw/W8vE9dQg1YRKWGjp3m6e6cMW+rBqCCVwDQO+hYjO60ICxh8LE1hURaH5uyEHGojIg5lObsJWo1ub8m6wxptZzYZaqrbcgfXkBENWi3gbw3y8V2nzfWd6z8Mg+lS/DFqFxrL1yi0fpmpUyAVk736AaQpP5L/qsL+g4chMddwui24nh0rhtdeJ6Ii1JoSJypZWEaMbsG9OcCWry7FY6Roy+KTFm48HMi4xVTstAWL0zkb7W9fVJ8ziMmZl+mkY7yVFri6XXcZhSi7utabfh6zFP4MfE1WVxDsILjwlgaiT8uL5WlhKxsw==;
Received: from [10.161.100.15] (port=37086 helo=smtpng3.i.mail.ru)
        by fallback25.m.smailru.net with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1oXltp-0007ec-AX; Mon, 12 Sep 2022 19:03:05 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=8US1vgXixv7xa8A9nBZ4Deph+E3LZ8h4N6j7S9Yzc6k=;
        t=1662998585;x=1663088585; 
        b=fXUW2PD0lHHjO2zxV/3Y4hMBZDhLgpyyMoOWDXodgl/7Lk3VsPr6odU9NZ6AhsqUH+tORIIra7IjbP08WeA9lmd8+Co1BjbiThgIhRmsS39hrn4ego/AP9R8i0hbg5RyThTW/KWMriCWAK6iGj8GSae/wWCudGm138waBTfcFcG5oMZ8ZM6QfzO5Jd7N1+RNLzn5pWWmpkHskRlgUi60KSJ5Y6NovmZkveZSMiDhHbL6xzFrQqZfbXOam1+xukHHhf8E5i/PS059aPIYXO2kSLb9IPRo5RADAK2IuPDGO5AEVYLZxyI9XK/UwGIOcQtwwhzU+JnOE5mDzNhwS7iSDw==;
Received: by smtpng3.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1oXltZ-0002Zl-LS; Mon, 12 Sep 2022 19:02:50 +0300
Message-ID: <61d4abee-b785-f6d0-1afd-3299083fd27c@inbox.ru>
Date:   Mon, 12 Sep 2022 19:02:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: convert ocelot.txt to
 dt-schema
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220912153702.246206-1-vladimir.oltean@nxp.com>
From:   Maxim Kochetkov <fido_max@inbox.ru>
In-Reply-To: <20220912153702.246206-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailru-Src: smtp
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD98A32D11463CB84D82663DA822CE640DCAD5655D05B28A237182A05F5380850405EEF27D46583D87F477E910B058DE7ED5AE8E7EBF558BBCD3B70540C45998270
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7677FBC47C69A9293EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637FC0948D7756001208638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8AA7F8F81A15FD4E4A65E922D93E9F1716F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE76E0B6B202B8EE8599FA2833FD35BB23D9E625A9149C048EEC65AC60A1F0286FE2CC0D3CB04F14752D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8B1BE95B8C87527B4BA471835C12D1D977C4224003CC8364762BB6847A3DEAEFB0F43C7A68FF6260569E8FC8737B5C2249EC8D19AE6D49635B68655334FD4449CB9ECD01F8117BC8BEAAAE862A0553A39223F8577A6DFFEA7CB0EC3B1FCAE4A06943847C11F186F3C59DAA53EE0834AAEE
X-C1DE0DAB: 9604B64F49C60606AD91A466A1DEF99B296C473AB1E142185AC9E3593CE4B31AB1881A6453793CE9274300E5CE05BD4401A9E91200F654B0D4C601CEA03E70EE62A0B7FAC1A43EF08DBE3677FAB95117C574AAF92CB21A169C2B6934AE262D3EE7EAB7254005DCED8DA55E71E02F9FC08E8E86DC7131B365E7726E8460B7C23C
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D34C75F910DBB8BE8989805CC95668CC3AFB6108C3EBDC61B19470548E84D426AB30725BAB1F64B98191D7E09C32AA3244C65FA36AA7DE6F861D7682B05ACB502BFFE8DA44ABE2443F7FE8D267BAF400505
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojlrfVkOjGUc8pFl4ahuSzLg==
X-Mailru-Sender: 689FA8AB762F7393CC2E0F076E87284E7172974701A0C013ECDB4CE1FBDB9EB898CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-7564579A: B8F34718100C35BD
X-77F55803: 6242723A09DB00B432349F57BDBE6FC5102DFFA97DB55D05DA9B8BC18EBE5BAA049FFFDB7839CE9EB3F9D156658E49A3DBB6F795AB2405D2328B1CFAF8BA98E2D171CCF9FA619655
X-7FA49CB5: 0D63561A33F958A5EA06B542706C3E4EB8D3D9D0EC2CCA6C30EFA4949FBBC4A5CACD7DF95DA8FC8BD5E8D9A59859A8B64071617579528AACCC7F00164DA146DAFE8445B8C89999728AA50765F790063781612DB815465C93389733CBF5DBD5E9C8A9BA7A39EFB766F5D81C698A659EA7CC7F00164DA146DA9985D098DBDEAEC886D40F53BA192295F6B57BC7E6449061A352F6E88A58FB86F5D81C698A659EA775ECD9A6C639B01B78DA827A17800CE7F45C1E71A9DFFA2A731C566533BA786AA5CC5B56E945C8DA
X-C1DE0DAB: 9604B64F49C60606AD91A466A1DEF99B296C473AB1E142185AC9E3593CE4B31AB1881A6453793CE9274300E5CE05BD44CFFBF5018520E3987BB222D9AD51FB28F806EE4A770593A87E567C5E67DA451A250F2D7D8FB26E69B1881A6453793CE9C32612AADDFBE06133F7A9E5587C79A693EDB24507CE13387DFF0A840B692CF8
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojlrfVkOjGUc8ncrsnt7Fu6w==
X-Mailru-MI: 8000000000000800
X-Mras: Ok
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.09.2022 18:37, Vladimir Oltean wrote:
> Replace the free-form description of device tree bindings for VSC9959
> and VSC9953 with a YAML formatted dt-schema description. This contains
> more or less the same information, but reworded to be a bit more
> succint.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
