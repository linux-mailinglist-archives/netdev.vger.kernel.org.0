Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4CED6B1
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 01:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfKDAqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 19:46:02 -0500
Received: from mail-yb1-f170.google.com ([209.85.219.170]:46014 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDAqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 19:46:01 -0500
Received: by mail-yb1-f170.google.com with SMTP id x14so1954015ybq.12;
        Sun, 03 Nov 2019 16:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=JUF6cCkeyUxrnFSTs3kKJzANX8OPwaEJlVexVZRYuvw=;
        b=kkqMZ5+oXZUxttD6WuJtQ87JBNIpcxdctMwDMtaQZLAWLdVnEj0bqwPeg3pGl0KRwy
         SWGHFXUsMgbisoWo9KmU6fM/Ew6s3YNWd6IGN0vvE0GUN+bP4+lxEDDvFK5FYQ3VvPC1
         0Ke7sGV5msnW9WMmoh7pN4uVqe4lyNVox+shnyJ4Bli7iR9kSZBzf9cJap4JZF3HVASk
         Ah7dY3dfj4rWPa6Frho/Rmw4Ell17LHOnML6/N/1ZpzqQqK2NAuwx5ldrEwgnuQHCf76
         s7fgDfbdqBT1qlYdWTX/p8RR599rVjr6UaqK/dnAXz8e2ze8GyQNbOYQ+GBL8eGmlnUK
         GnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=JUF6cCkeyUxrnFSTs3kKJzANX8OPwaEJlVexVZRYuvw=;
        b=hHwXcJKXfXpNJeEOJNMcjh1LVAtslLA288HYkoH2B24AiMLhxOeDpff6eOb5XAiuX+
         /K7FBDHotC3ZsuIONOahsuJndOR2cFoAKqc5NgSbUkxvYYQTWuxeEL07zONEWc3uVzuX
         qn3Xzam8zPl/6yWYO5bSW9+ITIxUvPdI8VCDsmpX/Gxi1pPLWJX5SS5tF2FgGj7K1zQT
         kPNgq7jROnfxEZnOx1nl/67/6qOEoFjlkRI5UNWIv2a10P2FibsuvgzbcUP7damQEbJU
         bVSeVp9qyNXGWUfFE982/Y4f14VkeEzcbNB8KNdNiUEJnSHzdrIhvvUBUdOgThOoWMUV
         Fqxg==
X-Gm-Message-State: APjAAAUb/8fI2m7Jdbng+hf6cag5cMXEwhGNmkHokQC95Q+aSwnuPkwm
        p2C4b2Ze64Frr71pLcawY718vE/gxuocyWsT+OoeAA==
X-Google-Smtp-Source: APXvYqxV81QeGtjshTf7RlqlI8Bll05pDUjXQ34sdoWj1hIikHDMZ/A/0YSkCOjWGBOySvnsr6Wg/lP6ZzX5yhS/hXQ=
X-Received: by 2002:a25:be84:: with SMTP id i4mr21317590ybk.213.1572828360590;
 Sun, 03 Nov 2019 16:46:00 -0800 (PST)
MIME-Version: 1.0
References: <20191103103433.26826-1-tbogendoerfer@suse.de> <20191104003452.GA2585@lst.de>
In-Reply-To: <20191104003452.GA2585@lst.de>
From:   Carlo Pisani <carlojpisani@gmail.com>
Date:   Mon, 4 Nov 2019 01:45:45 +0100
Message-ID: <CA+QBN9A=s-DRA6Zbi-eJ7WXnP6sOZtnX5AeeROL=4ax52sWb3A@mail.gmail.com>
Subject: (metabare) net: sgi: ioc3-eth
To:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi
I am currently writing code to support a PowerPC's bootloader
(PPC405GP), hence I wonder if I can reuse part of the code to also
write a bootloader for IP30

kind of u-boot for Octane

but I wonder how difficult it will go about the network card. I don't
need high performance, and if there is a bit of doc not in form of ...
kernel code. I mean some document, like a datasheet.

The netcard needs to be only used for TFTPBOOT, hence for udp/ip.
