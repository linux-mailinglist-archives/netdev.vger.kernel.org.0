Return-Path: <netdev+bounces-692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0906F90E7
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 11:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 729DF1C21AC4
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 09:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96801FD5;
	Sat,  6 May 2023 09:31:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8637C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 09:31:32 +0000 (UTC)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFB07D82
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 02:31:26 -0700 (PDT)
X-QQ-mid:Yeas43t1683365356t276t13906
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [36.24.99.3])
X-QQ-SSF:00400000000000F0FMF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 12391180583042309501
To: <andy.shevchenko@gmail.com>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230505074228.84679-1-jiawenwu@trustnetic.com> <20230505074228.84679-3-jiawenwu@trustnetic.com> <ZFVPYSKfvQq3WeeO@surfacebook> <ZFViufP6qh79C1-T@surfacebook>
In-Reply-To: <ZFViufP6qh79C1-T@surfacebook>
Subject: RE: [RFC PATCH net-next v6 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Sat, 6 May 2023 17:29:15 +0800
Message-ID: <000001d97ffd$39ae2db0$ad0a8910$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQDsFpk5SrKUGrGdHIjrRExvlw6PFQJ3wA8LASWLNdABg1HF47D+jr2A
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Saturday, May 6, 2023 4:11 AM, andy.shevchenko@gmail.com wrote:
> Fri, May 05, 2023 at 09:48:01PM +0300, andy.shevchenko@gmail.com kirjoitti:
> > Fri, May 05, 2023 at 03:42:21PM +0800, Jiawen Wu kirjoitti:
> 
> ...
> 
> > > +	device_property_read_u32(&pdev->dev, "wx,i2c-snps-model", &dev->flags);
> >
> > I believe in your case it should be named something like
> > "linux,i2c-synopsys-platform". But in any case this I leave
> > to the more experienced people.
> 
> Or "snps,i2c-platform", I dunno...

I thought you wanted me to introduce a property specific to my device,
so I named it "wx,...". But if it's a universal property for platform device,
maybe it's necessary to check if flag is NULL, otherwise the second result
will overwrite it.


