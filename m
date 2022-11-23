Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFFD63642C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiKWPls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbiKWPlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:41:24 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC14970AA;
        Wed, 23 Nov 2022 07:41:22 -0800 (PST)
Received: from [192.168.0.203] ([151.127.53.97]) by mrelayeu.kundenserver.de
 (mreue011 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MVe5c-1oWOrt2qF2-00RWCH; Wed, 23 Nov 2022 16:40:57 +0100
Message-ID: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
Date:   Wed, 23 Nov 2022 16:40:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Content-Language: fr, en-US
From:   Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:pYmZKIjhwEar5+zrSn8EoxJrueGNr0TSCBf+WtXkAd8BvNef9B/
 OHCKLrJsAjusLNEWTW5K3zYIvPXLKkK3ysJLxZ4ZsTdcy8zcz5be09kjSZM5EkCIPDAiLiR
 YqrAqAbJftFEh4Pobn9RNqTAc9U49IAHZIiDhnI1i4EHK8Z5b9cF6vUn+Hkjp2JG9cvgMoC
 4kNZJnJZN07XQVk8+aYiQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1iTK9Mme8R0=:x5r7JV6cEEzk0QklHUaWhl
 U2yVwM1TcjlTm4kedfmfCqsnflLKj7JhV/9Xv/ERlfLEDD9ez6gcX27nQI91ZWxm9HXHwh9ou
 frnQS2fY4MsLsXkK6LPYyzNo8BILMGz2WUpAgZcMH8NEcVpI762/xjdSSA+YhmR6q5j6zGd80
 q8+a2h23HCYuPIUODbk0b8aUnOzLU6gLEN+OCrOAycztx3h73Ky7pmvr0ayhUG8I1H5OJrQ6q
 cVfo2mTNnmQ64VKesrsDldFetT9Tk2HBEgp76d92frvqsXUcbopg3XpVR43xYHG6CiFUNNA7y
 tD65EEG+Re1AB7jCiAuAP7GEUZ0jYIHSIXNtdKrdvptkb3mkVDL8eDpwb9jySLKGwLmFxP40I
 6VIBp6cY4DlqdtEeWRApYlwss8QIeUw40EBl4Tzkb//oMJvggojRV+B2cgDt/aFyYyZD32P1e
 tj+VZp/8LLEo7dgAqesx0fPjPSw8MG2Fw1eYYLn6+7zyJosQFAig1A+XaZSSRy4YRzs5Q1oWn
 ZIU+XSo1i1gmOYocclwsk6DjBSXLSXSp4tlqjHOfDoUYsFibEpirK7VQ8EFtTuZ4ULv0vhhrx
 j0AKcYhK0hCDdbWDtidBKtZsACHtBRKxtgYJhuINhYpXrtMRLInoDsczyZVRDrBpaDfZ9EuDv
 WWrwr5J08QFmJfWR89P+QRFUMfIRTtgEzXy+3GEXvPQZiCisTqhslH08ZR0+lIiZdT3yO46+v
 Z+CgcsU0dZAM1IItB4lrzrnVVZyMie6gB00bUhZHC/gZiQ0IHn7Sxk/KOOzGWObxwXq1tWRTI
 r4xR253irs4i81AzdKp0l8+h8JEP+rmrlJR7uZyVtW7wMCUCJo=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2022 13:46, Greg Kroah-Hartman wrote:
> The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> any system that uses it with untrusted hosts or devices.  Because the
> protocol is impossible to make secure, just disable all rndis drivers to
> prevent anyone from using them again.
> 
> Windows only needed this for XP and newer systems, Windows systems older
> than that can use the normal USB class protocols instead, which do not
> have these problems.
> 
> Android has had this disabled for many years so there should not be any
> real systems that still need this.

I kind of disagree here. I have seen plenty of android devices that only 
support rndis for connection sharing, including my android 11 phone 
released in Q3 2020. I suspect the qualcomm's BSP still enable it by 
default.

There are also probably cellular dongles that uses rndis by default. 
Maybe ask the ModemManager people ?

I'm also curious if reimplementing it in userspace would solve the 
security problem.
