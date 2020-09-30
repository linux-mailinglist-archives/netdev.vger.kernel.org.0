Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8AD27DD97
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgI3BJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:09:25 -0400
Received: from mout.gmx.net ([212.227.17.21]:44827 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgI3BJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 21:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601428157;
        bh=VBS3c1Lv5N7Dzd5f3HQH9S5wLkkbX8wco2W75o01DFM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Z1lvwmCyhs+mXzuD+L9RFYThgvzkS/2j3UjDGb73f0fzTETj6w0+0wMaN0hX1ECxN
         Xi4dvuGJSbnm+3Tyd/agU4cHPHi6pUxGER8z6zjXv1WBnhrnpZRVDtZ+qH6nTPQAZT
         ejTDoRZeBQEihnZlHxPORB/E2Qflo89foblAq4HY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [173.228.6.223] ([173.228.6.223]) by web-mail.gmx.net
 (3c-app-mailcom-bs16.server.lan [172.19.170.184]) (via HTTP); Wed, 30 Sep
 2020 03:09:17 +0200
MIME-Version: 1.0
Message-ID: <trinity-21a6a831-2c03-4d45-a9b3-ff17f1080b12-1601428157141@3c-app-mailcom-bs16>
From:   Kevin Brace <kevinbrace@gmx.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/4] via-rhine: Resume fix and other maintenance
 work
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 30 Sep 2020 03:09:17 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200929.142400.1950429484895348245.davem@davemloft.net>
References: <20200929200943.3364-1-kevinbrace@gmx.com>
 <20200929.142400.1950429484895348245.davem@davemloft.net>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:/eOE0c9/8CkwM70HzQSRlIicRiX+tNtWYp+W8fUbeui0lDY9EgC44eYxHClphanTvB8m4
 zpkottgmZezQ7EH0dAJw7AyDi2RmH2N0HoHyyXa4WN0aqw7UvjJ7BGlysWm7krvtWnePeahjw51m
 Ny2tsP2TzN4tgBSizaw1lZ7V9ZnqbTKZ3b5jPzp/hxM2n+/00XdOcP/0O+THgZykzdafwp8364H/
 2ilmrXFJnypkAwHYnk9oPZzcKlAUlS/eEjs0SL2qiuQt1Eu7yjLliefxBJH+bmAHJ1/DXq2RXkiX
 dY=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VnMGaLQcmCY=:wey5g7SLDOGPeDY3wtYOEy
 2HybXSX1mwMXX1UN/ShKBNVJeZ/kbYD+W6U80ZhBypEVjOnKz5Z5AUOZgZzswFKUkw/2TXvZl
 jX5o2D4oaxTvkFs4O4MTxGSh1zXsPr0XLPM/pkdNLSUL9WommAvlMiR7f6kXnEnS4lgYZh4XU
 kBC8COoGZhVvGKfEDz5qpIKK7LfM/QMtv+dY4JtL09HytQwYUaMzHnbJKWnsjdSBAZiHWuJc3
 Z4nrJveknnoiMJkZ5Oc7LNxgjhgMF7YIttCrtp659ckU/7rnQSKlhWaI38FU7RpiItw4Gb+Aj
 8jBoLQf0d784aeBfV4dOWeLUEnrqS1LL2iNYnYw9bDF9Ic6HY/u/38ir4Temtf1XRfrdXIHZL
 1fqzSiXtP+3C+l89QDnUgw+PmDFu53/cX14v7wnJBH1/J0/IAthF0FXLGVyCKPAyB8e+gfHmg
 0F9jWj6LHlHOJFuhAWgHhlBj5AJq474ytIv9dqUME7vyTPbPiqWdWFi0xA/39QJVGK7DIAozA
 shn1/I5AzwRxfOn2pP0TtwaDmdj8fN+H01SsdAwYpJt8uluOHLZpqKBoSlyfMj/MaPdEbAnvj
 m4apRBRWO/k4hu7mOPh0xCu8rXnOTfaQ5TrCCPP4MfYS+OiNPq8qO6OIq1nE6oH1gRYcUPxkH
 GolkjWo2HW6WSopCCHhi5mmqfeqiWno3ntKXd9EsGXC7tTA0hgcfjEmuMfXjxpWQP8Cc=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you for the quick application of the fixes.

Regards,

Kevin Brace
Brace Computer Laboratory blog
https://bracecomputerlab.com


> Sent: Tuesday, September 29, 2020 at 2:24 PM
> From: "David Miller" <davem@davemloft.net>
> To: kevinbrace@gmx.com
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH net v2 0/4] via-rhine: Resume fix and other maintenance work
>
> From: Kevin Brace Date: Tue, 29 Sep 2020 13:09:39 -0700 > I use via-rhine based Ethernet regularly, and the Ethernet dying > after resume was really annoying me. I decided to take the > matter into my own hands, and came up with a fix for the Ethernet > disappearing after resume. I will also want to take over the code > maintenance work for via-rhine. The patches apply to the latest > code, but they should be backported to older kernels as well. Series applied, thank you.
