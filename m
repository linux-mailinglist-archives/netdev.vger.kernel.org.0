Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53893EC616
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 02:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhHOABO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 20:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhHOABN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 20:01:13 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570F3C061764;
        Sat, 14 Aug 2021 17:00:44 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gt38so3956055ejc.13;
        Sat, 14 Aug 2021 17:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=77a3PjdEZG9707N7NjaIRKjusWwDezSpJcFT6MS3JV0=;
        b=oRe8UGlKOw9XkQ3JkagdXvhyWD2+Tb0J39nJVcy+C8IOiiKIUlo0ahdnEJWH6LwnOl
         hZ0MZL9wBwp0EPH62mscvXiIAK8EBARijjlqKdlgHwPJrmavfkamfhsseKVP46VLg2eF
         QYKnQtwQN6/wehRGp4N+IE3El/VzuYfGHR3bkwoc1W76IIFN3uUGXsErDb/wmjbmP0BY
         cilrZwjG198miBRUtF2T8MfPAAP0BnYUK4agIk/FmDTYx0qIa8Agjki6iti6aSxnP9ek
         xtDVnIxVHm+hxgBVd44hn14uY5L2z5KSo4mfk/p5RjbWEhsunLiqQAF/+RExGlIkwQuQ
         oOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=77a3PjdEZG9707N7NjaIRKjusWwDezSpJcFT6MS3JV0=;
        b=L9S6JwEMdaTPs3b2ugTV+i+NauaQAy1tmgKrPBMN6MsEGUnMqvG69t0zYmIoGIoHj4
         J5E9rQacP6YQd+zK3SJBsZVRrCCriv+senFv2jXWHhSg6YSbx6wpv0ZmzHVpwoBg/0ow
         drZ4RHGLYb+ha+V87W1Adh9AK9uOaHKquxqVnbaguDw62VlUb0zV0G9N3btKZKxDr4Uw
         DGJkW/76stf7y792MsMvbsP1OrjX2o3aEjXQj6Hm7u2J3YJffcg3nAcjNw5Ci449F0mM
         LZJc4WLw6bNy5oQCgUK7Ee7P5F9UEzCfkx/MCVRQ8khHB707SdAZFSeqsVZFdsFBNVg6
         7EUg==
X-Gm-Message-State: AOAM533JcpnDcu5IJqV2lkZGCmixHEHeepBtj4a+RzRZ1i9mtkPm8IMK
        5guSPP0IMw1WUxhWK1G3zp0=
X-Google-Smtp-Source: ABdhPJwT/OQvVGz4iMDP/8QYaZW0pxS4aSW3eHn5rdHpQ4f0xwq3ZYwErF98hnJUEKSTEjoVSW8VKg==
X-Received: by 2002:a17:906:1615:: with SMTP id m21mr9399362ejd.279.1628985642874;
        Sat, 14 Aug 2021 17:00:42 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id a2sm2869300edm.72.2021.08.14.17.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 17:00:42 -0700 (PDT)
Date:   Sun, 15 Aug 2021 03:00:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <20210815000041.77cdk2bu7qrm5fem@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
 <20210814114721.ncxi6xwykdi4bfqy@skbuf>
 <20210814184040.GD3244288@euler>
 <20210814190854.z6b33nfjd4wmlow3@skbuf>
 <20210814234158.GE3244288@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814234158.GE3244288@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 04:41:58PM -0700, Colin Foster wrote:
> So DSA requires a fixed-link property.

How did you come to that conclusion? As mentioned twice already, DSA
registers a phylink for the CPU port, and phylink works with either a
phy-handle or a fixed-link.

Support for this has been added more than 2 years ago:
https://patchwork.ozlabs.org/project/netdev/patch/1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com/

You have a PHY... so use a phy-handle.

> And that makes sense... who in
> their right mind would connect switches on a board using an RJ45
> connection :) Then the only reason any of this is working is because I
> have eth0 set up as an RJ45 connection, and because of that I need the
> hack to enable the phy on the switch port 0...
> 
> Maybe that's a question:
> Is my devicetree incorrect for claiming the connection is SGMII when it
> should be RJ45?

Your device tree description is absolutely incorrect by all accounts.

First of all, "is SGMII" does not really preclude "is RJ45", because you
can have an external PHY connected to your MAC via SGMII, and that
external PHY would provide RJ45 access. That would be absolutely fine too.

That would be described as:

	port@0 {
		phy-mode = "sgmii";
		phy-handle = <&external_phy>;
	};

It would be absolutely fine as well to describe the RJ45 port via an
internal PHY if that's how things are hooked up in your eval board
(really don't know what PHY you have, sorry):

	port@0 {
		phy-mode = "internal";
		phy-handle = <&internal_phy>;
	};

But in the absence of a phy-handle and the presence of fixed-link, like
the way you are describing it, you are telling Linux that you have an
SGMII PHY-less system, where the SGMII lane goes directly towards the
outside world.

I think it is actually written somewhere in the documentation that
describing a connection to a PHY using a fixed-link is wrong and
strongly discouraged.

> Or is my setup incorrect for using RJ45 and there's no
> way to configure it that way, so the fact that it functions is an
> anomaly?

No, the setup is not incorrect, it is just fine and both DSA and phylink
support it as long as it is described properly, with the adequate
phy-handle on the CPU port.
