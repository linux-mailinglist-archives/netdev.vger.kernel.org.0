Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3355C3A327E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFJRyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:54:40 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:42577 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJRyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:54:38 -0400
Received: by mail-ed1-f42.google.com with SMTP id i13so34067868edb.9;
        Thu, 10 Jun 2021 10:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F2qWmvpP74F98p+5ifMkX4kOE1F2B1dBwhcy7+VSBjc=;
        b=LlZ9CwHFMSVEkiHGaulHIa0NgI230lLtcDivlG4Vzg4k7twziEIJoVO70GXAVyZjYL
         FZ5xzGQPzJHfGQb6tmqlXfUTsAKm9mwIrnqS3rkUOUcjBww3ycu0OlM+PUOMO+3pDTB8
         svv/rp7Vb0D/b+W6ZGOrGa6q3NC43YgubWvqchYpMAVnKODJXpewlIsG0cLzIOdSU/JC
         FMccr08P+q/JbMjE6xUjtmR0NUlMhLbJyjNx8vzCMdL+AXgBMYNzGuyWiOSm6QQ1dmL4
         t2u+g66JWdIhnM0Isl+hEuWMbyLilnB6zDNY9qJYaJgbIwEQC52L+mAFA8zXWYJ9FdAk
         LMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F2qWmvpP74F98p+5ifMkX4kOE1F2B1dBwhcy7+VSBjc=;
        b=HhLPgzzHWs6DzDoY1J01j90DuMwbUFuV/LwUsszoM+zTy7YSnWlhvAtzphhcT2+Q81
         g89M1QLJco9kQeWorUuk239cWCBfxK6J/Mb5Sp7Jh/k+6jBi2PyMRX/BkgEBPZQfQLBR
         Rn3sIaBAyghCSavn3q6+yV7XBqtoh2Wf48JVNCOyK8rwFBf4M69ngmhQb82dScyURbG2
         wKejx5rRkTzQ+qhtlCTPfUPwj02lgOR0nE5ZFDCvBAV1urc47SfDmEh7mlqSRTRn2GhB
         QqNNNTr+gNFWgUsmovHuyPopTadNUy72/9X58pnQ68P3BUkHmtcIyORtfyFUXRjkXHL5
         68YA==
X-Gm-Message-State: AOAM530FtjJ7HOxbAiEEwDtHUpiEfUK8vv0dZBUQY1V6qhbhCmArR2dy
        5DDOuLzilnLAtQeKpr3nsYM=
X-Google-Smtp-Source: ABdhPJw8vqxqzzQRiTDLhaytg2KLMRxJKamdU26jua3FRlHN5ipm2hp+h49ukS+iyXdgrvV+0X8KtQ==
X-Received: by 2002:a05:6402:711:: with SMTP id w17mr719025edx.90.1623347486202;
        Thu, 10 Jun 2021 10:51:26 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id d22sm1318785ejj.47.2021.06.10.10.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:51:25 -0700 (PDT)
Date:   Thu, 10 Jun 2021 20:51:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: Fix assigned yet unused return
 code rc
Message-ID: <20210610175124.m56tftv4qjuyxkiq@skbuf>
References: <20210609174353.298731-1-colin.king@canonical.com>
 <20210610062358.GH1955@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610062358.GH1955@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 09:23:58AM +0300, Dan Carpenter wrote:
> On Wed, Jun 09, 2021 at 06:43:53PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The return code variable rc is being set to return error values in two
> > places in sja1105_mdiobus_base_tx_register and yet it is not being
> > returned, the function always returns 0 instead. Fix this by replacing
> > the return 0 with the return code rc.
> > 
> > Addresses-Coverity: ("Unused value")
> > Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_mdio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > index 8dfd06318b23..08517c70cb48 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > @@ -171,7 +171,7 @@ static int sja1105_mdiobus_base_tx_register(struct sja1105_private *priv,
> >  out_put_np:
> >  	of_node_put(np);
> >  
> > -	return 0;
> > +	return rc;
> 
> Should this function really return success if of_device_is_available()?

If _not_ of_device_is_available you mean? Yup. Nothing wrong with not
having an internal MDIO bus. This is a driver which supports switches
that do and switches that don't, and even if the node exists, it may
have status = "disabled", which is again fine.
Or am I misunderstanding the question?
