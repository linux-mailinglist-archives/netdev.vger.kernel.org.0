Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C1815C75A
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgBMQJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:09:47 -0500
Received: from mail-ed1-f41.google.com ([209.85.208.41]:45505 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgBMQJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:09:46 -0500
Received: by mail-ed1-f41.google.com with SMTP id v28so7423208edw.12
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 08:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRslYTCWYeSgImtd2CSI5RP4dkVWMZ2uqrCBU4QdMH4=;
        b=J2dKge7cowpFAB44M5r2UVS8FWfEQX+Ia3C9oPdyEklcN8J3+wIqFBnZ3OdiYrbHWP
         OQfyTACmN0+9mnZF4CSQPvFY56o6US8P03PXF3AOV9jDqiqOSieLcX2eH0rLW1mm8AY2
         +eFDMeUIUvQ/FlQTVyvXrijMoDPRwG8dNIn7fR0jwCIkbBEJfzSfdwVo1GHuGEQfPzH0
         rCqKLpqdljc3aQBh6sU4ZlYpwZ4wyHmQOwiP/n6nKx29rQEY0StZBH5tOLcDWNFuHFiy
         UOBdAS1T7/QId5FcuXeYhYy0vq6NozlLB49CyG/FYqbxIQ96PHBdNlJ4B0EkSC0edzFv
         2mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRslYTCWYeSgImtd2CSI5RP4dkVWMZ2uqrCBU4QdMH4=;
        b=eetGCqvb5g6WkxSlMoxj4QaS69eOvpoJlfiW2/kGsnpDmT6GbEo/3tpm2dV0S4JpOz
         yWByQU2WvOgcoK2FAamgoBhFCDmryeZCdgmi8o51AwZcH+Wtc7vwsY+pALIMnVS3Um4s
         UK0Ou0cgOUe5U0JIV/msuxMRbpMccpuCa2LzbJrhZ+MG4nkuiKF6is1+HB2/oYEQSY+3
         d7X58cKb4yP90LMchqwrIE8sM4+A3P6FMObBpWRlMTcBygowDUMGXxd8O9aFEridJ+e/
         qygxl/H5mFnAh2J3edpP9tDkPFa34PFgnJZg8cBUtG8w5FwVckNGxrWCWlWybdw0F0wS
         XwdA==
X-Gm-Message-State: APjAAAV8TfermY+bRJWsi+Vy81kd2nc43FOirTuzwppsav/B4s+MeJeJ
        woEIiyRauBVSxNCa3wy6GqZIcYXCTquXxDeC2Ng=
X-Google-Smtp-Source: APXvYqzRG0ESr894ZXpxGqNnoTFW407TwaFxDKMS5RL2CfFRvHWTb9Um0j2leMOW/aTwCsW2pNVGfbjMeqyJythldMY=
X-Received: by 2002:a17:906:1e48:: with SMTP id i8mr15674879ejj.189.1581610185292;
 Thu, 13 Feb 2020 08:09:45 -0800 (PST)
MIME-Version: 1.0
References: <20200213133831.GM25745@shell.armlinux.org.uk> <20200213144615.GH18808@shell.armlinux.org.uk>
 <CA+h21ho=siWbp9B=sC5P-Z5B2YEtmnjxnZLzwSwfcVHBkO6rKA@mail.gmail.com> <20200213160612.GD31084@lunn.ch>
In-Reply-To: <20200213160612.GD31084@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 13 Feb 2020 18:09:34 +0200
Message-ID: <CA+h21hqcpW3OtDGUBKQ58ZCLvM=-4D62EY6sjv7+BJhJc55MqQ@mail.gmail.com>
Subject: Re: Heads up: phylink changes for next merge window
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 13 Feb 2020 at 18:06, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Correct me if I'm wrong, but if the lack of fixed-link specifier for
> > CPU and DSA ports was not a problem before, but has suddenly started
> > to become a problem with that patch, then simply reverting to the old
> > "legacy" logic from dsa_port_link_register_of() should restore the
> > behavior for those device tree blobs that don't specify an explicit
> > fixed-link?
>
> DSA defines that the DSA driver should initialize CPU ports and DSA
> ports to their maximum speed. You only need fixed-link properties when
> you need to slow the port down, e.g. the SoC on the other end is
> slower. That does not happen very often, so most boards don't have
> fixed-link properties.
>
> It just happens that most of the boards i test with, have a Fast
> Ethernet SoC port, so do have fixed-link properties, and i missed the
> issue for a long time.
>
>            Andrew

Grepping for "ethernet = " in arch/arm/boot/dts, I see that the blobs
without fixed-link aren't even in the majority here. There are plenty
of blobs that specify fixed-link even if running at full interface
speed. I wasn't even aware that "no fixed-link specifier" is even a
thing when working with Ioana on that patch.

-Vladimir
