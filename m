Return-Path: <netdev+bounces-2027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 192F1700012
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EA36281A01
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A616C111A;
	Fri, 12 May 2023 06:01:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9779FA2A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:01:14 +0000 (UTC)
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01B119AE
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:01:09 -0700 (PDT)
X-QQ-mid: bizesmtp81t1683871264t8z6dgw5
Received: from smtpclient.apple ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 12 May 2023 14:01:02 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: +bXiSo2NuBdJm0+mn7kl/ZvNMTSX7wB3yxkyKr2euobMmOZWjgoCaZEApQszm
	x+KJtDZo5i/RkNgLnpHxZih3U1GLP2CQjqFcr55oT0TDzlJnmhijs39UBi4VX/8R8VNiQJy
	ZPIOjK2V6HkeVwdBbhArNlEtXpubv2m4zH2qudukcdIfnzyMaj5b3jwFnG/2/OEsFixuFCL
	6J0aCxX890xRKq8bBYbYoVLHuqW2GsEMKFIHqz0c4Bxpnf1jsx6qCJihmnuTAbAtJj3uzcc
	gcnshtg8eUlp0IXZkBp0wOOgcMx2c9MKXjmlwH503X1wIsZO40gUhdJ0QwO2dC7EMsBQS/N
	vqmj2xw//Glz4ardr1uHN5F4c6Ljr070dVDydQ4RAr9HjkKKkgANhVmnN1fujBQjO0LXSNu
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 12307656987849433464
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next v4 2/7] net: wangxun: libwx add rx offload
 functions
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <06898ce3-3995-2e83-3b2b-97f92fa46d7c@huawei.com>
Date: Fri, 12 May 2023 14:00:52 +0800
Cc: netdev@vger.kernel.org,
 Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4AB10E12-CFA2-4879-9346-8C73E926B706@net-swift.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-3-mengyuanlou@net-swift.com>
 <b26664c9-7df9-f2dc-ca49-3e5abd3dab70@huawei.com>
 <25FF2886-3FE3-4B20-9A77-217ADE6502B8@net-swift.com>
 <06898ce3-3995-2e83-3b2b-97f92fa46d7c@huawei.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> 2023=E5=B9=B45=E6=9C=8811=E6=97=A5 19:48=EF=BC=8CYunsheng Lin =
<linyunsheng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 2023/5/11 16:34, mengyuanlou@net-swift.com wrote:
>>>> @@ -321,8 +321,31 @@
>>>=20
>>> ...
>>>=20
>>>> +
>>>> +static inline struct wx_dec_ptype wx_decode_ptype(const u8 ptype)
>>>=20
>>> If the above is only used in one .c file, maybe it does not need
>>> to be in the .h file?
>>=20
>> If I put it to .c file which use it, when compiling the other .c =
files will say
>> "warning: =E2=80=98wx_ptype_lookup=E2=80=99 defined but not used=E2=80=9D=
.
>=20
> Is 'wx_ptype_lookup' used in other .c file? if not, why not move
> it to .c file too?
>=20
I mean how to you fix this compile warning.

>>>=20
>>>> +{
>>>> + return wx_ptype_lookup[ptype];
>>>> +}
>>>> +
>=20


