Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838683006BC
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbhAVPJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:09:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43545 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbhAVPIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611328115; x=1642864115;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6zu8MlMShN9Ib9rDU4wIv0fx6cyy6xyXMOXpTz5PFEQ=;
  b=iJrkWAws+oBTguO6bSNj1B3z9uPxexZAo6XgQfepDISDjEtioQ//2T0Y
   fVxezuP+z7ZvYUIY1bdyQdhnjbygFgnzbPIuBXMsrCx9rYdJ5oQLVBkva
   As/ze5PPB9fec3FhkJrzRskrb5nOfdNxrQwiDxkYOLrn4jjyy7yNHdWpa
   BydbqT97T72eLwr+pPVfbEfqgJsGez07YHgrtZDJIk/hbBmud4FzVXzHE
   FZUxeQDeZj+KXIwJlvQtojEmMbzwieQhmuWnGh9PFOVRmp9J2+tgpvbQr
   cwvZoyjnvSBYzYKxj41rpM1lVbCDpI+29AYIH7jZr6Fn3hWYEemaiATVc
   Q==;
IronPort-SDR: UITEgIWuFfaOvui8+35ei3Utu8w+I4pODl0GKLshpB51f2xC1SdkL02OuLKfSFL7q7VvssOHP5
 l+0MymSte3q05g5DHZiDXX1Sf2FQvZSMEIUmZHFNFr1T1BetmNDKrE9p4UxdrQzkokjLL6xtcf
 MfZy7eLWoJNt5EHPW1EeyhvigfqIk5dBeZ6jiIWluHoqra2NClzUEDLm0haQpVLynnglA7Xrzp
 aH0SL1GP6BXYqV7ZzZSLfqdAb92bEd5PAJtMs3n3U1nC7OGX+47jRa9HWqv97qJu4dI4FNWZuT
 DT0=
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="41376057"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jan 2021 08:07:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 08:07:19 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 22 Jan 2021 08:07:17 -0700
Message-ID: <2c7474cf57964935cebd75083229cdee14064a79.camel@microchip.com>
Subject: Re: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Fri, 22 Jan 2021 16:07:16 +0100
In-Reply-To: <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
         <20210107091924.1569575-3-steen.hegelund@microchip.com>
         <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kishon and Vinod,

On Fri, 2021-01-15 at 21:22 +0530, Kishon Vijay Abraham I wrote:
> > 
> > 

I was just wanted to know if there are any outstanding items that you
would like me to handle, or you think that the driver is acceptable as
it is now?

BR
Steen




