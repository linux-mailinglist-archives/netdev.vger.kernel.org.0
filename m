Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0C52AC141
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgKIQsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:48:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730419AbgKIQsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:48:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604940491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fqIq5NUwLO5XS6VOJO9c8F79ciX9FemcAwNmtAIcwRI=;
        b=NujbtCCK8KK7ScfBD3D9N7DsW0Cu4S6n8iKhY2Zc3uoFPZ1ZSmfw2IeR49q2Djx08tmvwN
        s8gbrXw8m/p5XT68R8nJH0KPO6kRFCDDX0BrDIVrg66Lv/18ECOfe6VP2SqJoYqAqXeBpW
        NTPNN5IAOLyO6EkKOZM4kN8NT653FVY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-WpBOAhO2NWqb4gk48s_dNw-1; Mon, 09 Nov 2020 11:48:10 -0500
X-MC-Unique: WpBOAhO2NWqb4gk48s_dNw-1
Received: by mail-oo1-f72.google.com with SMTP id t8so2389138oor.19
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:48:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqIq5NUwLO5XS6VOJO9c8F79ciX9FemcAwNmtAIcwRI=;
        b=eUgOIRVQTu/RZNZ40k3AYMZdyFH3hSs4+bnI3z7dv6zmHOKKgU+CBATVW/6uly8hWi
         5A2ml2IaabMw/NCq8kUMS5+lAbuJ/epXOU2AzHNf2Gy08oud2DbUS/ZSFCRFqRFEAjQj
         DTN5V5PXabez8/e/frp1hKeCMR/EymDmrUKzvhsSr1Yn5+JhDwbCkLXJhnRF+4dKTVYi
         qUlkQnpSJk9rqv+gBtGcq1KserIK3+/QEdmbnHN+y12NT1SlyyMRxNFY0Crge/TxryFu
         SQR3QP8hDH1SacuhRMkRzEr6e1vCFS5pWKGODVi06q8thDrdITjiggILcPZrBcMqOYqj
         AmGQ==
X-Gm-Message-State: AOAM533HCfJeLqscaH7P7ngfY7Tqk6RkIP9di+klap/l+T/MzZzyU7eh
        Sf3BQaNaYnEK7SQtqAYbTBD3JbO1cJGjKplN+O2BUzRM0Ea9FXY+yvjKFk3Jq+FHk1c7/wlcTkP
        FFJqoLcHYi8TCilQNcO1S7iiVW9+r2jzA
X-Received: by 2002:aca:4f53:: with SMTP id d80mr29981oib.120.1604940488744;
        Mon, 09 Nov 2020 08:48:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHFiGAk0galmy0bk5raHPkH/pu4uljJlFq+eNb+KPxOugkwKoJBdOHvGL6Z37sQJd6iaPMBOkPmw04bQVv+dE=
X-Received: by 2002:aca:4f53:: with SMTP id d80mr29973oib.120.1604940488554;
 Mon, 09 Nov 2020 08:48:08 -0800 (PST)
MIME-Version: 1.0
References: <20201106200436.943795-1-jarod@redhat.com> <20201106184432.07a6ab18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106184432.07a6ab18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Mon, 9 Nov 2020 11:47:58 -0500
Message-ID: <CAKfmpSfkmo1GVVThadDDtXma1m1yrNwPoPz87sMy5664uJbevg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/5] bonding: rename bond components
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 9:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  6 Nov 2020 15:04:31 -0500 Jarod Wilson wrote:
> > The bonding driver's use of master and slave, while largely understood
> > in technical circles, poses a barrier for inclusion to some potential
> > members of the development and user community, due to the historical
> > context of masters and slaves, particularly in the United States. This
> > is a first full pass at replacing those phrases with more socially
> > inclusive ones, opting for bond to replace master and port to
> > replace slave, which is congruent with the bridge and team drivers.
>
> If we decide to go ahead with this, we should probably also use it as
> an opportunity to clean up the more egregious checkpatch warnings, WDYT?
>
> Plan minimum - don't add new ones ;)

Hm. I hadn't actually looked at checkpatch output until now. It's...
noisy here. But I'm pretty sure the vast majority of that is from
existing issues, simply reported now due to all the renaming. I can
certainly take a crack at cleanups, but I'd be worried about missing
another merge window trying to sort all of these, when they're not
directly related.

-- 
Jarod Wilson
jarod@redhat.com

