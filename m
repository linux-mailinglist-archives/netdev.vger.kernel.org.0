Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8061531C
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 19:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfEFRyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 13:54:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37355 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEFRyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 13:54:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id o7so3818951qtp.4
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 10:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QhugHBuoBeAcIwpcanoLwTWHJfxQHnSCegSWAvWi8kU=;
        b=puewRPLH4Nh/tosb7+eyKJyRGegVRvwvSe51SQhwLutt2q6m0+ltEOplW8mkMCUoiz
         c9A02CPaqRZaZExZZ8hjy1+Wi12kEipDiFDwJcKNFhoYqxwGNA1xnN+PTUvHSBW+mTrl
         v1C3cZHCAz+/YObFqsrKCorzir4viKXiogisTmNG/II+6qOgGMez0Dw7PhiX/pfAw5B1
         G7jbTG1mSlgyh4DlZaMPtF8WXUwxSHowOeYCVHwF/XVuecLJTzzwrfjLPxAp6kildygK
         GIZFmG5d6/N8z6/CATq1ii4dfcJvhKRsjRhdbbyGk8DFEDIsTchK0gjtvUxpC+iDOC1q
         vnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QhugHBuoBeAcIwpcanoLwTWHJfxQHnSCegSWAvWi8kU=;
        b=XoBGl5naVNp+MkRbIC5OXywVaAhOpabs/D4nQAMdvCKEp8SCAv8L720GkVGOFNbM3J
         WHldsT5ZEN8YFhnW+HZXNaz2o8kMQ7OKcN0Eag+La/H0hX5vmyt6WIMSJvaNMmkJV3fB
         upxzoWWbVYgxpL4o79UrpU4tEORqOX0aoIQjowUrWcvNIaY5mZTKt18BVazUqCjGkxes
         C4MN8k4t4WVNfcrHX8Mv5seJIgON22ZIecCfzbmx/DiXWl/b+vlvAO/DbXiGvmcq9Lfi
         p4XAwxP36CPdITg8toQsdzrlFmdhtFHXHEq6o8P3P0opR/o1gcAKl7mBYZXp+VQrNVBp
         H3Lw==
X-Gm-Message-State: APjAAAVIqoFMOg3Yyhg9t38Kes2IgHkcD1XdAxfdNEczBDkpizVHlaWx
        6QO/XPU1Su1DIAXXp0sgaxt4Hg==
X-Google-Smtp-Source: APXvYqy5PtVe8FLAX6kDTgdUP43dSzUlx/5JyN5cnA6nyK/VlRdXqugen7LkGUTYbhAIs7gMXx0zyg==
X-Received: by 2002:ac8:3157:: with SMTP id h23mr84589qtb.248.1557165255314;
        Mon, 06 May 2019 10:54:15 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f6sm6382006qti.4.2019.05.06.10.54.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 10:54:15 -0700 (PDT)
Date:   Mon, 6 May 2019 10:54:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 0/4] net: mvpp2: cls: Add classification
Message-ID: <20190506105407.69ff9a08@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190506100026.7d0094fc@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
        <20190504025353.74acbb6d@cakuba.netronome.com>
        <20190506100026.7d0094fc@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 May 2019 10:00:26 +0200, Maxime Chevallier wrote:
> Hello Jakub,
> 
> On Sat, 4 May 2019 02:53:53 -0400
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> 
> >On Tue, 30 Apr 2019 15:14:25 +0200, Maxime Chevallier wrote:  
> >> Compared to the first submissions, the NETIF_F_NTUPLE flag was also
> >> removed, following Saeed's comment.    
> >
> >You should probably add it back, even though the stack only uses
> >NETIF_F_NTUPLE for aRFS the ethtool APIs historically depend on the
> >drivers doing a lot of the validation.  
> 
> OK my bad, reading your previous comments again, I should indeed have
> left it.
> 
> I'll re-add the flag, do you think this should go through -net or wait
> until net-next reopens ?

I think the patch should be relatively simple and clean?  So I'd try for
net, with a Fixes tag, it's a slight ABI correction and we are still
in the merge window period.  So I'd go for net :)
