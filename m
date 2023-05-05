Return-Path: <netdev+bounces-629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C49986F8A05
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 22:10:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A04C280FF1
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA3FD2E8;
	Fri,  5 May 2023 20:10:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5439A2F33
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 20:10:39 +0000 (UTC)
Received: from fgw22-7.mail.saunalahti.fi (fgw22-7.mail.saunalahti.fi [62.142.5.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE66E114
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:10:37 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTP
	id e43ea10f-eb80-11ed-a9de-005056bdf889;
	Fri, 05 May 2023 23:10:35 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Fri, 5 May 2023 23:10:33 +0300
To: andy.shevchenko@gmail.com
Cc: Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [RFC PATCH net-next v6 2/9] i2c: designware: Add driver support
 for Wangxun 10Gb NIC
Message-ID: <ZFViufP6qh79C1-T@surfacebook>
References: <20230505074228.84679-1-jiawenwu@trustnetic.com>
 <20230505074228.84679-3-jiawenwu@trustnetic.com>
 <ZFVPYSKfvQq3WeeO@surfacebook>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFVPYSKfvQq3WeeO@surfacebook>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 05, 2023 at 09:48:01PM +0300, andy.shevchenko@gmail.com kirjoitti:
> Fri, May 05, 2023 at 03:42:21PM +0800, Jiawen Wu kirjoitti:

...

> > +	device_property_read_u32(&pdev->dev, "wx,i2c-snps-model", &dev->flags);
> 
> I believe in your case it should be named something like
> "linux,i2c-synopsys-platform". But in any case this I leave
> to the more experienced people.

Or "snps,i2c-platform", I dunno...

-- 
With Best Regards,
Andy Shevchenko



