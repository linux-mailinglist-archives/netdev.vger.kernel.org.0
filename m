Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939AF25D3C6
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgIDIhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgIDIhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 04:37:12 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE73DC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 01:37:11 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a65so5264031wme.5
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 01:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tj73T1xY2q8J4wQAWLIEPCiyJE6Dj8pViQrtH1WzLEQ=;
        b=ljS24WP+69k8HOBSgbNus1ECWbCEA261BKlsExkSh/m38ZNtM2Hx4kbbkuZRexb/IX
         QOzVSdy9gUbOclOP2TUDxBAWFwlEqU91k1ouAGOZKBNYGO6E7l7bYDEfYj5YXc2pVqdd
         upaK+n1KXVzCFbE6lpwuNoX9S8WXYk0aS6VVHEhISspikv3yJWdE9MiTC1ri/h7nc8yn
         1WdshoGZOP+UL5dJrO4hbryTkYCqhyacRp6xmfwExtUZ9HWUdwoGbQWmx0vwszg4Gatp
         EAvOiOSXkysBxZbmElqYKPr2nGNnAoAQ1VAxQhb95s8xFJXp4lKltJWnW9ZfkwSf4YGg
         ICkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tj73T1xY2q8J4wQAWLIEPCiyJE6Dj8pViQrtH1WzLEQ=;
        b=gO4Ly65WqRff3CLUMriXAShQwv7eyim0jxl2/isup20TvMu8JVq7Zf3nH0e6eoVfwq
         EzcAFq3Ro5qZmYKDvPtLoouSfPNHriUdzDSO/Upaj9XkOXUoMiJ7nFYELPzDK8Olkbm6
         +yJTPIVL8NDKBGBDZY8DJ20oMQdMGRmOUX0K4slDyWVFld+s55FcUm7gA5F96c4qJYm4
         G/7eYw+5CYgO7LMJJf270ysWPKcGXFsatcIDYc8BloU6Vu3v7fFJouqMc6XMAO/nl4KG
         g0W5U5keU7AZ91yzGdswLnjj5Nn4F5Ud1uXOmQqdY5+Wlb0VMH/Q7cEPa/cq2Xygh3w7
         lUGA==
X-Gm-Message-State: AOAM532tI94Fu2tZg0U/fxUqSO1BZA8UGodyNaT8umrdTrpZ8G9nzauY
        UjubsfZxV1xmyquAgBPNCc5X7AzoU37NpBG/
X-Google-Smtp-Source: ABdhPJyWw+Cf/9wmztB9LW18ctKXrrxJbAV56dfEVZWsTcHTR60Yv7kGSsROMvBj1vKKmCQlDgAqUg==
X-Received: by 2002:a1c:7f8b:: with SMTP id a133mr6904517wmd.155.1599208630295;
        Fri, 04 Sep 2020 01:37:10 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id a17sm4780290wra.24.2020.09.04.01.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:37:09 -0700 (PDT)
Date:   Fri, 4 Sep 2020 10:37:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Sunil Kovvuri Goutham <sgoutham@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "sundeep.lkml@gmail.com" <sundeep.lkml@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Message-ID: <20200904083709.GF2997@nanopsycho.orion>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 04, 2020 at 07:39:54AM CEST, sgoutham@marvell.com wrote:
>
>
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Friday, September 4, 2020 12:48 AM
>> To: sundeep.lkml@gmail.com
>> Cc: davem@davemloft.net; netdev@vger.kernel.org; Sunil Kovvuri Goutham
>> <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta
>> <sbhatta@marvell.com>
>> Subject: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
>> Octeontx2
>> 
>> External Email
>> 
>> ----------------------------------------------------------------------
>> On Thu,  3 Sep 2020 12:48:16 +0530 sundeep.lkml@gmail.com wrote:
>> > From: Subbaraya Sundeep <sbhatta@marvell.com>
>> >
>> > This patchset adds tracepoints support for mailbox.
>> > In Octeontx2, PFs and VFs need to communicate with AF for allocating
>> > and freeing resources. Once all the configuration is done by AF for a
>> > PF/VF then packet I/O can happen on PF/VF queues. When an interface is
>> > brought up many mailbox messages are sent to AF for initializing
>> > queues. Say a VF is brought up then each message is sent to PF and PF
>> > forwards to AF and response also traverses from AF to PF and then VF.
>> > To aid debugging, tracepoints are added at places where messages are
>> > allocated, sent and message interrupts.
>> > Below is the trace of one of the messages from VF to AF and AF
>> > response back to VF:
>> 
>> Could you use the devlink tracepoint? trace_devlink_hwmsg() ?
>
>Thanks for the suggestion.
>In our case the mailbox is central to 3 different drivers and there would be a 4th one
>once crypto driver is accepted. We cannot add devlink to all of them inorder to use
>the devlink trace points.

I guess you have 1 pci device, right? Devlink instance is created per
pci device.


>
>Thanks,
>Sunil.
