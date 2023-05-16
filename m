Return-Path: <netdev+bounces-2928-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0366870492C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 001721C20D5E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85D6156FB;
	Tue, 16 May 2023 09:27:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5B72C731
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:27:09 +0000 (UTC)
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F5A1B5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:27:03 -0700 (PDT)
X-QQ-mid: bizesmtp70t1684229214tu60xdwa
Received: from smtpclient.apple ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 16 May 2023 17:26:52 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: muk4Epq72NYPAtxT/pA4ka7X47IXqy6rnIUBdQSk61Rb9LY3GyZhb2RezC91u
	Ue+mOJjjcrcxO/eHWmM5TnL5Ltfl4gVRQVkygIPExiU+W4IlEixKzbmnzVrCFw+xuMt99vJ
	h0bCujmpf8yb6gWBdhodDLzETwk+RIOe2VxV9qbij6hFsy/19GlCtGQIZHNXJnyp4kz/j6M
	Jgl8GfyrHz3RWeWH2vJYEKZ+sY24bx8iXkefAvMUDgff/oy/WktiZ3E36XM45Eigz9Yq1fT
	VCieLPTHrfpzy7CWLgSxo8LlwQ8ulfYJg3Ihz0hboBxWGe9+lzlM+sZKjMISaH8dw2MVT1e
	HDvRStd0KcpIo7Juhw84R+PdOI2AbysK1CtxW95jqcgznsXJQR8e4FgWlcRH6iJq0LGwnw4
	+ZmB7L9c+Zo=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 16343888455013354399
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next v5 4/8] net: libwx: Implement xx_set_features ops
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <ZGM+dmZWidau5fsn@corigine.com>
Date: Tue, 16 May 2023 17:26:42 +0800
Cc: netdev@vger.kernel.org,
 Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1EA8C2D8-FABF-484C-8B8D-3D3F1A5B0FBA@net-swift.com>
References: <20230515120829.74861-1-mengyuanlou@net-swift.com>
 <20230515120829.74861-5-mengyuanlou@net-swift.com>
 <ZGM+dmZWidau5fsn@corigine.com>
To: Simon Horman <simon.horman@corigine.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> 2023=E5=B9=B45=E6=9C=8816=E6=97=A5 16:27=EF=BC=8CSimon Horman =
<simon.horman@corigine.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, May 15, 2023 at 08:08:25PM +0800, Mengyuan Lou wrote:
>> Implement wx_set_features fuction which to support
>> ndo_set_features.
>=20
> Hi Mengyuan,
>=20
> function seems to be misspelt.
>=20
> $ ./scripts/checkpatch.pl --codespell
> WARNING: 'fuction' may be misspelled - perhaps 'function'?
> #6:=20
> Implement wx_set_features fuction which to support
>=20
>=20
Thanks for review.


