Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4E764C681
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiLNKF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLNKFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:05:24 -0500
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8795919C38;
        Wed, 14 Dec 2022 02:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Content-Type:Mime-Version:Subject:From:Date:
        Message-Id; bh=DdXAi3a4xLdPWmSfsmnWtnIG13EOG5Vlr4x3NyxVLpk=; b=G
        jBx+yrUdY489zjU+zbSAfm0Tz+6Md4p4ha3C3lMuM3mb7r8cH1zJwHTvbW05ijoI
        bn2JB6Fkz6jmM59OC/kBcVJn1H/hhwK3Yny6cZI49jC02dfNzf+wlUR5dqa3xaw6
        VWa4hdQ5cQSfhTMvtKVeJ6iy201S0OmGUB2crMTp24=
Received: from smtpclient.apple (unknown [117.136.33.142])
        by zwqz-smtp-mta-g2-0 (Coremail) with SMTP id _____wDHkApOn5ljb0YKAA--.23247S3;
        Wed, 14 Dec 2022 18:02:57 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixuehao@126.com>
In-Reply-To: <Y5l5pUKBW9DvHJAW@unreal>
Date:   Wed, 14 Dec 2022 18:02:53 +0800
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <216119AA-C362-445D-9F04-47AC2A15EC11@126.com>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal>
To:     Leon Romanovsky <leon@kernel.org>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: _____wDHkApOn5ljb0YKAA--.23247S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4fGry8GryfurW7KrykKrg_yoWkGFcE9F
        45uFy5W3WDGr93KF4jkF4YvrWF93WUWFWF9a4UtF93W3sxAa4xXw1qqryruw4aqrWvkFn8
        u3W2vrs2q34qgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRi75rDUUUUU==
X-Originating-IP: [117.136.33.142]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbi5RnXFlpD9gGR-wAAs9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Leon,

Currently this module parameter is only used for igb.
Is the more user-friendly way not to use module parameters?
just like other network card drivers, use random MAC.=20
As I submitted [patch v3] before, link:=20
=
https://lore.kernel.org/netdev/20220530105834.97175-1-lianglixuehao@126.co=
m/

Or, can you suggest me how to do it more reasonable?

Thanks

> 2022=E5=B9=B412=E6=9C=8814=E6=97=A5 15:22=EF=BC=8CLeon Romanovsky =
<leon@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Dec 13, 2022 at 07:47:26AM +0000, Lixue Liang wrote:
>> From: Lixue Liang <lianglixue@greatwall.com.cn>
>>=20
>> Add the module parameter "allow_invalid_mac_address" to control the
>> behavior. When set to true, a random MAC address is assigned, and the
>> driver can be loaded, allowing the user to correct the invalid MAC =
address.
>>=20
>> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
>=20
>=20
> I'm amused that we are in v7 version of module parameter.
>=20
> NAK to any module driver parameter. If it is applicable to all =
drivers,
> please find a way to configure it to more user-friendly. If it is not,
> try to do the same as other drivers do.
>=20
> Thanks

