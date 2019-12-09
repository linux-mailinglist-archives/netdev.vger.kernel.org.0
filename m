Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB27D1173D5
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLISO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:14:56 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37955 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:14:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so17294828wrh.5;
        Mon, 09 Dec 2019 10:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FnJ75Uhb5jjpHnizeaX4CsLk/OHrkbiFhcnav79oqNs=;
        b=ZepRliXoJjh18TG0DzXYrDGdNUZ4IzAb77TKuwgOsSvPJaDz1TcDeZjX6wInGkCRVG
         ZkCL/tISTqSfi8mtaj94QzFCEVEJwUuYgPaEEugEb1Y2PZFP+9AJbuGLaqpp4H3EKwRb
         vVFHbyPM3bCNgWYTfZYzVqXJpWb6wvmgwzDLarUmlDXVP2oQZ4mTrBmx86Tsg9VZK1kg
         MKk7guwLpdHdO4FBDKB1jbt6NG8+DWARLOhEzy6OgZpMhsE93uez4hcOqiHgJ8s+oY9B
         0bCj4MBLeAgFynAfFteGsmUd5c0qK+nLz9Pm6Ia9P1/IeAcqxfsCJ+atrVhbYwZ+LWmP
         Ge5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FnJ75Uhb5jjpHnizeaX4CsLk/OHrkbiFhcnav79oqNs=;
        b=iAans2X7FoNfRfjwOTkeLn08ALr9PuTjYdPtvTwv8OSGvXXY/tpybeubcRYkXEkqp6
         lH2zogrEQ84uDbQYyHzkcoh9pHukVLIqDNUedrbE4UStW+2h7Ohk7nGfGn5CIrnsb3zF
         z1I2sIFmHowH/udPFwNqZNjUjJ0xpHkh+emFZxpvmMjDdqkbr8/kE6pMwmj2cNBW68zU
         jdpPXfeQtVxLTERU4iDHq1f8S3Pv6rN6vYWqX+8KCcDzJ4YCoV+BUZAzJQHeLrWXhle4
         vh4lzVbVQvvNjtY2lgnmWIHKbXbBx974FvuOJk+qEwE4dj1KSQO3wiK+b0t45fSSB96G
         vznA==
X-Gm-Message-State: APjAAAVWvLscO5iQU2TL75TaPivyIlrreTZVQk7WE6bekriIkHAfW4cl
        jsTZ8y9v3rgAG4eab6BY8og=
X-Google-Smtp-Source: APXvYqxanq81MjQQ/vCG8zEAT+l265qBKg7/XDRbvi4ifBvuFeVo9EKUzboncgcnArLlYX31z3RcAw==
X-Received: by 2002:adf:ffc7:: with SMTP id x7mr3541896wrs.159.1575915294194;
        Mon, 09 Dec 2019 10:14:54 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q3sm327849wrn.33.2019.12.09.10.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:14:53 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
Cc:     grygorii.strashko@ti.com, simon.horman@netronome.com,
        robh+dt@kernel.org, rafal@milecki.pl, davem@davemloft.net,
        andrew@lunn.ch, mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Cygnus: Fix MDIO node address/size cells
Date:   Mon,  9 Dec 2019 10:14:49 -0800
Message-Id: <20191209181449.6307-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191206181909.10962-1-f.fainelli@gmail.com>
References: <20191206181909.10962-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Dec 2019 10:19:09 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> The MDIO node on Cygnus had an reversed #address-cells and
>  #size-cells properties, correct those.
> 
> Fixes: 40c26d3af60a ("ARM: dts: Cygnus: Add the ethernet switch and ethernet PHY")
> Reported-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Applied to devicetree/fixes, thanks!
--
Florian
