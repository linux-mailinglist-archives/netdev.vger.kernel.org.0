Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B63D37BE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJKDLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:11:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:55148 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfJKDLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 23:11:32 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9B3AiNi016659;
        Thu, 10 Oct 2019 22:10:45 -0500
Message-ID: <158fa0872643089750b3797fd2f78ba18eaf488c.camel@kernel.crashing.org>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Vijay Khemka <vijaykhemka@fb.com>, Joel Stanley <joel@jms.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Date:   Fri, 11 Oct 2019 14:10:44 +1100
In-Reply-To: <AF7B985F-6E42-4CD4-B3D0-4B9EA42253C9@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
         <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
         <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
         <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
         <AF7B985F-6E42-4CD4-B3D0-4B9EA42253C9@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 19:15 +0000, Vijay Khemka wrote:
>     Any news on this ? AST2400 has no HW checksum logic in HW, AST2500
>     should work for IPV4 fine, we should only selectively disable it for
>     IPV6.
> 
> Ben, I have already sent v2 for this with requested change which only disable 
> for IPV6 in AST2500. I can send it again.

I didn't see it, did you CC me ? I maintain that driver...

Cheers,
Ben.


