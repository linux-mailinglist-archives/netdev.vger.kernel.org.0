Return-Path: <netdev+bounces-7884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C02D4721F7C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 516F22811D8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4D5AD38;
	Mon,  5 Jun 2023 07:25:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71324194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:25:47 +0000 (UTC)
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C30CA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:25:45 -0700 (PDT)
X-QQ-mid:Yeas50t1685949835t198t22141
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [60.177.99.31])
X-QQ-SSF:00400000000000F0FPF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 10775698858849154079
To: "'Wolfram Sang'" <wsa@kernel.org>
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
	<mengyuanlou@net-swift.com>,
	"'Piotr Raczynski'" <piotr.raczynski@intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com> <20230605025211.743823-3-jiawenwu@trustnetic.com> <ZH2IaM86ei2gQkfA@shikoro>
In-Reply-To: <ZH2IaM86ei2gQkfA@shikoro>
Subject: RE: [PATCH net-next v11 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Mon, 5 Jun 2023 15:23:54 +0800
Message-ID: <00c901d9977e$af0dc910$0d295b30$@trustnetic.com>
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
Thread-Index: AQKoIYpMsU3pQxi84WWC4YPAy6bqVAIyHk5AAe8WB/atva9VMA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Monday, June 5, 2023 3:02 PM, Wolfram Sang wrote:
> Hi,
> 
> On Mon, Jun 05, 2023 at 10:52:04AM +0800, Jiawen Wu wrote:
> > Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> > with SFP.
> >
> > Introduce the property "wx,i2c-snps-model" to match device data for Wangxun
> 
> Does this not need some binding documentation somewhere?

Do you mean the device tree binding? This property in only used in case of software
node, for wangxun Soc, which has no device tree structure.

> 
> > in software node case. Since IO resource was mapped on the ethernet driver,
> > add a model quirk to get regmap from parent device.
> 
> All the best,
> 
>    Wolfram



