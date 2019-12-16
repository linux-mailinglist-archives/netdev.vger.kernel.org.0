Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBEB12101A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfLPQvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:51:06 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45794 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:51:05 -0500
Received: by mail-qt1-f195.google.com with SMTP id l12so6268842qtq.12;
        Mon, 16 Dec 2019 08:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=W4O6k67GfjEXcryRt2BFpux0k7KGkAzksxyGgmCZObI=;
        b=WkwOuyKnh0BhjsoRSwFvRhyT1WaVvJkcZqYxEpSDAVi3J3jIrqy7j/7xlyv6VCXRGt
         3wwfk6pFKaqZ3U2Z/KxGtAYlizFb9mpmyopREGI+wLBVlSAXMPlOuumSIuuPwbdegamS
         0Tunu0zfoL9n9pvKN1twtQHXPDs4Z79Bw8EShQC/yDuNv46VNYEeHWWXwQcd7dQ8y87k
         WbNxAeqlxgAvsQ6JDHehwefju1x76YPgyF7fwLR1yl3jqLRSONSepfSWXtDpR8OEcKpd
         b+k4+ouvh6f7e+dHrlbAMBospmbr0n1A9OFjLVLmto+vXaH37ZyHFe/Y8Dr1AI/aNf/k
         bQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=W4O6k67GfjEXcryRt2BFpux0k7KGkAzksxyGgmCZObI=;
        b=TXPjzRRr1v6uVp288Yjrf8wzDURXE0HWjbBhWPtgZhz6WgFyW8brlh0xQcpp/UueDV
         RDtgjUavYpj9xWpaUnUMi+cnrNGQbMGIz+T/LPqn7FC3CAEILTijgdRMGii1zI5VOrnL
         P5SPiBs8meWmln5SYq2PaSmiMxTuf9cv3igHg9OWgCRG/ipL1wtdAlXD80osRHfiGNYh
         wTqUaAc6bdcRpurDjdKnaJ62WMhfYud7k9PHBsCQTWqiCUrXF4XVEB1pDgPl/HStS7KL
         QbhFkP0ri1xbGZ2Zk4I2qFOOnXBgfcB3+T/bJ6JhvtmEWkP/bHrNlfEEIFCqc5275Wv+
         1kcA==
X-Gm-Message-State: APjAAAUwnHQzoq5EHxoa/GV5UHre1xF2LDcmZTsk5IkSwaaRZk1sZGql
        AqYsnF+xk06whuiN/A+ekII=
X-Google-Smtp-Source: APXvYqy6tZPu2WmGWY9idlGNMroe5J64lIFHSkS5SMk8g1WTtdP61Exq4/UAlvvkbagvetYBkxYoaw==
X-Received: by 2002:ac8:7586:: with SMTP id s6mr105053qtq.309.1576515064844;
        Mon, 16 Dec 2019 08:51:04 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b3sm7102789qtr.86.2019.12.16.08.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:51:04 -0800 (PST)
Date:   Mon, 16 Dec 2019 11:51:03 -0500
Message-ID: <20191216115103.GD2051941@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v5 4/5] net: dsa: add support for Atheros AR9331 TAG
 format
In-Reply-To: <20191216074403.313-5-o.rempel@pengutronix.de>
References: <20191216074403.313-1-o.rempel@pengutronix.de>
 <20191216074403.313-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 08:44:02 +0100, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> Add support for tag format used in Atheros AR9331 built-in switch.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
