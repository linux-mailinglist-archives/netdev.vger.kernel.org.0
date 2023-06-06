Return-Path: <netdev+bounces-8254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C39B7234EC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 717AE1C20DC2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED53D38B;
	Tue,  6 Jun 2023 02:00:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36217F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:00:44 +0000 (UTC)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B12C11D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:00:38 -0700 (PDT)
X-QQ-mid:Yeas47t1686016735t022t10825
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [122.235.137.64])
X-QQ-SSF:00400000000000F0FPF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 9184358918971991978
To: "'Wolfram Sang'" <wsa@kernel.org>,
	"'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>,
	"'Piotr Raczynski'" <piotr.raczynski@intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com> <20230605025211.743823-3-jiawenwu@trustnetic.com> <ZH2IaM86ei2gQkfA@shikoro> <00c901d9977e$af0dc910$0d295b30$@trustnetic.com> <ZH2UT55SRNwN15t7@shikoro> <00eb01d99785$8059beb0$810d3c10$@trustnetic.com> <ZH2zb7smT/HbFx9k@shikoro> <ZH22jS7KPPBEVS2a@shell.armlinux.org.uk> <ZH3bwBZvjyIoFaVv@shikoro>
In-Reply-To: <ZH3bwBZvjyIoFaVv@shikoro>
Subject: RE: [PATCH net-next v11 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Tue, 6 Jun 2023 09:58:54 +0800
Message-ID: <018701d9981a$7278a0a0$5769e1e0$@trustnetic.com>
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
Thread-Index: AQKoIYpMsU3pQxi84WWC4YPAy6bqVAIyHk5AAe8WB/YDFYJsZwGgoPRlARtMc6UB69Ld1gHEZZjMAfxOIvGtYvdiEA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Monday, June 5, 2023 8:58 PM, Wolfram Sang wrote:
> > Be careful... net-next uses patchwork, and I suspect as this is posted
> > as a series which the subject line states as being destined by the
> > author for the "net-next" tree, the entire series will end up being
> > slurped into the net-next tree.
> 
> Thanks for the pointer. Jiawen Wu, would you kindly send a v12 of the
> series (without the I2C patch)?

Okay, v12 series will be other 8 patches for net-next.
Do I need to send this independent patch to I2C tree?


