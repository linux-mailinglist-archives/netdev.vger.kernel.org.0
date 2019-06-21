Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33904E9CD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfFUNrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 09:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfFUNrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 09:47:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F07E2206B7;
        Fri, 21 Jun 2019 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561124862;
        bh=pNldUrqmJvya/Uwu9bDRmh68i2HgU65QwS4iKeIec5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oCKJQsAxHNH+eZZtSWdAK01ZD+7IvrRz9N0tstd1wnfuSwvYFeU40smNuMdeKIVTq
         DH83XTjHwc5jLQEnTUBzj5OGl7VYS4dga6Adwzlz0s+q2BAxCGZrUvQGe0EuRQJofj
         ZmoAtS0rnjTz1nWMkoe70INYL2oQmlD9uyy3Fql8=
Date:   Fri, 21 Jun 2019 15:47:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH v2 09/29] docs: driver-model: convert docs to ReST and
 rename to *.rst
Message-ID: <20190621134740.GA26549@kroah.com>
References: <cover.1560890800.git.mchehab+samsung@kernel.org>
 <0ac41c7d682452cdbd867c4ae7729b6b34d79c0b.1560890800.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ac41c7d682452cdbd867c4ae7729b6b34d79c0b.1560890800.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 05:53:27PM -0300, Mauro Carvalho Chehab wrote:
> Convert the various documents at the driver-model, preparing
> them to be part of the driver-api book.
> 
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com> # ice

Now applied, thanks.

greg k-h
