Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6308812044
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfEBQcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:32:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41451 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfEBQcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:32:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id c12so4244754wrt.8;
        Thu, 02 May 2019 09:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OR6QWT2JELhOB9le865j5O2IBOFUN5khtXIl2Jxx/VA=;
        b=odrOjW7MtyRFbNv7MrvgUa9bUlS54p9MsZ2AqhKyhNISg5LFHn3S0dlOqfDE8RtKPk
         XNaiGt3hPTXQczhcgjinMfewvVRHQBjj2E3YBhyf5Opn96LZokTjLidh6LKkGXg+GyyV
         WRK6sscrqep80zwztIkHJkyEWsj3DWG9hFo2gi7XJ32tYg4ZstYwLePP8Rv4hSrshSO1
         Bv5KtfMXi+WT9TO1nyFAN+4Soakbmd9uM8exzw53qNZ+EQBsqcYKocU+gr1ij91we0Dn
         D8HLO4pbP0pSUOX5J66EHJx0Wy/8vvXntqlgDSlhezYIiCHKa9Y1sqvN23P9IUH70SwG
         RVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OR6QWT2JELhOB9le865j5O2IBOFUN5khtXIl2Jxx/VA=;
        b=kfpnz2ANeFqTVyc8REmanuUKdwivjK33hQLrMG08e1d5xnM64tmNrQoib5fFS+tOh+
         r/Sh0GtjUSJStgkIFE9De+VrIZjqBIOyBBTBFFyw84WmmVxY2bZYoZ92YdfIYYZYfVwg
         LX2DLNT21S5Pn8/f3Af6iw/ZhDaYFKmx6HZ0upUuEquFKkAwkwbhvO9IbbDXZuDhKPfC
         B9Uugp/tAA3DJi+r842tD0YIhRbpf8At5WGklYPP98Bu3rC8+9uMmdVLE6VEdXe4bhcu
         0yeNmYgMCJhX3Jty2a9AiNUsN4tdDsCUSCPIuRB/jVB4EL/8SJQe8w9i3jK4/gFYFYTc
         TI9g==
X-Gm-Message-State: APjAAAWOAaQFPALVMApbbYuKKIin6jYWoan3MecsOAZb09DUokTKh41M
        tFVAmFOMuhxNmDnnZoY36kINMUsNFpyPNgrX2w1tya8zMFc=
X-Google-Smtp-Source: APXvYqy+F0zZ6hos3HtuEvs+JdqPQAu4BsnKkO5aYKCk3zI0E0q4Bepm/4j2kA5tFrfUzF9jZafa1ckYMuYBoH7LhFw=
X-Received: by 2002:adf:dccd:: with SMTP id x13mr3394597wrm.33.1556814721560;
 Thu, 02 May 2019 09:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190429001706.7449-1-olteanv@gmail.com> <20190430.234425.732219702361005278.davem@davemloft.net>
In-Reply-To: <20190430.234425.732219702361005278.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 2 May 2019 19:31:50 +0300
Message-ID: <CA+h21hrmXaAAepTrY-HfbrmZPVRf3Qg1-fA8EW4prwSkrGYogQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/12] NXP SJA1105 DSA driver
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, vivien.didelot@gmail.com,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 May 2019 at 06:44, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Mon, 29 Apr 2019 03:16:54 +0300
>
> > This patchset adds a DSA driver for the SPI-controlled NXP SJA1105
> > switch.
>
> This patch series adds many whitespace errors, which are all reported
> by GIT when I try to apply your changes:
>
> Applying: lib: Add support for generic packing operations
> .git/rebase-apply/patch:176: new blank line at EOF.
> +
> .git/rebase-apply/patch:480: new blank line at EOF.
> +
> warning: 2 lines add whitespace errors.
> Applying: net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch
> .git/rebase-apply/patch:102: new blank line at EOF.
> +
> .git/rebase-apply/patch:117: new blank line at EOF.
> +
> .git/rebase-apply/patch:262: new blank line at EOF.
> +
> .git/rebase-apply/patch:867: new blank line at EOF.
> +
> .git/rebase-apply/patch:2905: new blank line at EOF.
> +
> warning: squelched 2 whitespace errors
> warning: 7 lines add whitespace errors.
> Applying: net: dsa: sja1105: Add support for FDB and MDB management
> .git/rebase-apply/patch:81: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: net: dsa: sja1105: Error out if RGMII delays are requested in DT
> Applying: ether: Add dedicated Ethertype for pseudo-802.1Q DSA tagging
> Applying: net: dsa: sja1105: Add support for VLAN operations
> .git/rebase-apply/patch:359: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: net: dsa: sja1105: Add support for ethtool port counters
> .git/rebase-apply/patch:474: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: net: dsa: sja1105: Add support for configuring address aging time
> Applying: net: dsa: sja1105: Prevent PHY jabbering during switch reset
> Applying: net: dsa: sja1105: Reject unsupported link modes for AN
> Applying: Documentation: net: dsa: Add details about NXP SJA1105 driver
> .git/rebase-apply/patch:200: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: dt-bindings: net: dsa: Add documentation for NXP SJA1105 driver
> .git/rebase-apply/patch:178: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.

Wow I am sorry, Gmail apparently moved your reply to spam and I only
got it when I posted my message just now.
Do you know what causes these whitespace errors, so I can avoid them
next time? I think I'm generating my patches rather normally, with
$(git format-patch -12 --subject-prefix="PATCH v4 net-next"
--cover-letter).

Thanks,
-Vladimir
