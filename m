Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E6F6EBC6C
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 04:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDWCcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 22:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDWCb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 22:31:59 -0400
X-Greylist: delayed 77423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Apr 2023 19:31:53 PDT
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3ED1717;
        Sat, 22 Apr 2023 19:31:52 -0700 (PDT)
X-QQ-mid: Yeas5t1682217071t196t32057
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 1302647852042328395
To:     "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>
Cc:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <jarkko.nikula@linux.intel.com>,
        <olteanv@gmail.com>, <hkallweit1@gmail.com>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com> <20230422045621.360918-3-jiawenwu@trustnetic.com> <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
In-Reply-To: <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
Subject: RE: [PATCH net-next v4 2/8] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Sun, 23 Apr 2023 10:31:09 +0800
Message-ID: <000201d9758b$aa3193a0$fe94bae0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLYcl6q9PfLE2IPpEOvRSb72esQRAIu4J5yAbvC5R+tGtF3kA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +++ b/include/linux/platform_data/i2c-dw.h
> 
> No way we need this in a new code.

Do I have to rely on OF or ACPI if I need these parameters?

> 
> > +struct dw_i2c_platform_data {
> > +	void __iomem *base;
> 
> You should use regmap.

The resource was mapped on the ethernet driver. How do I map it again
with I2C offset?

> 
> > +	unsigned int flags;
> > +	unsigned int ss_hcnt;
> > +	unsigned int ss_lcnt;
> > +	unsigned int fs_hcnt;
> > +	unsigned int fs_lcnt;
> 
> No, use device properties.
> 
> > +};
> 
> --
> With Best Regards,
> Andy Shevchenko
> 
> 
> 

