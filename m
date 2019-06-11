Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556AA3D592
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391772AbfFKSfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:35:03 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40957 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388207AbfFKSfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:35:02 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so6903030eds.7;
        Tue, 11 Jun 2019 11:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtWdQJ9LEITnrhrHl26XNWq7Hb7t+LrK5A39rgpFt0s=;
        b=jMowBwbsSVJmS3jexAjSfrwNoteJgOUFfp/90l7wVQ1JRLGnCmM/d0mVbkKEa7UbRA
         0mqvDNg5i/f4rdZLtjXOPGZvAzLRElZQprG5GiHWhf8L2K2vY+47xzs4OP4ks4QDB+oB
         hrrbrExvx6PfJAvzQJL58VjuyQNcEDR+nVFRwn4z7AoLEWeI4GKTqYUQLDDd4mzXEvwv
         PjrhIMC+9t2n9ppYwLX3uvWbCHUgsVadNHAYCnr3vcORnmhgPm30Y9iFRNqaHuBaXKKB
         jOcwDurtYVBHMTlPgFh1PsZeucPWDdhEMlqA5zw3k6SMTFxNOi9UbSEKVd58usgRep78
         VFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtWdQJ9LEITnrhrHl26XNWq7Hb7t+LrK5A39rgpFt0s=;
        b=DKEUgUis1PRjJO9+tpATXo5dywxK8Hj9WWJOCIp7kNbatI1FJUrHaham4aixacK6XA
         Em3VWiIR566QUcMTrKcCWY5IN5pj5Zdsh5wD4on39tgkI4TI5hm+jfJmNtyvK/+EhfKM
         zdf/q4JrirWimVbSwZOffcJhtUoqbDuCiuKFdhPbyLfvYDdkKkOazbLT9e8ABC4oDmPN
         xpy99LzWO5H7JkybDVeVm05f+hHKKiQSaNGzC/+3sl6iNdFgLB3YEMv2FsLk5mxG48MY
         vku6z7kxSOpH5kyLKz0sG8w86g+JDUm7p/qDhWMk/cNCjRNRIGuFakmElXV+C+x9g1i8
         WwyQ==
X-Gm-Message-State: APjAAAW/8kfNwruMwNYvTWlRq76ltkItobz1WmiBnRrBU8BJIUs+UCCE
        /EXNQ8Zj3DHuGfqB66kuq0IjS+vfS/6EOL5CCJrOyQ==
X-Google-Smtp-Source: APXvYqx0B2gl+9W10GKRrcOR9BLDHAADqb6X2KNcMm/rCC1BIz+gJMNGCJzv1jgg9DS8LnzHVwN6HIn3k7ZdzzL1KDs=
X-Received: by 2002:a17:906:c459:: with SMTP id ck25mr23323206ejb.32.1560278100761;
 Tue, 11 Jun 2019 11:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190611192432.1d8f11b2@canb.auug.org.au> <12e489ae-d3d9-0390-dee7-0da6301fdcf8@infradead.org>
In-Reply-To: <12e489ae-d3d9-0390-dee7-0da6301fdcf8@infradead.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 11 Jun 2019 21:34:49 +0300
Message-ID: <CA+h21hqw83c9ZHtQ7NwscGRZUNFwTA9RuUAafnjjkcY4FEGwAw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 11 (net/dsa/tag_sja1105.c)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 at 21:30, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 6/11/19 2:24 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20190607:
> >
>
> on i386:
>
> #
> # Library routines
> #
> # CONFIG_PACKING is not set
>
> ld: net/dsa/tag_sja1105.o: in function `sja1105_rcv':
> tag_sja1105.c:(.text+0x40b): undefined reference to `packing'
> ld: tag_sja1105.c:(.text+0x423): undefined reference to `packing'
> ld: tag_sja1105.c:(.text+0x43e): undefined reference to `packing'
> ld: tag_sja1105.c:(.text+0x456): undefined reference to `packing'
> ld: tag_sja1105.c:(.text+0x471): undefined reference to `packing'
>
>
> Should this driver select PACKING?
>
>
> --
> ~Randy

Hi Randy,

Yes it should, thanks for pointing it out.
Are you going to send a patch, or should I?

Thanks!
-Vladimir
