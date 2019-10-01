Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41AC323A
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfJALSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:18:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34789 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfJALSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:18:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id k7so5297260pll.1;
        Tue, 01 Oct 2019 04:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vclka+b6sA1d1SpG2he4SF2xiZ2zKDdA9WZvKEFU3Hc=;
        b=DyDyEcCRTpyrEv2o5hM3Ae7vRm2wNIMODDZyvwFpmOAqPSFmgE5bTlxteZDTndAhex
         KRGYPxad/uYvZl3jZSfERRyWvRW3AYm6uTfgYsNAAyecVecosDFcqq64XMd6iw7PPA7+
         dVc5ELtiRxP7N8LoQQyGFHb/TSJfF9y92qZ1nctoaKRFojEq4e/Y7qy/3pQ73GQbzdx6
         V/Yea2NIdPxqVqpggfrkrunzMb6JcEgUHK1aMK8rC34LoLpR2oJ4MsUriUgbm10e+XOs
         bFCR5xMoSCF+JKK6oHjvjSBJ67s4IdTo7lKiCVbw12kY7Xi59vXnTeY7rpdFnm/0Ej2x
         GPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vclka+b6sA1d1SpG2he4SF2xiZ2zKDdA9WZvKEFU3Hc=;
        b=LOZ9Bc2kEG/Q5zEnS/VvQtyZFZmKCeHGZt7WoKtu0x8OdqIAchDzoqrPIG+Wra5E18
         OILQBOkdjc0JQzWOVJPhsoQv+D10ZE25L7wQIZx8qxrfgeqLXfhw7cgnCHfKe7k2oYfZ
         wSLpoQ/nvpsFr3+40+55TWQQufb1lg7a1uMhG6cF1QlWg+VhlLDPMQkSnlHDBSS3vXKo
         TFZkeKV94bzkMIs1VT/rof6vRiSYkoU/L5rFGx7jQ/izZZBNmvdAn3isVSyKY/1l2WNn
         If/opqBFcoofEA1eykEOAFQ/3YVfqifllExGN5Q0dsYXNnPt9lqNU0RMCdqSLY4AAI3k
         Abtw==
X-Gm-Message-State: APjAAAXXCJehCUG2U0o0xAFubIx+WHExmw4mq0foiXv4YqeNgG2AcLWS
        9tBvghY0WQ17QdwoAT4r0J2dkkNTiOGVyQ==
X-Google-Smtp-Source: APXvYqw4FzjxU/GlfKG6d544fkxfHBcf8khQWJLcswUlFFyikkOLY2i9xFfkB3R+U5qmL5qqK9dx2Q==
X-Received: by 2002:a17:902:bc48:: with SMTP id t8mr25171504plz.255.1569928722448;
        Tue, 01 Oct 2019 04:18:42 -0700 (PDT)
Received: from gmail.com (ip-103-85-37-165.syd.xi.com.au. [103.85.37.165])
        by smtp.gmail.com with ESMTPSA id m22sm6021121pgj.29.2019.10.01.04.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:18:41 -0700 (PDT)
Date:   Tue, 1 Oct 2019 21:18:36 +1000
From:   Adam Zerella <adam.zerella@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: networking: Add title caret and missing doc
Message-ID: <20191001111836.GA10737@gmail.com>
References: <20190928123917.GA6876@gmail.com>
 <20190930113754.5902855e@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930113754.5902855e@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 11:37:54AM -0700, Jakub Kicinski wrote:
> On Sat, 28 Sep 2019 22:39:17 +1000, Adam Zerella wrote:
> > Resolving a couple of Sphinx documentation warnings
> > that are generated in the networking section.
> > 
> > - WARNING: document isn't included in any toctree
> > - WARNING: Title underline too short.
> > 
> > Signed-off-by: Adam Zerella <adam.zerella@gmail.com>
> > ---
> >  Documentation/networking/device_drivers/index.rst | 1 +
> >  Documentation/networking/j1939.rst                | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
> > index f51f92571e39..1f4a629e7caa 100644
> > --- a/Documentation/networking/device_drivers/index.rst
> > +++ b/Documentation/networking/device_drivers/index.rst
> > @@ -24,6 +24,7 @@ Contents:
> >     google/gve
> >     mellanox/mlx5
> >     pensando/ionic
> > +   netronome/nfp
> 
> I wonder if it's worth keeping the entries in a roughly alphabetic
> order?

For sure, I've re-submitted a v2 patch :)

> >  .. only::  subproject and html
> >  
> > diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
> > index ce7e7a044e08..dc60b13fcd09 100644
> > --- a/Documentation/networking/j1939.rst
> > +++ b/Documentation/networking/j1939.rst
> > @@ -272,7 +272,7 @@ supported flags are:
> >  * MSG_DONTWAIT, i.e. non-blocking operation.
> >  
> >  recvmsg(2)
> > -^^^^^^^^^
> > +^^^^^^^^^^
> >  
> >  In most cases recvmsg(2) is needed if you want to extract more information than
> >  recvfrom(2) can provide. For example package priority and timestamp. The
> 
