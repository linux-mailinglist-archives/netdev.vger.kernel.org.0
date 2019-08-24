Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BEB9C03C
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfHXUyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 16:54:25 -0400
Received: from mail.nic.cz ([217.31.204.67]:42382 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfHXUyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 16:54:24 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 23572140B0B;
        Sat, 24 Aug 2019 22:54:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566680063; bh=1bAyAEVMPFMOkhrRfhPmRz15eiJm3ANwsaeVebK/hl0=;
        h=Date:From:To;
        b=I9GTpl+EUvfFzCSkheoiwqrZcpYIbQx25oVQR2scBU/z+cc1WqJGEJtsT5JWxrbUo
         /msvxnePWcEXf9mZMBpxj8vzDkNyqbTsj4KWGivxsZKYkp/E0esGePcZdXNY1/Iu8s
         CMFbsEZ9GdK+Dvrj34cUH5lPGViXmHEm3bmUycmI=
Date:   Sat, 24 Aug 2019 22:54:22 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 3/9] net: dsa: mv88e6xxx: fix port hidden
 register macros
Message-ID: <20190824225422.06b2aefd@nic.cz>
In-Reply-To: <20190824153254.GB32555@t480s.localdomain>
References: <20190823212603.13456-1-marek.behun@nic.cz>
        <20190823212603.13456-4-marek.behun@nic.cz>
        <20190824153254.GB32555@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 15:32:54 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> You are already using these macros in the previous patch. I guess you meant
> to introduce this patch before. But since you are moving and renaming the
> same code without functional changes, you may squash them together.

Hm, you are right, I accidently created a commit which would not
build. :( I thought that I tried to build after each commit, but it
seems I forgot at least one.
