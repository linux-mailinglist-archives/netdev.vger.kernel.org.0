Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB2137658
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgAJSrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:47:24 -0500
Received: from mail-qt1-f181.google.com ([209.85.160.181]:42210 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgAJSrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:47:24 -0500
Received: by mail-qt1-f181.google.com with SMTP id j5so2795282qtq.9
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iDXs7GJRopkNsUE9KnH2AWuInO/13VctKFcUupza++o=;
        b=UgronQRnThCJgyP+i6G/xCOL83S0ijVNLFI2BX8ZN4N9U5g+MDKfkgR8skoR/xStxS
         WRssejjLZVQHH3xHa02y+pKS2VljZ7YJGKzJG0x9QIrtD8YdkW/5a3R7snVJS7Z8hr1G
         HFQcv59tKoEz55JX3K5WNHnm0BnK//2hJD4DbcYDVQmDnP56fey0pwaQZvSSc8xR2zRC
         dzUpbdXCSe8NuAMZnsebafmHL/bW22TM1P+VKa2qA/kGDDHX/p0dbQSXi7yJQx0lw8eb
         0Nf7uKzHDha1awiFfz4xPOKUW7Vr4eJEeVYvThouac5EvG9FB6l1eztYFNu37ggQbxwB
         Answ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iDXs7GJRopkNsUE9KnH2AWuInO/13VctKFcUupza++o=;
        b=t0n3rooEdKuyS8BrIUlU8WtVD/XetZC46HcSsF71z3uai51cxO32mcFLbf8cMBWy/d
         8jXTaWxIyrFxqwoyOd2Z9zmcEjBlW1iX3rNPFSyss33hjehkPfCIoJmwtzfsYNwk+v7v
         k2C29+y4E52LS5ep3gAac8GCCytr42fx6IrP97LoaoEabiUQdbg6RoV89v6adYK1nlm/
         Iv6lABHPeNuonvnSAJD7Ve6xWlcHVrK29RoOmHYV/zcviCSSRd7g2QVwc7purM+TKQyq
         5m5EoCO9BqlTDqetAPii7ZGxA7wEaoESuAWQr8eJSor7S9/+1cG1Jh9K7cLE9H8biNvl
         sbMg==
X-Gm-Message-State: APjAAAXYYL+NN50ixTWO67CuIwSyCMBmTILsVupZnRpEAicMU9zrTUAE
        Q+K85PxjoJVtuoOBWlSlPV1GaQ==
X-Google-Smtp-Source: APXvYqyNGkpQ08PZmDyL0t4ZF9kWmNuatOi1kwvsBmZfmFLelDUbMyjrsgsdxD7R2gz8hQJqdWhQdw==
X-Received: by 2002:aed:3be1:: with SMTP id s30mr3778119qte.163.1578682043632;
        Fri, 10 Jan 2020 10:47:23 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t198sm1283325qke.6.2020.01.10.10.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 10:47:23 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:47:19 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        valex@mellanox.com
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200110104719.2035572d@cakuba.netronome.com>
In-Reply-To: <c5fe026b-d29f-7be2-78b5-c54ec6d2f549@intel.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
        <20200110094027.GL2235@nanopsycho.orion>
        <c5fe026b-d29f-7be2-78b5-c54ec6d2f549@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 09:54:20 -0800, Jacob Keller wrote:
> On 1/10/2020 1:40 AM, Jiri Pirko wrote:
> > Thu, Jan 09, 2020 at 08:33:07PM CET, jacob.e.keller@intel.com wrote:  
> >> This series consists of patches to enable devlink to request a snapshot via
> >> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
> >>
> >> A reviewer might notice that the devlink health API already has such support
> >> for handling a similar case. However, the health API does not make sense in
> >> cases where the data is not related to an error condition.
> >>
> >> In this case, using the health API only for the dumping feels incorrect.
> >> Regions make sense when the addressable content is not captured
> >> automatically on error conditions, but only upon request by the devlink API.
> >>
> >> The netdevsim driver is modified to support the new trigger_snapshot
> >> callback as an example of how this can be used.  
> > 
> > I don't think that the netdevsim usecase is enough to merge this in. You
> > need a real-driver user as well.
> >   
> Sure. But this direction and implementation seems reasonable?
> 
> I am making progress on a driver implementation for this, and I am fine
> holding onto these patches until I am ready to submit the full series to
> the list with the driver..
> 
> Mostly I wanted to make sure the direction was looking good earlier than
> the time frame for completing that work.

As Jiri said, quite hard to tell without seeing the real user.

I presume you take some lock to ensure the contents of the snapshot are
atomic?  Otherwise I wonder if you wouldn't be better served by just
allowing region read to operate directly on the data rather then going
through the snapshot create -> read -> snapshot remove cycle. Not sure
Jiri would agree, it require more code.

For the patches themselves we may want to move the callbacks into some
ops structure in the region.  And I don't think you need to make the
trigger command NO_LOCK.
