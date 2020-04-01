Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0665819B66C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbgDATfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:35:15 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52599 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732244AbgDATfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 15:35:15 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id EBAE544090C;
        Wed,  1 Apr 2020 22:34:55 +0300 (IDT)
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il> <ad024231-40bd-c82f-e6d0-3b1b00c93e9a@gmail.com> <87tv23ausd.fsf@tarshish> <20200401193016.GA114745@lunn.ch>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Shmuel Hazan <sh@tkos.co.il>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
In-reply-to: <20200401193016.GA114745@lunn.ch>
Date:   Wed, 01 Apr 2020 22:35:13 +0300
Message-ID: <87sghnatji.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Apr 01 2020, Andrew Lunn wrote:
>> I can't do much about that, unfortunately.
>
> What did Marvell say when you asked them to release the firmware to
> firmware-linux?

I didn't ask Marvell. Past experience is not very encouraging in this
regard.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
