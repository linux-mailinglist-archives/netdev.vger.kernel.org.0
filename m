Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F22F431AB7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhJRN2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhJRN0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 09:26:45 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC94EC061745
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 06:24:32 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id t4so24288729oie.5
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 06:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8CLYhW6GTrGH5Yaoml0vSIssIKQ3YLdG0P03rWgOOM=;
        b=bYnC9qhb57hsrWZekNRoVcG7en/rBvAgPspyiAb/unCLPEEOz3Nbzhk4kAsloSjqYR
         D4GqoxF4zoHr3PkLabufKBtrxquuBFVO3WMNUIapHiXsGVXNYydrTfRPxRRx2sb8iWgv
         VXP0+RqYgA7CGBvBMTWjlDQntwZlbyXvzvgRn+ZwOKPTLhdOohia8mLb3dvIBrf+cXSB
         iuIWnjAN9TmFDO5pjGLByuTkbmlzyX8XaGq7JL1YqfXMuHYuy6ctPXnTekiUnvL7LA9E
         CM0Z8yIcVPAm/B6OGd+0oPx8uD0hqx5lVsYoZLbR1Esi/3bnUtc4QVR78qJ86s3O2N1h
         c9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8CLYhW6GTrGH5Yaoml0vSIssIKQ3YLdG0P03rWgOOM=;
        b=5pq6biD/PBKrJC8q2686imtL/GuhXttckMxI2BNP02EThOqctqPK1NsNrDzJYAEV41
         Dl4xrWVfQEKd8QdavM+MB2HA7Xx7XoT2+f/yu0YDdeZlawsMihbXdpqY3WSgW1eeB8iF
         ts+eEDj0C+3eCHFJEQPVvCrxy5GCCjX51c7dBN1GHWayjw/u3MI3FWuALqxBdbsJLxu+
         DTsRRAjjikpf2a61GTlJOo9ms2G8vGUCir0I0y5aWk8SZxCK/he3JHFCfmt/vV/U6xGr
         NURFmBkmYuWL5K8075uD/axxwA7jAie9UviFhLQf0SksemVH67IvRCvrpARK1Q0OpU6u
         4PTw==
X-Gm-Message-State: AOAM533pO8LBmMiSx2MFyTUQ44NO1npC60wKanMc2FyU3XX4J1X3gv3e
        Oo0EATsIWu5nRvB6BBppRhEllWnUkWrYmMbhIw==
X-Google-Smtp-Source: ABdhPJxR5x9jOjRLB9UB988Rr49Il1FWqnHL4FGzittV/JzO2OW2uP52XeqxTyPcxBDROkdO8IXbpMoaPGTQn63yAQg=
X-Received: by 2002:aca:3bd7:: with SMTP id i206mr19856777oia.166.1634563472286;
 Mon, 18 Oct 2021 06:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211014130845.410602-1-ssuryaextr@gmail.com> <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
 <20211015022241.GA3405@ICIPI.localdomain> <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
 <20211015130141.66db253b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <372a0b95-7ec4-fcd9-564e-cb898c4fe90a@gmail.com> <20211015162953.6fefeb4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015162953.6fefeb4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Mon, 18 Oct 2021 09:24:21 -0400
Message-ID: <CAHapkUjr1K4RKQoJDGbzVHHyZnV9-9pMv949t9x9WuSZCCY_vg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig netdev
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Could this patch be queued for -stable?
Thank you.

On Fri, Oct 15, 2021 at 7:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 15 Oct 2021 15:28:00 -0600 David Ahern wrote:
> > >> oh right, ipv4 is per net-namespace.
> > >
> > > Is that an ack? :)
> >
> > Reviewed-by: David Ahern <dsahern@kernel.org>
>
> Thanks, applied!
