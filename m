Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C9A27D9C4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgI2VKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:10:14 -0400
Received: from mout.gmx.net ([212.227.17.20]:57833 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgI2VKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 17:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601413805;
        bh=OUbjIbJ2G3kHXGfbaxd6Zqb8qX2+r1Uo6Mh4UxQb/B0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Aij6vlxM5q6z9GoxY+XiiwPzuwqw3wfFuo9UDL5AFkTcZezpioG3PgrgYUZe0KpBt
         GhZlHG3kpE82sF+Bco9rHmC5AJb391+mVCJpLWtAJoZE+/xrL40wZgkxWMcsoyTECG
         g6tiA4p1pacyk0QglF612M6NX93SWi6ayLKEoIvk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [173.228.6.223] ([173.228.6.223]) by web-mail.gmx.net
 (3c-app-mailcom-bs07.server.lan [172.19.170.175]) (via HTTP); Tue, 29 Sep
 2020 23:10:04 +0200
MIME-Version: 1.0
Message-ID: <trinity-c9fa5381-07f5-4aad-94e9-dcff576dae01-1601413804865@3c-app-mailcom-bs07>
From:   Kevin Brace <kevinbrace@gmx.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kevinbrace@bracecomputerlab.com
Subject: Re: [PATCH net 4/4] via-rhine: Version bumped to 1.5.2
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 29 Sep 2020 23:10:04 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200928.185020.239065830030111620.davem@davemloft.net>
References: <20200928220041.6654-1-kevinbrace@gmx.com>
 <20200928220041.6654-5-kevinbrace@gmx.com>
 <20200928.185020.239065830030111620.davem@davemloft.net>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:V0ORszoWFxOgxgMjrQiuxqgRKsMhlOVqZOIr4nLDCLU35Fb/5Mb6qSwIe+1ca+VijYI4l
 PS9+WupTb49FkJaKqz9ds8tO2jYT6R1zk4NjelFfPZxc+u7jP68Uc1C+uavfkrGaVhF6eoO9m0rH
 hr/LaO7ae02jYWHsAMft5BKNTGXfzjuX8DNZ0O565TWI1VMkTsgjHnnqjQGn3kOuaDxvO7JVxwsq
 V8l9kCbfYINC91i/ne6ieo2Ngcx13P84NT1Uetj1O8V6aoqM2+eWr0V4Wo6X0QHfw09IRq38Pw64
 Us=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SVK7zdWVFjs=:a/EFz46XYnPMtzlcxwtXOY
 5U1hdAuVT06eSzc1aP40AluFkkYB9RgfDuBmbB0QBRS4SvrTXhDEr9m+o7POKwLDrBMy8v3z+
 8uGbrw825Lbj6UG3iBlH4MCJo3fhfDzSEVKoPQtakm+uQseSmTPayaUcYV1pLZzfMOoN6zs+z
 09uwbrXWoenWohZo3aK4+yA8pQ4jjpPjpbZ6xYtIpZ9NKHbp2QkkEtp0CUQFis+dvk3X59L7g
 1HLhrOPtZoJARNUW6dnjfap/4IMgBvJHMqArmjLhCMTan4jfXSsFcyFcV5LAVZ4hoP8RaPQCu
 exfxlovgwkRfD7UI88g+ODmuWXpaEHrrIUBfcuBrhL+vVUmpSgDEeUNE/TdoKqrKQFHzp5OGy
 zUdA17PvE2qUCVgjwRoiw4gpraahXzYqakrHaaM09Bz3G6vD91b8Wi1sIgnQyXnQm7zwL3Tk0
 iT08OE8QvOcM76vjJK0c4GlVOHxZEKf0kA9yLXg1o0AyN9sN7bht+hhUOjF+6IGxY2nabGLv7
 1QjRVqKWUPdkt2AU61AzVlLpEvucCklB2/nUPcXqTddm9CjJ8K1JVZVQ5g/yyRrKQvMxfb34B
 0eFRcrydvw+6iDUJ7Po2h5Ctdo179ldHSc/1hCjfrPKqLfZJ9RocIkNlXNz17+6Nwy7E/7fts
 BizGRsbfh28GtTE3gww3zQNm24X8txoLkH9UDlXLc2ZVCPaCFsgPTubxQiPGUbQTPkr4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

I sent the v2 patches to netdev mailing list.
I hope they meet your standards.

Regards,

Kevin Brace
Brace Computer Laboratory blog
https://bracecomputerlab.com

> Sent: Monday, September 28, 2020 at 6:50 PM
> From: "David Miller" <davem@davemloft.net>
> To: kevinbrace@gmx.com
> Cc: netdev@vger.kernel.org, kevinbrace@bracecomputerlab.com
> Subject: Re: [PATCH net 4/4] via-rhine: Version bumped to 1.5.2
>
> From: Kevin Brace Date: Mon, 28 Sep 2020 15:00:41 -0700 > @@ -32,8 +32,8 @@ > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt > > #define DRV_NAME	"via-rhine" > -#define DRV_VERSION	"1.5.1" > -#define DRV_RELDATE	"2010-10-09" > +#define DRV_VERSION	"1.5.2" > +#define DRV_RELDATE	"2020-09-18" Driver versions like this are deprecated and we are removing them from every driver. Please remove, rather than update, such values. Thank you.
