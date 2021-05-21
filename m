Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA33E38CCBA
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhEURym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231520AbhEURyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 13:54:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0FB0613C8;
        Fri, 21 May 2021 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621619598;
        bh=Er+NXLgCY8URzy9UTDvMM1p03wWP8IRW82T7YXvfXXI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JYx7L0Ptk0b+NeZ5otbjUJqGAhjiVjxdhC8QTsA4u9xxbM11RGAHU1Rlu5qYsmhEK
         PHK4jYVKSz8wZIDCxOs8ErjAaEZ+A85AU6z9+3XTXmGb4SefLYa19OOWJGWx9D15cI
         uYKzddQT845Gmdn19h/nG8lDenrpYthzQ/jRg07cXqiICswoO8VMXs9iA+dFckHmDi
         hFl4q0x6vyQlXOdhQIQqSNkefNXGvzob2OC43Hj3Ef4sLvCiCqdaZ8DljAkushu+pE
         XAKZZPKRjwmugwMv3i/VXkw70NiGW5xBb2aAXKKJ4yXQ0dmBkIJGi1Sjz7VIraEUWe
         jH7VVuXz5nPJw==
Message-ID: <1426bc91c6c6ee3aaf3d85c4291a12968634e521.camel@kernel.org>
Subject: Re: AF_XDP metadata/hints
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Cc:     "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Zhang, Jessica" <jessica.zhang@intel.com>,
        "Kubiak, Marcin" <marcin.kubiak@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "Maloor, Kishen" <kishen.maloor@intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "Plantykow, Marta A" <marta.a.plantykow@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 21 May 2021 10:53:17 -0700
In-Reply-To: <20210521153110.207cb231@carbon>
References: <dc2c38cdccfa5eca925cfc9d59b0674e208c9c9d.camel@intel.com>
         <DM6PR11MB2780A8C5410ECB3C9700EAB5CA579@DM6PR11MB2780.namprd11.prod.outlook.com>
         <PH0PR11MB487034313697F395BB5BA3C5E4579@PH0PR11MB4870.namprd11.prod.outlook.com>
         <DM4PR11MB5422733A87913EFF8904C17184579@DM4PR11MB5422.namprd11.prod.outlook.com>
         <20210507131034.5a62ce56@carbon>
         <DM4PR11MB5422FE9618B3692D48FCE4EA84549@DM4PR11MB5422.namprd11.prod.outlook.com>
         <20210510185029.1ca6f872@carbon>
         <DM4PR11MB54227C25DFD4E882CB03BD3884539@DM4PR11MB5422.namprd11.prod.outlook.com>
         <20210512102546.5c098483@carbon>
         <DM4PR11MB542273C9D8BF63505DC6E21784519@DM4PR11MB5422.namprd11.prod.outlook.com>
         <7b347a985e590e2a422f837971b30bd83f9c7ac3.camel@nvidia.com>
         <DM4PR11MB5422762E82C0531B92BDF09A842B9@DM4PR11MB5422.namprd11.prod.outlook.com>
         <DM4PR11MB5422269F6113268172B9E26A842A9@DM4PR11MB5422.namprd11.prod.outlook.com>
         <DM4PR11MB54224769926B06EE76635A6484299@DM4PR11MB5422.namprd11.prod.outlook.com>
         <20210521153110.207cb231@carbon>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-21 at 15:31 +0200, Jesper Dangaard Brouer wrote:
> On Fri, 21 May 2021 10:53:40 +0000
> "Lobakin, Alexandr" <alexandr.lobakin@intel.com> wrote:
> 
> > I've opened two discussions at https://github.com/alobakin/linux,
> > feel free to join them and/or create new ones to share your thoughts
> > and concerns.
> 
> Thanks Alexandr for keeping the thread/subject alive.
>  
> I guess this is a new GitHub features "Discussions".  I've never used
> that in a project before, lets see how this goes.  The usual approach
> is discussions over email on netdev (Cc. netdev@vger.kernel.org).

I agree we need full visibility and transparency, i actually recommend:
bpf@vger.kernel.org

so we wont spam the netdev ML.

> 
> Lets make it a bit easier to find these discussion threads:
>  https://github.com/alobakin/linux/discussions
> 
> #1: Approach for generating metadata from HW descriptors #1
>  https://github.com/alobakin/linux/discussions/1
> 
> #2: The idea of obtaining BTF directly from /sys/kernel/btf #2
>  https://github.com/alobakin/linux/discussions/2
> 



