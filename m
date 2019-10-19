Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3D6DDA9E
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfJSTRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:17:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35545 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:16:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id l10so9145843wrb.2
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 12:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rn2oKrSLV1r55iiUjKmZiID2iFA2W7pO6EfrN7UQe/I=;
        b=Lqrac2CveGoKuZwgTRVwtEV1npHhKT7Gr7CWixpENDFqNVTDvmAd0gi5YlpAhUyFGK
         1tX3ysDxWBSVwvblML7Gen/yyZG0V1CKtik7eX+UTh5J4x9B6yPF6/vJzg3K615H8MFP
         GAz6E4Tfqv1DoIY5M/UxUkp6pe/vXV2E3dksx4hL9VZFvU1TBtAZoU3xNaukPs4m5PYL
         txI2NZAEWYOYy6JVCG42mAXC3iyxcAb3/tJ7SMMdDK8tg+lff8CGUKseOOdH6WTzD8bd
         AkOrqCq+UCDw9nqnFm9hbIP3jkBbdq6u5IMHphHoS9SNpIqnHY8lePCvk1UUIUOHQTQ7
         N6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rn2oKrSLV1r55iiUjKmZiID2iFA2W7pO6EfrN7UQe/I=;
        b=PICOsJz9e9fYY286QPnznqdipc2BHTIYtprWyET+HqY+92O1GYYvO/lgZtvnJmMwfF
         MHHdN/veF7shZgPO+mWiFZmcd+7U485PW1i7vxx5+0EgK4AXBd9Mn+X4QVbX1R/an8uy
         ml1Zvm4z1oGxm90AdpgA9xdV4OR61mGnzICQVpY7Nv2dt7CgoyAGsZXOYwslT05iGU2q
         BVKucVbrfSKbCVjevWIvFY1GHPBZ96xxpWmB8SuoayaeMiJSx2uM6n/F75SJhl0lLeaM
         9lEDtbtscZF8Jo3Sbv1l+xR3NxbP5hfSsA4fDm8PZTRUIzjYXd6stuoK0hxvnQa6lXJc
         xuxg==
X-Gm-Message-State: APjAAAUnmwiSCzocfP/lYMdsTWE0/DUqfsrcAYjcdfz3Sfvk1288jnD/
        mcslDoNHDq2uHsllYCy/G9TSJg==
X-Google-Smtp-Source: APXvYqzH1MKSlUDFCetH2UzB9G4Mt/Kta+pM+GCXUXTE8Xi0Ufs/dKPP9/sPsgm/XwX67/9QDcfAmA==
X-Received: by 2002:adf:8068:: with SMTP id 95mr13778838wrk.249.1571512617628;
        Sat, 19 Oct 2019 12:16:57 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id u83sm16257538wme.0.2019.10.19.12.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 12:16:57 -0700 (PDT)
Date:   Sat, 19 Oct 2019 21:16:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191019191656.GL2185@nanopsycho>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019185201.24980-3-andrew@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 19, 2019 at 08:52:01PM CEST, andrew@lunn.ch wrote:
>Some of the marvell switches have bits controlling the hash algorithm
>the ATU uses for MAC addresses. In some industrial settings, where all
>the devices are from the same manufacture, and hence use the same OUI,
>the default hashing algorithm is not optimal. Allow the other
>algorithms to be selected via devlink.
>
>Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>---
> .../networking/devlink-params-mv88e6xxx.txt   |   7 +
> MAINTAINERS                                   |   1 +
> drivers/net/dsa/mv88e6xxx/chip.c              | 132 +++++++++++++++++-
> drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
> drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
> drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
> 6 files changed, 178 insertions(+), 1 deletion(-)
> create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt
>
>diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink-params-mv88e6xxx.txt
>new file mode 100644
>index 000000000000..b6e61108d781
>--- /dev/null
>+++ b/Documentation/networking/devlink-params-mv88e6xxx.txt
>@@ -0,0 +1,7 @@
>+address_translation_unit_hash	[DEVICE, DRIVER-SPECIFIC]

This is quite verbose. Can't you name this just "atu_hash" and be
aligned with the function names and MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH
and others?

Otherwise, the patch looks fine to me.

>+			Select one of four possible hashing algorithms for
>+			MAC addresses in the Address Translation Unit.
>+			A value of 3 seems to work better than the default of
>+			1 when many MAC addresses have the same OUI.
>+			Configuration mode: runtime
>+			Type: u8. 0-3 valid.

[...]
