Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC3BDD818
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfJSK0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 06:26:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:35061 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfJSK0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 06:26:18 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9JAPXS6004953;
        Sat, 19 Oct 2019 05:25:34 -0500
Message-ID: <72d1a78d7807b1bda00e1bafe0c2ecefe267918b.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Date:   Sat, 19 Oct 2019 21:25:32 +1100
In-Reply-To: <3D78AA04-A502-4A9F-87A0-0D62D56952AF@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
         <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
         <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
         <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
         <9AA81274-01F2-4803-8905-26F0521486CE@fb.com>
         <f6d5cb45a9aa167533135c5b218b45b1d210d31a.camel@kernel.crashing.org>
         <529EF9B4-DFDE-4DB7-BE26-3AED8D814134@fb.com>
         <0ef567e985ce3fe821cbd80265f85a35d16be373.camel@kernel.crashing.org>
         <3D78AA04-A502-4A9F-87A0-0D62D56952AF@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-19 at 01:31 +0000, Vijay Khemka wrote:
> Thanks Ben,
> I will try to add some trace and test whatever possible and test it.
> As we
> don't have tcpdump into our image and I have limited understanding of
> networking stack so if you get some time to verify ipv6, it will be
> really
> helpful. 
>     

You only need tcpdump (or wireshark) on the *other end* of the link,
could even be your laptop, to look at what the generated frames look
like and compare with your traces.

Cheers,
Ben.


