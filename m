Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8EC33B4ED
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhCONv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhCONve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:51:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C05EC06174A;
        Mon, 15 Mar 2021 06:51:34 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so16545537wmj.2;
        Mon, 15 Mar 2021 06:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hHSONVhizqE4bkH90HJXJlS0YHRaGhrU8+brpoTidfk=;
        b=MZyW+mTOOO9YwxOqa2ROb/bQLQDTamr5z8KNQ54R7oc09XpWpEx7dmqcphgsf6cTDS
         4yDAuiZDkdFLRBUbh9K0bRSn7O91Yge/dS0Tid8sHmWpejYhmr38Vg4KxPRAdgP9DTXG
         B/zcnS7eKjuX/TRjocbqe1QJ/NPOOfNGAcVkFgIsXIuMUM+bDGVCgpDyYrVayWPuLRXG
         N5nbP2s0yhgpp6DPgYOJ7rJNtq0/qi4RM8+dCJrj211G9JdtdWgciZQJoEvPQzRcVG9P
         B0IOQV44OPvk48baCwNwAwaXa+/y4kwBx8GXRSJUAzHDdKzpOvsNoYMMMbjSMS8QoKv5
         zCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hHSONVhizqE4bkH90HJXJlS0YHRaGhrU8+brpoTidfk=;
        b=FprAPsEQ7pX1iCe0ubvOecR0yiPAcOsSdcmSQHaVVtRABH8sB8KiejYpgC/pPRzJuF
         IyFQURYUQpQ+o6nPM+my/74w9SvXHdtYWC2fkCBJfSSZ3KCOlWWn2NxvQ85bBUeFQuTt
         8G7XPFtpgWU2tP9CahT/JV5D7W3DCH5W17RU8W9M5ts86bRXl8Ul/SbHh62CV6GErnqR
         Ekfru4uvsZa/Fzjm3S6U4OmeGbiN6zRW84IYLoku78VQa2fJ93GWKIZJnKqj7pWgP6mA
         qnCza3bZBTT/moZgqjNyl30bOQan+O0GlHaKxKVLiJH9QLJkQ/A7e9nuyXfW+k+eiTE+
         wpRg==
X-Gm-Message-State: AOAM533bXNZEEVruEoXaEu6GsaqQxamHyVH53KxO15aBYP+Y0yY5RoD3
        4K/IJO53XfB0ekUBAtTNxf4=
X-Google-Smtp-Source: ABdhPJzuxeMiYbHeNsDKhCqgk0QH2VSQXNWgugKDAdouqJ+BGvvRLUWh7/NBU90nLyPQKcEWlI3uTA==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr26549517wmq.133.1615816293211;
        Mon, 15 Mar 2021 06:51:33 -0700 (PDT)
Received: from macbook-pro-alvaro.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id i26sm13019586wmb.18.2021.03.15.06.51.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Mar 2021 06:51:32 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bcm6368-mdio-mux bindings
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <YEaO7GT7NgL30LXN@lunn.ch>
Date:   Mon, 15 Mar 2021 14:51:29 +0100
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BBE48879-1AC0-4C3A-8A0C-B0836E6D0B38@gmail.com>
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-2-noltari@gmail.com> <YEaO7GT7NgL30LXN@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> El 8 mar 2021, a las 21:54, Andrew Lunn <andrew@lunn.ch> escribi=C3=B3:
>=20
> On Mon, Mar 08, 2021 at 07:41:01PM +0100, =C3=81lvaro Fern=C3=A1ndez =
Rojas wrote:
>> +  clocks:
>> +    maxItems: 1
>=20
> Hi =C3=81lvaro
>=20
> The driver does not make use of this clocks property. Is it really
> needed?

Nice catch, this was copy & pasted from other driver.
I will remove it on v2.

>=20
> 	Andrew

Best regards,
=C3=81lvaro.=
