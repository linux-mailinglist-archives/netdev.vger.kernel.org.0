Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A576BC92
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfGQMsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 08:48:36 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42280 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQMsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 08:48:35 -0400
Received: by mail-ot1-f66.google.com with SMTP id l15so24847769otn.9;
        Wed, 17 Jul 2019 05:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3cjnf5mDvntbDLfr4kFNWjMA0+fz/aHDOQecU3QEnwU=;
        b=a9TV4HIAa7fZN8NvhxNSke/CKtEoj6SCyg7ZMnVBNf7ZgKDIXDjj1MoYCOk+8AGCN6
         T7iJou5FKyCg4VqcNNnHKYoOqWyZx0UIBP8OGoAFMJ6g7aOyXIwtTJ2cYRvFsvBb4tDd
         L31lOSLSDSDI9YbD/TqoBZihPpm/NcE49iOxUPGHgqIcRXR46vuJwDrBQVk/LwL3MD7Z
         IX6Yzwqw7ZREJTwUjVw5J9dBTG6HnY3573QW5icZCBX6wNa4b/tP6yos5/tTLmobvM8j
         gPOGpSS/ApIPKwvyY/eAocAzRkVCiy2foYKrlVjFNNdD/58anWRcQ0+waBqnJlw6n5xN
         J2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3cjnf5mDvntbDLfr4kFNWjMA0+fz/aHDOQecU3QEnwU=;
        b=hC9mJ0mLd6VDjzd0nij9LsiokuScHlY+kb24ZcBP/Ep4pKLvGyVhRYAEiOjX57VBFm
         AkJZjvdFumNnAaqwHToHcbfV7nRTZi4QRm+Vp4lQxxn6zDI5AHMnKy+03IdNxtS/Y+s+
         eSZVFlnvY7yv+AU16palZZd4QCZ6rb7TOuALS8By4mo1ml5prDxg0Kf1g4KUvYNUaXGy
         lyc2ASPkv4lVOWgrenHiJGLLmoLN4Ufagy+zTd28YRec0U9jBlGFp55OPXSw4fOYYvHa
         EtJpSaqtHE8CDU+B4Mhtv4LxY3/+lT1NFQ4BP5e4PeItDDe3eVbZpv3v34R7siPVUXcY
         Mcag==
X-Gm-Message-State: APjAAAXfqYv/GQWqX8IHLUxznZSGKuptQqN0a2xJEmRe+iHeFqs/bX4g
        q3C71tyPBLX7K6P/1NvYkwviP4lVxsWVpHyQbJYvpw==
X-Google-Smtp-Source: APXvYqy7iwcYpkGRx81TZ0XfHsJWqYWeTxefJJs90LGoNvKOAyqCCVpTUKFomvIz6ScZ1VV1Al/OWmp+7A7/Bn4bRvw=
X-Received: by 2002:a05:6830:c9:: with SMTP id x9mr21792319oto.332.1563367714664;
 Wed, 17 Jul 2019 05:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190715210512.15823-1-TheSven73@gmail.com> <VI1PR0402MB36009E99D7361583702B84DDFFCE0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAGngYiUb5==QSM1-oa4bSeqhGyoaTw_dWjygLo=0X60eX=wQhQ@mail.gmail.com> <VI1PR0402MB36009A9893832F89BB932E09FFC90@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB36009A9893832F89BB932E09FFC90@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 17 Jul 2019 08:48:23 -0400
Message-ID: <CAGngYiU7B4uuqSAawNE6RFsjGPzbj5gzK9S299H+Qy+CWFjaAg@mail.gmail.com>
Subject: Re: [EXT] [PATCH v1] net: fec: optionally reset PHY via a reset-controller
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 9:32 PM Andy Duan <fugang.duan@nxp.com> wrote:
>
> Yes, so the old legacy code is kept there. But it is better to clean up all if
> there have enough boards to verify them.

Would it make sense to print a warning message to the log whenever
someone tries to use the legacy phy reset on the fec?
