Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4740F2774F2
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgIXPMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgIXPMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:12:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A5FC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 08:12:03 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m6so4278488wrn.0
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 08:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8pWS49PSRm1MsKu9/+JFRIQmiWwngfiEZa7juJz6FqY=;
        b=icfysCB3k7XRup6OZIt84CyAauWH4VSrLuQnaUS4N1V5/nsRojCpjICepu7GvzCpRx
         1/gyBkd7i99x/S+Ho01OMn7Rw1SAfynVO64QOn+parcmwZXfh/6MF0OYI9dR6vJzhJyj
         XQvFGe2yHMCWivHYsQD1U34JA4jL7R2+6f53oQ5a+mtYCxU6mSzFrqw7NHtZez3l+p6J
         ZcnyJNLH6Ryy8JxanoM/cbL2sMyGLYNpM4iN6ATI9W3ul8eHCt2UUus+fyk7FT81Ntsu
         24YlByfPJc9uDq8AU7wtYcFArfsHekMVF2XDCm6xdNHRBtJ8B+IV0W7kkDa/zZNAP26B
         z2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8pWS49PSRm1MsKu9/+JFRIQmiWwngfiEZa7juJz6FqY=;
        b=bdBBuyTieq+0BPwskxrlhsAAI/7QJ+D4MmeJoS01UbkMzUYXGL7O2T8BGuKyRbLuoX
         LnTidFXEaoHXhqG7kbETZsXrInWFGz1LyhHnc+XNQ82Q7t4vo74WpdrWoNN7Ro+6IcMT
         iAJ9d3njcFC1pljbFv3JTZIgw6j/Nx2ktskiFvZN3ZiMfFSHAuDJs6S1G54jp1Pnxpjt
         Ia12A5iynjnUJVPCurGoiIBbjYxhgjyQ4RAR2VsOl9PpsJQ2bDigzNGGFnVjI7b+TE9q
         FqnYyf1w3bvA28Dh3LbgHMHRpG3rcnXDlDsOihYaYBL1AqX4AH2/CPWZ/IFk9t4CBqb6
         ZCCg==
X-Gm-Message-State: AOAM533HeKcu2PyqS+aVrrDM/6/T7MNVjgPm6IkkZDjKmRJOfDL8xmQU
        58Kl9PsXrJ6VyFqMvbYYCz1iGWYHXfpkpA==
X-Google-Smtp-Source: ABdhPJz0Hvm9oWtMIZthiCdSLh1mV9yoWhl9muzdt2DlQYMXyhL8K6VzvApD3yptP+bhA0tYWrmDZA==
X-Received: by 2002:a5d:4b86:: with SMTP id b6mr227346wrt.173.1600960321654;
        Thu, 24 Sep 2020 08:12:01 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id 18sm3675354wmj.28.2020.09.24.08.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 08:12:00 -0700 (PDT)
Date:   Thu, 24 Sep 2020 16:12:00 +0100
From:   Jamie Iles <jamie@nuviainc.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jamie Iles <jamie@nuviainc.com>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH] net/fsl: quieten expected MDIO access failures
Message-ID: <20200924151200.GW418386@poplar>
References: <20200924145645.1789724-1-jamie@nuviainc.com>
 <20200924150453.GA3821492@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924150453.GA3821492@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Sep 24, 2020 at 05:04:53PM +0200, Andrew Lunn wrote:
> On Thu, Sep 24, 2020 at 03:56:45PM +0100, Jamie Iles wrote:
> > MDIO reads can happen during PHY probing, and printing an error with
> > dev_err can result in a large number of error messages during device
> > probe.  On a platform with a serial console this can result in
> > excessively long boot times in a way that looks like an infinite loop
> > when multiple busses are present.  Since 0f183fd151c (net/fsl: enable
> > extended scanning in xgmac_mdio) we perform more scanning so there are
> > potentially more failures.
> > 
> > Reduce the logging level to dev_dbg which is consistent with the
> > Freescale enetc driver.
> 
> Hi Jamie
> 
> Does the system you are using suffer from Errata A011043?

It's the HoneyComb SolidRun (LX2160A) and I can't find an errata list 
for that chip.  It's booting from ACPI in any case so wouldn't have that 
workaround set.

Thanks,

Jamie
