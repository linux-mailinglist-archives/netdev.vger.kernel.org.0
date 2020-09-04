Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6025D870
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 14:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgIDMLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 08:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbgIDML3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 08:11:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2BAC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 05:11:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so6488375wrm.9
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 05:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=80wz0A5khmJ1kfYFeDk+E2u+BtIEKfVElyxFPuHMzV0=;
        b=nmLOPyZXXqZx/JJa7IE6zjlGltW2Oz4Ff6bfAsMBKfgKLcApn3raEbo0M4qN/qqbs0
         iveAAtyFYgtWr0YYmbOD4KIrt2WnZfyYt4KqsuRb5iEg2Sw53ZFJqjwjDqbAlr1q5oCo
         ZqrCS1EAR+zcnqhWZqPcOZmY0zTvTKVAmQFBL4nMZ7zBlE83ckUeFdoaPU/mDB3ytYg2
         eTnS5CC0EmTmasNdo9S6wzLHp6aZSTSwGYvoH9vPWlhxB47Avi2u4lcshCBJtvxri2uF
         0JD07fTUJNsP5dUJ9JMdq9Jvq3BOjP1wHyD4WGU63KSNzyfukX8tFKnVIoDZXPo1v7Fr
         tfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=80wz0A5khmJ1kfYFeDk+E2u+BtIEKfVElyxFPuHMzV0=;
        b=hFWYCntyZkXyVZ9zJuCoGAoLK0cxwSTQSVa6gGI88aLv3M2x7ify0uYWPNNGEit+d1
         7Sl6rVTiLWWLnx+Y9Y+Ya/QcBC7V73sUtF2sDafSYDqfg2RdSjxYqnj+ss774Ddfkbfe
         wd10TXfqnTaVHBq070Ih94/bowk1tVST1tteq7aWz7ugCVqS7WkrErYz6C7pAXSMWtyS
         NJqj5WeJS+wqtd5xGofaclGbyQ2MxVbvJLubCzeTAxSxo9ASpokYrVo/5UcW1faiStUN
         hGjW4C8Ao4muWeypP/jVb9Yobchphx4elZ9c7Y/ecNfqyK1my2XVFBHiGDKrsw8x+PWE
         HOOw==
X-Gm-Message-State: AOAM530omgTyq00beILtpa2HEGehFvjA+PKbs3a0T2vQfpAO7jCWo77C
        5W9+FVjSYOEXB3C/cw2+PNKpfw==
X-Google-Smtp-Source: ABdhPJx5kdgH1of7BdNrhUCIwUMtDM9n+EsudsMWkAiFZT63Ja3/itS0kwF5HvUz3a0hnfimH0V4yw==
X-Received: by 2002:a5d:6b84:: with SMTP id n4mr7886520wrx.55.1599221487543;
        Fri, 04 Sep 2020 05:11:27 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o124sm10567823wmb.2.2020.09.04.05.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 05:11:27 -0700 (PDT)
Date:   Fri, 4 Sep 2020 14:11:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Sunil Kovvuri Goutham <sgoutham@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "sundeep.lkml@gmail.com" <sundeep.lkml@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Message-ID: <20200904121126.GI2997@nanopsycho.orion>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion>
 <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 04, 2020 at 10:49:45AM CEST, sgoutham@marvell.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Friday, September 4, 2020 2:07 PM
>> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>; sundeep.lkml@gmail.com;
>> davem@davemloft.net; netdev@vger.kernel.org; Subbaraya Sundeep
>> Bhatta <sbhatta@marvell.com>
>> Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
>> Octeontx2
>> 
>> Fri, Sep 04, 2020 at 07:39:54AM CEST, sgoutham@marvell.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jakub Kicinski <kuba@kernel.org>
>> >> Sent: Friday, September 4, 2020 12:48 AM
>> >> To: sundeep.lkml@gmail.com
>> >> Cc: davem@davemloft.net; netdev@vger.kernel.org; Sunil Kovvuri
>> >> Goutham <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta
>> >> <sbhatta@marvell.com>
>> >> Subject: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints
>> >> for
>> >> Octeontx2
>> >>
>> >> External Email
>> >>
>> >> ---------------------------------------------------------------------
>> >> - On Thu,  3 Sep 2020 12:48:16 +0530 sundeep.lkml@gmail.com wrote:
>> >> > From: Subbaraya Sundeep <sbhatta@marvell.com>
>> >> >
>> >> > This patchset adds tracepoints support for mailbox.
>> >> > In Octeontx2, PFs and VFs need to communicate with AF for
>> >> > allocating and freeing resources. Once all the configuration is
>> >> > done by AF for a PF/VF then packet I/O can happen on PF/VF queues.
>> >> > When an interface is brought up many mailbox messages are sent to
>> >> > AF for initializing queues. Say a VF is brought up then each
>> >> > message is sent to PF and PF forwards to AF and response also traverses
>> from AF to PF and then VF.
>> >> > To aid debugging, tracepoints are added at places where messages
>> >> > are allocated, sent and message interrupts.
>> >> > Below is the trace of one of the messages from VF to AF and AF
>> >> > response back to VF:
>> >>
>> >> Could you use the devlink tracepoint? trace_devlink_hwmsg() ?
>> >
>> >Thanks for the suggestion.
>> >In our case the mailbox is central to 3 different drivers and there
>> >would be a 4th one once crypto driver is accepted. We cannot add
>> >devlink to all of them inorder to use the devlink trace points.
>> 
>> I guess you have 1 pci device, right? Devlink instance is created per pci
>> device.
>> 
>
>No, there are 3 drivers registering to 3 PCI device IDs and there can be many
>instances of the same devices. So there can be 10's of instances of AF, PF and VFs.

So you can still have per-pci device devlink instance and use the
tracepoint Jakub suggested.


>
>Thanks,
>Sunil.
