Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C132542543C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbhJGNjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241635AbhJGNjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:39:01 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ED9C061570;
        Thu,  7 Oct 2021 06:37:07 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t16so1355444eds.9;
        Thu, 07 Oct 2021 06:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OH5qreVaMSmbXoGA81iNDx+LFwebuH6MBwo5rPBptZ8=;
        b=nDdTpHUd+sRlsHIQLWo+Z0zHf3yza3jgR5dbfcJRC3m1Wx7OVo4MfisnalJCLlXXCe
         4hzTrrhdABjQkGcZiLuHOEqvww8QKE4kLwCtfPbkN6vGS62ISB269Vxo8jiswAsiwNTw
         MDrp0Ob7kmFNqm5l21mRIkltNq7z5xMJ0N1PaXH4B+QkXE6nv1w7Z0gR2MqnNF4Ji85r
         7Z+DB/nUBqxYVwqRz1UpD5RsubqGF6yMIi/Wf6MtbA+J13Cum7vDLSLYHhee+AF81d3F
         FOQTRKVB6aO1myO1mYSiUqDYXvXoslEwGeLLcUjcIKxe4cYj3zPhwBVOl1Z9XFMKjCKU
         EjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OH5qreVaMSmbXoGA81iNDx+LFwebuH6MBwo5rPBptZ8=;
        b=qLWHrG2zA3VulcJMTsbOmiFDDfqjV1vc+L7cRicqB8Kw2yetP4IuTTjWWFFf1rYOS0
         MCeq2hP47rbaVyPQQWI2U75qPCc3MdPzf9oBvUhZI0IE6lm2f32aciuBScNwrqKLiZGz
         vul3W1/yWDE5ZMD3m4z5gqCj0/5mOH2+KhgYJbeYmGCagRT08H74qge53EspwgYAyAEj
         iomtldHd0+3BPliGWJGJKTnlmhb2UZd7gA4rlYU/RYNk+BMMPG+vT3lRZqzcBmwkTI3b
         zwu1EN32MMhduymE2GBY85KAL+czxkgj5XBccDqyAAOPuluS/Ucen97T7So39PVe1NAw
         DvOw==
X-Gm-Message-State: AOAM532vpzP5AUiw6/WPCqqySM/JWiE8/0OG0h3ypmARCptixSvmKZxo
        IOYtR6ddeX3tUFzOCi3T+2AgxeNoVps=
X-Google-Smtp-Source: ABdhPJwpNjQDA7T7sZqWbPubagcGel8b3nacSf5PLzvXtJ6/5cLDcRKtKKm+sYisr9P4RzKlCFNXuQ==
X-Received: by 2002:a17:906:3402:: with SMTP id c2mr5730179ejb.271.1633613826095;
        Thu, 07 Oct 2021 06:37:06 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id 21sm10029013ejv.54.2021.10.07.06.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:37:05 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:37:03 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 11/13] devicetree: net: dsa: qca8k: Document
 qca,sgmii-enable-pll
Message-ID: <YV73/9WkMNMHpRcR@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-12-ansuelsmth@gmail.com>
 <YV4/6TRdd3N1v8Zv@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV4/6TRdd3N1v8Zv@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:31:37AM +0200, Andrew Lunn wrote:
> > +- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
> > +                          chain along with Signal Detection.
> 
> Continuing on with the comment in the previous post. You might want to
> give a hit when this is needed.
> 
>      Andrew

Ok I can put here all the finding with the common configuration found
with qca8327 and qca8337 so someone can try to guess the correct value.

-- 
	Ansuel
