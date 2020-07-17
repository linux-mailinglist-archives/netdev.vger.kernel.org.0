Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD68223F65
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGQPVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:21:55 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA46EC0619D2;
        Fri, 17 Jul 2020 08:21:54 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q15so15445737wmj.2;
        Fri, 17 Jul 2020 08:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WBAXuBvMYAjyFFymAkrMW/Oru448+6PWfHD7Ehg7jso=;
        b=sZEm+3+Lpom5tAaFN49nM9aVNJF2MSqqCz46S7ujzDjkK/GQTsaU9qv9VmumHj96GC
         rYOdNn7yQitZBS+aLbMbE1BbXGbbHzjbxGB+oPGibF+LFrhC5MZP/S8cifQmZyi+xE5+
         fTwbMgUBOTZ4xWYBR25PuZUyYyb2DXy/WRtLlbNz3wq32q++46zQtnDLz3Tl/5FnrrlW
         usGVXLmoDswA46hSN5U2gAkvknFzGt9ZW0PAGevRqngARYwzDlWdCG+/uCKaMCfgwUfA
         oIAYjOucIQONZVJVApMIcBNYZg9aEsI9ThKbbg2Zsc7MU2ZX3CndqvNTlUhPFD+WV93F
         ZJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WBAXuBvMYAjyFFymAkrMW/Oru448+6PWfHD7Ehg7jso=;
        b=Q0NWWV11nu6i9kCH8LjnUcDtcjXg/w9Q1VUQeQUGFM0wPmqCno26Mt3q9GEH0NbCkT
         rlxQxf2PitTWWsFyCRReudb1yHotNb0bbVOzCAxxls0pGVwqbY24P0/C2nSWAoPPB83A
         82zz+AuIpnqDg+lc7kzae6rld5IqjEPrCr+6CMQZY/vUZtYYZbs+076voVVcR4gt6Y59
         2fW/YEbbVqJxk7yxnJuq1ZnWPbdO5wug26hbBtuIUhD0HpH+IuGbI8h1FqokRDCz7xQI
         aHt+ImCae723LCG0N32Ko8l5M22Tsnszn76V0S+obVXrp2yWOWHKKddv7LfIvmEBB5N4
         ZouQ==
X-Gm-Message-State: AOAM531WW7I7ibAUjCnWK8Waexw0+cCmahhGkG1kUyAEjIsCtDiZz5B6
        xsMXQ7XYbaxC9JelBuIeoYxrKfGbLrM=
X-Google-Smtp-Source: ABdhPJy6XaHPHrU2tJqRe5t/ATmOFg4Yopjh2fB4TH5WkINeVPmDkeQjoz40hK9J21zb35yl0PVBhw==
X-Received: by 2002:a1c:48:: with SMTP id 69mr10321472wma.32.1594999313599;
        Fri, 17 Jul 2020 08:21:53 -0700 (PDT)
Received: from user-10.96.vpn.cf.ac.uk (vpn-users-dip-pool160.dip.cf.ac.uk. [131.251.253.160])
        by smtp.googlemail.com with ESMTPSA id v11sm11614589wmb.3.2020.07.17.08.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 08:21:52 -0700 (PDT)
Message-ID: <de7ace0ba7a8efb775ddf841b17564744cb83cff.camel@gmail.com>
Subject: Re: [PATCH] net: ethernet: et131x: Remove redundant register read
From:   Mark Einon <mark.einon@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 17 Jul 2020 16:21:51 +0100
In-Reply-To: <20200717134008.GB1336433@lunn.ch>
References: <20200717132135.361267-1-mark.einon@gmail.com>
         <20200717134008.GB1336433@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-07-17 at 15:40 +0200, Andrew Lunn wrote:
> On Fri, Jul 17, 2020 at 02:21:35PM +0100, Mark Einon wrote:
> > Following the removal of an unused variable assignment (remove
> > unused variable 'pm_csr') the associated register read can also go,
> > as the read also occurs in the subsequent 
> > call.
> 
> Hi Mark
> 
> Do you have any hardware documentation which indicates these read are
> not required? Have you looked back through the git history to see if
> there are any comments about these read?
> 
> Hardware reads which appear pointless are sometimes very important to
> actually make the hardware work.
> 
> 	 Andrew

Hi Andrew,

Yes - I'm aware of such effects. In the original vendor driver (
https://gitlab.com/einonm/Legacy-et131x) the read of this register ( 
pm_phy_sw_coma) is not wrapped in a function call and is always called
once when needed.

Also in the current kernel driver et1310_in_phy_coma() is called a few
other times without the removed read being made.

The datasheet I have for a similar device (et1011) doesn't say anything
other than the register should be read/write.

So I think this is a safe thing to do. 

Best regards,

Mark


