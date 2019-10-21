Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B77DF1DE
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfJUPog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:44:36 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40166 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJUPog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:44:36 -0400
Received: by mail-qk1-f195.google.com with SMTP id y81so9158615qkb.7;
        Mon, 21 Oct 2019 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=HDhjOqeUfgWVXbHfFP5ui5Vyb/A5QMYbGddkw3X1g+4=;
        b=tstJpzjiDKsHUQBIP2k3qmQ/qN6Bkh1W29mbiyx1daQZqX0KJGiDKK93z3I/ruIIcn
         EYMJvKUCeifUVZkb/cCz9pSATl7+rIlrmrsIRe6k9vVyAVpYfRuzf89vOjxiYPeeJTZP
         /37pnfS/SdJ7ZrdtWs//rj4v/OioZwRvfR7hcwvok8OIYJDxVmKoimTZP7KGnmtMJfPC
         dG677pD2lBG9eg4Mu/7teRMmCboDS9MeDlsg9jCamkpU5uRv7/IftuYBmBF64ck5kbA4
         Yfp5Q2acK/NCEOEtwNbMM0npLpsnO09XvrrFEqwsLljHOXPQ96DQc/8a8ydztCApoD9D
         4Hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=HDhjOqeUfgWVXbHfFP5ui5Vyb/A5QMYbGddkw3X1g+4=;
        b=OuVYFxVAEBaIKPlMyPsF2Uj8nzj9Gq8YtKJ0hPe0jjZQ155Y/ECqhU9YIpfA5QZqrv
         Xv4dtFqFPZr05vNgjT/7tok6upDPeqxEGvbNGAHXliQ5qDBGBK9CvsmBKpSeprRuo0ZK
         yIbAneJmEobVpBElQW7PZC+jGF77x2lSV0YU76m3IywA4QgASIIfVw87KQjIOPlzRt8w
         aYqximYHIizE0PkJGRldDPqGX1fDQWd1+B63UUxaBnzyiPHU1spLmAT16++PRQe0Q6au
         laMwzjkT+sFfcK1Oh+HJDCbX1pleTU0IORqMD9mOb8BKgUszigkfoT5PInL3V/hZNblS
         jDmw==
X-Gm-Message-State: APjAAAXrN25oBABs3EqDNYVzbovhRGO3IF68iIjUoxXBMUuRwzQWFrPt
        IxzO8wxj5vF1Oo4IWdGvwDc=
X-Google-Smtp-Source: APXvYqyy+5yZWhlyebOTvlCz602wXzzW/qg7Oosiq7hrDzR3TFinfkCyLxtgQZnmBd8Djcl04EaRYw==
X-Received: by 2002:a37:5257:: with SMTP id g84mr6659288qkb.247.1571672674869;
        Mon, 21 Oct 2019 08:44:34 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y62sm3530823qtd.62.2019.10.21.08.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 08:44:34 -0700 (PDT)
Date:   Mon, 21 Oct 2019 11:44:33 -0400
Message-ID: <20191021114433.GB6522@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/16] net: dsa: use dsa_to_port helper
 everywhere
In-Reply-To: <20191021123149.GB16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-2-vivien.didelot@gmail.com>
 <20191021123149.GB16084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 21 Oct 2019 14:31:49 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sat, Oct 19, 2019 at 11:19:26PM -0400, Vivien Didelot wrote:
> > Do not let the drivers access the ds->ports static array directly
> > while there is a dsa_to_port helper for this purpose.
> > 
> > At the same time, un-const this helper since the SJA1105 driver
> > assigns the priv member of the returned dsa_port structure.
> 
> Hi Vivien
> 
> Is priv the only member we expect drivers to change? Is the rest
> private to the core/RO? Rather then remove the const, i wonder if it
> would be better to add a helper to set priv?
> 
> Otherwise:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I had the same thought but actually since the SJA1105 driver is the only
user, I was thinking about maybe getting rid of it, I don't really see the
point of having some "dp->priv = priv, priv->dp = dp" kind of code...

In the meantime I kept the eventual helper or priv removal for a future series.


Thank you,
Vivien
