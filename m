Return-Path: <netdev+bounces-7907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71B17220BA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6023F281224
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82942125CD;
	Mon,  5 Jun 2023 08:15:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EDC17E8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:15:15 +0000 (UTC)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D82EA9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:15:12 -0700 (PDT)
X-QQ-mid:Yeas50t1685952763t318t21946
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [60.177.99.31])
X-QQ-SSF:00400000000000F0FPF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 11751809325026712248
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
References: <20230605025211.743823-1-jiawenwu@trustnetic.com> <20230605025211.743823-3-jiawenwu@trustnetic.com> <ZH2IaM86ei2gQkfA@shikoro> <00c901d9977e$af0dc910$0d295b30$@trustnetic.com> <ZH2UT55SRNwN15t7@shikoro>
In-Reply-To: <ZH2UT55SRNwN15t7@shikoro>
Subject: RE: [PATCH net-next v11 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Mon, 5 Jun 2023 16:12:42 +0800
Message-ID: <00eb01d99785$8059beb0$810d3c10$@trustnetic.com>
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
Thread-Index: AQKoIYpMsU3pQxi84WWC4YPAy6bqVAIyHk5AAe8WB/YDFYJsZwGgoPRlrZgJMUA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Monday, June 5, 2023 3:53 PM, Wolfram Sang wrote:
> > Do you mean the device tree binding? This property in only used in case of software
> > node, for wangxun Soc, which has no device tree structure.
> 
> I see, thanks.
> 
> How is the dependency of these patches? I'd like to take this patch via
> the i2c tree if possible. I guess the other patches will build even if
> this patch is not in the net-tree? Or do we need an immutable branch? Or
> is it really better if all goes in via net? We might get merge conflicts
> then, though. There are other designware patches pending.


Yes, other patches will build even without this patch. But SFP will not work.
This patch series implement I2C, GPIO, SFP and PHYLINK. The support of SFP
is dependent on I2C and GPIO. If these patches will be end up merging in the
same upstream version, it's not a problem to merge them in different trees,
I think.


