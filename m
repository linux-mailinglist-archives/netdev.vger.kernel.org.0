Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73022A0B7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404450AbfEXVyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:54:50 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46096 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404265AbfEXVyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:54:50 -0400
Received: by mail-ot1-f65.google.com with SMTP id j49so9973461otc.13;
        Fri, 24 May 2019 14:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WwRWeH6o4e0zEUidM8+Mp3KiI/hAFcVnEjbVX8vBMvc=;
        b=NR+6h/mZ388JZn47DxAtfXlAwspc4zwQhx8h0j2rrCLC+3cfTKdygvLx9wgSRALoc2
         fm84ThsYvuBya9Nc9zJIJooMBFpuuFSbxY6zyRM4NJM7okbCAWks2kJOzhOMaw3rXesd
         NzUpBir/uXMiilWCzGHG8BHRm6AQUK79j0WTMbIchSjnaE49FMu+qG/zrh9ivoSyP0L3
         bMjNhQTV16qenavvZKBCQq+WgoAVCmCp/0hc+KEQwF49LRa8F2SNyL+VwLZDBsmgD87T
         p+mx3jtElupMkK2bnf2HsGWGiB7jvy867YKDTiORXyR5FQ1FyjJ+h1rAuJ2f3DADFLiE
         rAIQ==
X-Gm-Message-State: APjAAAVPWps14D6EHhiNcTXY3JL/ZebRSk+FSbwlIV2Q5QEhFf21hRRe
        OeDWMxLBZexx3nYVjcXJMQ==
X-Google-Smtp-Source: APXvYqxfYQC+exjUSNJQHKb3wOaN746sP+WD7kMTf/uk/I7m4GfAAdcQaxmAayNlguFMhN8AXAnZMQ==
X-Received: by 2002:a9d:7cd2:: with SMTP id r18mr223772otn.345.1558734889169;
        Fri, 24 May 2019 14:54:49 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 80sm1585634otj.2.2019.05.24.14.54.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 14:54:48 -0700 (PDT)
Date:   Fri, 24 May 2019 16:54:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
Subject: Re: [PATCH v6 1/3] dt-bindings: net: add qca,ar71xx.txt documentation
Message-ID: <20190524215447.GA12009@bogus>
References: <20190524111224.24819-1-o.rempel@pengutronix.de>
 <20190524111224.24819-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524111224.24819-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 13:12:22 +0200, Oleksij Rempel wrote:
> Add binding documentation for Atheros/QCA networking IP core used
> in many routers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/qca,ar71xx.txt    | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qca,ar71xx.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
