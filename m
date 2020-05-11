Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA0D1CE754
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEKVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:22:07 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33633 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgEKVWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:22:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id o24so16431678oic.0;
        Mon, 11 May 2020 14:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A5N9k4OzZmaTO+FjQHm/11Qc3TmT7nJ42FhO7DlyuG4=;
        b=R1Fljplja9SZGEK7ZQyjSxQ2NtUcRwzVPCSe5kwO/MvkBOOM8hAWxd9EH1CjG6sgBQ
         RmEyCpgV3fitovnwTBdXXQVyYdw0ZT/twVkLoCldgZsef2FgqOWXrHhJwpstu83IgUyN
         8WJm8J9qSaOVQl+z8SZ+kJgPi5pzE0oBwOxnJcjJd9P4zVAy2xbYd+iU1mEZCFIUCxr/
         wNrdib/DEZxzspdkW741G3MWJwnOwyo7HGVXjWEU1RGybXhF52+c/8OicKIz+Bp9dDVB
         yChuof2RsdIaSmWNkQ+UWEdSMmn9Qr1cc6Sy3Ufob8HJbngxr1lIREYZ8a/SSQBPT1x4
         xIqQ==
X-Gm-Message-State: AGi0PubzKkN+RZTUmqy1a9XOrJMTbot3RMtcBuqoGml8jLkkz8cgpOWU
        2viNDevid6PjY3FTpFF71g==
X-Google-Smtp-Source: APiQypJKTuMkLXLblZgnRvU8eLNlu+Wi9ZR1esUWUL4koSC6FWgLK3fnrM/xAwcHjJhFz3Sg02alZQ==
X-Received: by 2002:aca:c613:: with SMTP id w19mr20177129oif.114.1589232125711;
        Mon, 11 May 2020 14:22:05 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t15sm3141216oov.32.2020.05.11.14.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 14:22:04 -0700 (PDT)
Received: (nullmailer pid 1133 invoked by uid 1000);
        Mon, 11 May 2020 21:22:04 -0000
Date:   Mon, 11 May 2020 16:22:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: sh_eth: Sort compatible string in
 increasing number of the SoC
Message-ID: <20200511212204.GA1071@bogus>
References: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Apr 2020 11:38:15 +0100, Lad Prabhakar wrote:
> Sort the items in the compatible string list in increasing number of SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
