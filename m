Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A61FCFBD
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 21:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKNUgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 15:36:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39887 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfKNUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 15:36:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id t26so7681178wmi.4;
        Thu, 14 Nov 2019 12:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/T0Rg4n36uJouyisIYq+OO8Wawxqm7AHTLdrmHhfwqQ=;
        b=QjAuB1h0TJNq+R/eBV5ZaGcnL2pZ5kGnbAeZWcn1gpJybTwSKK/Zzadbrd0n9U/yUy
         A59YXwKP3qzMaUKNBWpi4YkXeZzrkEmeSBTv0YRXNIIyofOzs0YPu2HdFCTcRBP8uCzQ
         sPp6eNcJMJz895oTZKAoQYjao7O3RuvJ0UHg07Zi2snQageqQjTWd1cG23TIjpbWyaVS
         PaYnTDeikzJTl8aLycPmtk8Kgqe/zcnWWngaUtIeR0YB41jH5PcQLna4pdrlhmKv0q6g
         lltmj/tddiZlXNUG5Clig0ZA3Qc5KIhFDYVE6lSgR5srqWM7rCaiOQDkwcioJdP4aKeX
         GXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/T0Rg4n36uJouyisIYq+OO8Wawxqm7AHTLdrmHhfwqQ=;
        b=ETt3ITdwADVFc0GbXIYAABhyKj7zFgqhGNJw0i7X3AjXBAKqzluGvD6DkhiW6X/y4s
         PNfDHtv1BuhzK8zQIoRrCnrcylCp0ly+n/mWx7aPmfl24jZibP7tOYM54Zh7/Ke7KWL+
         ENW1hUMbgvQ2tsLwzA4mY3Pk+5ufFKifXQ0wLhsdvK908yJf9KW1RdoHleMUUddHLlAo
         G4pcPJB1RAe9dFvcqdnjYe+O03MfnVp3/VIb6esmRa877isximHseb4RXpmSmTdAomyX
         nahK2t++PZKgJ1HTSntaVqRZrpAngYn1ao7gzRELxK/Jxuf7dCEz28PQNgLoiNcct+VB
         CY4g==
X-Gm-Message-State: APjAAAXSkk4S7sD7VaXNsHWy6+a2MaKgBDOqyVrtvf/tyyOQnyY6Szox
        X3n6EQAFbHGVZl7FrSddKgY=
X-Google-Smtp-Source: APXvYqxco0B6kyD8XmcSzehMoYkUCYFnw99z4LvXd73jRYCdNM2xfHk1C1VpFemgIurnM6vbrKHahg==
X-Received: by 2002:a1c:62c5:: with SMTP id w188mr9861447wmb.77.1573763764596;
        Thu, 14 Nov 2019 12:36:04 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g184sm7914263wma.8.2019.11.14.12.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 12:36:03 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH V5 net-next 7/7] ARM: dts: bcm2711-rpi-4: Enable GENET support
Date:   Thu, 14 Nov 2019 12:35:59 -0800
Message-Id: <20191114203559.1250-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1573501766-21154-8-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net> <1573501766-21154-8-git-send-email-wahrenst@gmx.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 20:49:26 +0100, Stefan Wahren <wahrenst@gmx.net> wrote:
> This enables the Gigabit Ethernet support on the Raspberry Pi 4.
> The defined PHY mode is equivalent to the default register settings
> in the downstream tree.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Applied to devicetree/next, thanks!
--
Florian
