Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23CB1F5EA2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgFJXP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgFJXPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:15:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E32C03E96B;
        Wed, 10 Jun 2020 16:15:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so4462738ejd.8;
        Wed, 10 Jun 2020 16:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=098m3juxTj5Be1v/XiKMzHXmJ9CEzQY3ImJrwNGQC1U=;
        b=ZqNCRuWstcUB8tRXvI6UReYk37qb7AAIWkmfn7PIrOb95aPVU3aFB3+SOpYTogtYH9
         kyagT4HOgsaExEDqp49JLOo5tn789OIqNn17KdIkH9B4EJPgt8agrkxXe1ecNaOaghdW
         JIvZwev3LlVS6rKH4LvcOSN/yM+WPlqMv/w2tNC8xYcledLHEyHHEQ8RY6vDODqv1Evj
         EeEvwJ0oZqFIwLWwu4ivbk9u4oJfla30G/P8UDyWd5MVJU/bpl5R4BgcFxHJ0aaZKRt1
         U6kq/5u4vGBZzbkrpCUgzNzzsUg945ePo8TLdZp0STJ579U/bPJfXVhg604klGtzGj57
         +JQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=098m3juxTj5Be1v/XiKMzHXmJ9CEzQY3ImJrwNGQC1U=;
        b=LFvUbk/lljJiaIeelBSPtdABL2a/Hq97SZ5xIH/0REVtfEQsIhvfKQ7zmJU2hORYXw
         +yjVsCGt2Tdz1duBNGtN2g1NgaZ8+ntLCDKfaAwBiyHU3dNBj8E/wlj0/2i/ZXSUzNT4
         6609q1TrUagfydupPb07BNBK9IKYSKlJXYot12vyCKzfcDFoqrLJ/5vFRMiTreYEu3zf
         F+0Hz43gOIPaL+gGdAW+NYYB2cA5RS6sco2JC9LNLMSr8alquAMRplJcYWaG8hK2x5+w
         qY+76Bq27QPOn5982fqnNQVBmtLuC5/Ce5FaKk+uK4MTAy7c8jC32vu5Bo1Pca5ppbgi
         CAGA==
X-Gm-Message-State: AOAM530JSsHGp2U3y2ugx9CT0GCPc8n+nUUFXNfWcmhDED045oZF5jEB
        MEJ+5xCebyXChoXsoajSx65kmi5BJYg7YmydH2z2Cw==
X-Google-Smtp-Source: ABdhPJzvSXHGRi/CfxvCD0/gI7rJV1oUp7tlIOSsCg004WcfMP7BpyIhJrnIsrI5sQV7N9uPegTtRxU/3u0dnTgs5dA=
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr5417965ejb.473.1591830924143;
 Wed, 10 Jun 2020 16:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200610230906.418826-1-kuba@kernel.org>
In-Reply-To: <20200610230906.418826-1-kuba@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 11 Jun 2020 02:15:11 +0300
Message-ID: <CA+h21hrQYubDvVcYJ-L0+MNT9hAmSrRofqPHMMA6=2OReFfg5w@mail.gmail.com>
Subject: Re: [PATCH net] docs: networkng: fix lists and table in sja1105
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 at 02:10, Jakub Kicinski <kuba@kernel.org> wrote:
>
> We need an empty line before list stats, otherwise first point
> will be smooshed into the paragraph. Inside tables text must
> start at the same offset in the cell, otherwise sphinx thinks
> it's a new indented block.
>
> Documentation/networking/dsa/sja1105.rst:108: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/networking/dsa/sja1105.rst:112: WARNING: Definition list ends without a blank line; unexpected unindent.
> Documentation/networking/dsa/sja1105.rst:245: WARNING: Unexpected indentation.
> Documentation/networking/dsa/sja1105.rst:246: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/networking/dsa/sja1105.rst:253: WARNING: Unexpected indentation.
> Documentation/networking/dsa/sja1105.rst:254: WARNING: Block quote ends without a blank line; unexpected unindent.
>
> Fixes: a20bc43bfb2e ("docs: net: dsa: sja1105: document the best_effort_vlan_filtering option")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  Documentation/networking/dsa/sja1105.rst | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
> index b6bbc17814fb..7395a33baaf9 100644
> --- a/Documentation/networking/dsa/sja1105.rst
> +++ b/Documentation/networking/dsa/sja1105.rst
> @@ -103,11 +103,11 @@ To summarize, in each mode, the following types of traffic are supported over
>  +-------------+-----------+--------------+------------+
>  |             |   Mode 1  |    Mode 2    |   Mode 3   |
>  +=============+===========+==============+============+
> -|   Regular   |    Yes    |      No      |     Yes    |
> +|   Regular   |    Yes    | No           |     Yes    |
>  |   traffic   |           | (use master) |            |
>  +-------------+-----------+--------------+------------+
>  | Management  |    Yes    |     Yes      |     Yes    |
> -|   traffic   |           |              |            |
> +| traffic     |           |              |            |
>  | (BPDU, PTP) |           |              |            |
>  +-------------+-----------+--------------+------------+
>
> @@ -241,6 +241,7 @@ switch.
>
>  In this case, SJA1105 switch 1 consumes a total of 11 retagging entries, as
>  follows:
> +
>  - 8 retagging entries for VLANs 1 and 100 installed on its user ports
>    (``sw1p0`` - ``sw1p3``)
>  - 3 retagging entries for VLAN 100 installed on the user ports of SJA1105
> @@ -249,6 +250,7 @@ In this case, SJA1105 switch 1 consumes a total of 11 retagging entries, as
>    reverse retagging.
>
>  SJA1105 switch 2 also consumes 11 retagging entries, but organized as follows:
> +
>  - 7 retagging entries for the bridge VLANs on its user ports (``sw2p0`` -
>    ``sw2p3``).
>  - 4 retagging entries for VLAN 100 installed on the user ports of SJA1105
> --
> 2.26.2
>

Thanks!
-Vladimir
