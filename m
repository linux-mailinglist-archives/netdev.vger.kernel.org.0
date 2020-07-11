Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E77021C474
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 15:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgGKNqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 09:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgGKNqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 09:46:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BF4C08C5DD;
        Sat, 11 Jul 2020 06:46:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u18so3793666pfk.10;
        Sat, 11 Jul 2020 06:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4QaG2Xnk2TYLlJE8J5iwYhAP5F08MFtwcs7P6RA6aEM=;
        b=oIq8s8tOLESYixQMi0A4Ssshbv5SYCHZuZ5PSvHfWPrOrLbLv9Te1ACCyR/pElxWhN
         GdCIUip+aCCtI4u9dvy2hILjNDigjU4q4r1chs2usc2xqVo5lSvSsSeiNyTE7nsyrr0U
         wpIyuOlNJGuOuCkfzx87aDhRf1BD+/wSfQO0vxv4Dw2wQibdhwDV6yEp8S+dm575YmJu
         XAZFnzG1Cy3NdYj8fIvFSG/37NLt0nzcAYeXAbzCNkUyBKHSgE0L46+VAv3sZJBMW72I
         2QHe9mIF4NMAZctQjU+PdWJdItewyOKOeo3/Y5KujMw1mYjtgA27sVSAaveOzFkqxjx7
         7m9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4QaG2Xnk2TYLlJE8J5iwYhAP5F08MFtwcs7P6RA6aEM=;
        b=gDjdjrsY/0MlDVT9zpNiNRR63OtXmkZkFb5HEHQQc8lFfJnHsqAr3c2Uso5K1PPzYy
         SG3KQhz7wTkMs3r7vIwlouow+ZdKu1neLI2QmJtsHxwRP7bWOXwbro1aGaFdJEEJNbBU
         5KkQuf4NZUjQlVNGNYwRmR4G6T08BV08GkpTy+gX85wRqNX5MCKkEckzpp5Ro41CtmpX
         J/Tcaw7S6W+CDlSLObjXDWLaRAzdqr4aXq10Bu4eHquKvoPe1PiTmazRBt9lOhcxdkZi
         F1n+EWvrHlEmt0MLPU5uyAAuN7G9hz6GNE+vxZjw8YlruTxLPTSXtRQcXRjYqJlwYtl5
         TJSg==
X-Gm-Message-State: AOAM533CpKM++yTLAoRaaCiDaQwKT+z7jWy470J9pOGAdVDCvR62WfZW
        VZXK9f+C2iEFLDN36hlwAFGo7XRK
X-Google-Smtp-Source: ABdhPJzrLGMlYJJj1TmdWoLOIt2CCho9ncVcFQlkYQt4yhPYrDiwtQvaoKTfoFg8YmF/bzy0rAsifg==
X-Received: by 2002:a63:6c1:: with SMTP id 184mr64354562pgg.262.1594475163475;
        Sat, 11 Jul 2020 06:46:03 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e5sm8525597pjv.18.2020.07.11.06.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 06:46:02 -0700 (PDT)
Date:   Sat, 11 Jul 2020 06:46:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     min.li.xe@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: add debugfs support for IDT family of
 timing devices
Message-ID: <20200711134601.GD20443@hoboy>
References: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
 <20200710135844.58d76d44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710135844.58d76d44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:58:44PM -0700, Jakub Kicinski wrote:
> On Fri, 10 Jul 2020 11:41:25 -0400 min.li.xe@renesas.com wrote:
> > From: Min Li <min.li.xe@renesas.com>
> > 
> > This patch is to add debugfs support for ptp_clockmatrix and ptp_idt82p33.
> > It will create a debugfs directory called idtptp{x} and x is the ptp index.
> > Three inerfaces are present, which are cmd, help and regs. help is read
> > only and will display a brief help message. regs is read only amd will show
> > all register values. cmd is write only and will accept certain commands.
> > Currently, the accepted commands are combomode to set comobo mode and write
> > to write up to 4 registers.
> > 
> > Signed-off-by: Min Li <min.li.xe@renesas.com>
> 
> No private configuration interfaces in debugfs, please.

I suggested to Min to use debugfs for device-specific configuration
that would be out of place in the generic PTP Hardware Clock
interface.

> If what you're exposing is a useful feature it deserves a proper 
> uAPI interface.

Can you expand on what you mean by "proper uAPI interface" please?

Thanks,
Richard
