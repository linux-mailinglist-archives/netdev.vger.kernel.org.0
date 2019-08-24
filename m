Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C129BF09
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 19:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfHXRlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 13:41:49 -0400
Received: from mail.nic.cz ([217.31.204.67]:41506 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbfHXRls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 13:41:48 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 62712140BBA;
        Sat, 24 Aug 2019 19:41:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566668506; bh=MUQv2WsU8LdY33TfL+iwPzcThHbqOpPuiAKOqmMXclc=;
        h=Date:From:To;
        b=IpPy+H4R3ppC5JdPhZNvWJC6r28w+rNlFlBiJ0VcIw9/W71gVf0ZSAQxO0VGw3XP7
         BrT5/PofrTMcP+dHhWeU5TiT8OUC8+K8XhTVk5qzttcQplLbPc6PdKy/Fyev+nnQeI
         Vxmvo9r6rDabemI3VdngIAOe5a6QtqGDlXg4XFlA=
Date:   Sat, 24 Aug 2019 19:41:45 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Message-ID: <20190824194145.70715ab1@nic.cz>
In-Reply-To: <20190824154302.GB8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <20190824024251.4542-2-marek.behun@nic.cz>
        <20190824154302.GB8251@lunn.ch>
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

On Sat, 24 Aug 2019 17:43:02 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> But i don't know if it is worth the effort. I've never seen a D in DSA
> setup with multiple CPUs ports. I've only ever seen an single switch
> with multiple CPU ports.

Yes, that exactly. I was thinking about the most optimal algorithm, but
such would need to consider speeds between links too. For example the
DSA port between two switches can be linked at 1 GB, but cpu can be
connected to switch with 2.5G. What assignment is best in that case?

I think that we should try to solve such issue when it arises, if ever.
Such cases are more reason to add the ability to change cpu ports for
given ports.

Marek
