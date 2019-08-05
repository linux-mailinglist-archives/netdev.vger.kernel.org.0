Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F25819ED
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 14:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfHEMrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 08:47:18 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35051 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfHEMrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 08:47:17 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so167021337ioo.2;
        Mon, 05 Aug 2019 05:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aNRu8d6P0l9UPeO2XHPUBXtwBghX09sN9CzqbrlIoh0=;
        b=j/bAgWAil3mRiYky6AnRqLeM8V1zdbGU/zoXCwNDELkUqbe57Wb3Rqul+Yp7KZYmnp
         /pXsxz4Ec1Ja6QFaBuqCCTyu4IjNEWuXjoThkG+AEQ3Th8XgyCwagIqsWbWYPl+qLynY
         W81J2gSa/MLIwFXNv3zKXUKIu5+D6qnfW8TKgghA/61gAyF195B5MtLkiuE6PG8N0NnQ
         /jqsrHJ7xyMicdJQmRxfBJG7YG5IsqcncR8/nnzSg6vU/sfnl9j+NaGJwjiVoItP7UVP
         EROiUjX4A8VVYEfbXRhf/BX2VbQyKxkP3acsT18XJ41Jp698vRCg2ZZbbeGLgnFHmK/y
         HpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aNRu8d6P0l9UPeO2XHPUBXtwBghX09sN9CzqbrlIoh0=;
        b=mJz9CU045Tvh6I/fIkeLnimMLsV/ZiIYruMmtModtZwQHS9xztZhMzMJjxiZ3o+toF
         YmjsEhTrSPxZaa/UjlfaP+f1pkh7HrlTw0fKZwjuo2PpuOJ2plehJ1YhGIuum1n9W8DE
         1kjc9RTlNAqYxT2dcpi7wWrx7E4NuRbxm6dJgKwt7y1mKOGSh8gAGbdtmvo8wBLcyNCx
         ccjyBPjzAM7FrHRf8r5JFWJBXR7uRoXxItscZBaGw76K/UPLSRa/W5LZDnL0WFH+3Fhc
         b3jtyylqqOD59RDnjWtvQI63It3GXi7o1u68UI9YAFI3bkIzAto1UIu9zfXBmW0ot2dR
         pJMQ==
X-Gm-Message-State: APjAAAXMEPukTE20sldkFSovfHUr+8vXoqM9C8WvSVogKZ9pK/yCRuUb
        VjM+c7IZQk2OkrUArP9TvRdDpa6OH9hB8IJg2jw=
X-Google-Smtp-Source: APXvYqzXL2hkLoxBzy0mGaLH2PFh9enoPkAIlPHpx/CXR2e8aI0nWFKy0Tu9frhpX5sT1w1c87ndw7D6azKbKOfDYYg=
X-Received: by 2002:a02:cb4b:: with SMTP id k11mr152797148jap.109.1565009236799;
 Mon, 05 Aug 2019 05:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-3-arnd@arndb.de>
 <20190801055821.GB24607@kroah.com>
In-Reply-To: <20190801055821.GB24607@kroah.com>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Mon, 5 Aug 2019 08:47:05 -0400
Message-ID: <CA+rxa6rJE2R7R_r8nx7HyHu4xc8ujQB1rRG+0Yx2XzwtoiD5CQ@mail.gmail.com>
Subject: Re: [PATCH 02/14] usb: udc: lpc32xx: allow compile-testing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, soc@kernel.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>

On Thu, Aug 1, 2019 at 1:58 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jul 31, 2019 at 09:56:44PM +0200, Arnd Bergmann wrote:
> > The only thing that prevents building this driver on other
> > platforms is the mach/hardware.h include, which is not actually
> > used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/usb/gadget/udc/Kconfig       | 3 ++-
> >  drivers/usb/gadget/udc/lpc32xx_udc.c | 2 --
> >  2 files changed, 2 insertions(+), 3 deletions(-)
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
