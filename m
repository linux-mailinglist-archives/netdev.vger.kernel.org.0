Return-Path: <netdev+bounces-6327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FC6715C1D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C3CA281137
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878FD12B8A;
	Tue, 30 May 2023 10:45:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0E84A0C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:45:47 +0000 (UTC)
Received: from fgw22-7.mail.saunalahti.fi (fgw22-7.mail.saunalahti.fi [62.142.5.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C5110A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:45:29 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTP
	id 0eace6de-fed7-11ed-a9de-005056bdf889;
	Tue, 30 May 2023 13:45:15 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Tue, 30 May 2023 13:45:13 +0300
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Andy Shevchenko' <andriy.shevchenko@linux.intel.com>,
	'Hans de Goede' <hdegoede@redhat.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v9 1/9] net: txgbe: Add software nodes to
 support phylink
Message-ID: <ZHXTuejpG6OfipUw@surfacebook>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com>
 <20230524091722.522118-2-jiawenwu@trustnetic.com>
 <ZHHC6OGH9NJZgRfA@smile.fi.intel.com>
 <038901d992bd$863a6b30$92af4190$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <038901d992bd$863a6b30$92af4190$@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 30, 2023 at 02:11:08PM +0800, Jiawen Wu kirjoitti:
> On Saturday, May 27, 2023 4:44 PM, Andy Shevchenko wrote:
> > On Wed, May 24, 2023 at 05:17:14PM +0800, Jiawen Wu wrote:

...

> > > +int txgbe_init_phy(struct txgbe *txgbe)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = txgbe_swnodes_register(txgbe);
> > > +	if (ret) {
> > > +		wx_err(txgbe->wx, "failed to register software nodes\n");
> > 
> > > +		return ret;
> > > +	}
> > > +
> > > +	return 0;
> > 
> > These 4 lines can be as simple as
> > 
> > 	return ret;
> 
> This function is going to be extended with later patches, is it necessary to
> simply it here?

Nope, thank you for elaboration.

> > > +}

-- 
With Best Regards,
Andy Shevchenko



