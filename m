Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CD216AF8D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgBXSoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:44:54 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39694 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:44:53 -0500
Received: by mail-oi1-f196.google.com with SMTP id 18so6974999oij.6;
        Mon, 24 Feb 2020 10:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZXEayj8xf3Si4hv36edVPHio/K5x1RomX601FJVG5oI=;
        b=ZlOuwycup5L1p69xG1io6qfLLxvRFP4SdgX8JWXA4WeDjpniNPjPuYkInXpUrkI8D7
         yg1MwLhJuJguZDogPMmcj3Wxa+GAj9hVWZOkuw6F9O/QuQLTOQ7cIx2HQQFiG84epdCa
         78WonXFnAv//8+zxm/qkySXjdpK5+UulQsn5J6VUH2wu45taOXtydUcy88HmmnujHNaQ
         T75ZaVO+wIbFdto0FrnEM7u1KI1hLy8Go0qv1N+CZl3RuOVEi1X6+thdmVpq+CK4Oq/B
         XmhNZhs95gq/wcTkh2uvz4O2oDbwN9TXxpZSftFw0VlE2Wu0CgNoorgguwbw0D0H/wTP
         mskg==
X-Gm-Message-State: APjAAAUfKQlIQN5oZ50krroGmzAd/mOj4i+h4DQjHDm/AgcmjBbSn9V+
        Xv82X2YRslFO5LdhoC9pNFG9MF4=
X-Google-Smtp-Source: APXvYqyQEk9IgcxUJXQaTD6Vy2Stx22qTLXqchW+luQSCrCnqBcUEm3Nwg6USR5r2OPJI7LIO3oQeQ==
X-Received: by 2002:aca:1108:: with SMTP id 8mr343387oir.127.1582569892915;
        Mon, 24 Feb 2020 10:44:52 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t203sm4318661oig.39.2020.02.24.10.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 10:44:52 -0800 (PST)
Received: (nullmailer pid 14849 invoked by uid 1000);
        Mon, 24 Feb 2020 18:44:51 -0000
Date:   Mon, 24 Feb 2020 12:44:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     min.li.xe@renesas.com
Cc:     mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/2] dt-bindings: ptp: Add device tree
 binding for IDT 82P33 based PTP clock
Message-ID: <20200224184451.GA13180@bogus>
References: <1582321718-27516-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582321718-27516-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 04:48:38PM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add device tree binding doc for the PTP clock based on IDT 82P33
> Synchronization Management Unit (SMU).
> 
> Changes since v1:
>  - As suggested by Rob Herring:
>    1. Drop reg description for i2c
>    2. Replace i2c@1 with i2c
>    3. Add addtionalProperties: false
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  .../devicetree/bindings/ptp/ptp-idt82p33.yaml      | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
