Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622559C199
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 06:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfHYEIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 00:08:12 -0400
Received: from mail.nic.cz ([217.31.204.67]:44222 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfHYEIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 00:08:12 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id A71EF140BB6;
        Sun, 25 Aug 2019 06:08:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566706090; bh=XBa260bBTRZlWt9iB7/5lcBzzV7JHJ/Cj/ZHPotj0As=;
        h=Date:From:To;
        b=jaji2u6D7CG+QlZEqbd4An2a/kDBry9VSvmn89MlGK4rjIuYy3NNQB0zNpMF0lw4X
         fzGZN9LfvP2imHLO17DhfDEB3LC+HPPOOXueBTnh7Wyoj3wjg1suaf+L5s/kBZJxEX
         RDGIiYirfEj31dZMoOjIccNDpD6xkePyYp1C4dp4=
Date:   Sun, 25 Aug 2019 06:08:10 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Chris Healy <cphealy@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190825060810.181f65c9@nic.cz>
In-Reply-To: <20190824230121.35a3d59b@nic.cz>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
        <20190824230121.35a3d59b@nic.cz>
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

On Sat, 24 Aug 2019 23:01:21 +0200
Marek Behun <marek.behun@nic.cz> wrote:

> the documentation would became weird to users.
... would become weird ...
> 
> We are *already* using the iflink property to report which CPU device
> is used as CPU destination port for a given switch slave interface. So
> why to use that for changing this, also?
... why NOT to use that for chaning this also?
> 
> If you think that iflink should not be used for this, and other agree,
... and others agree with you,
