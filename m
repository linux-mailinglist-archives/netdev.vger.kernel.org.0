Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE92369992
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhDWS2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhDWS2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:28:35 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C981C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:27:57 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a4so49296952wrr.2
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81ASQZgB4Dy/BIympMVKRDum3pP038MVLFsF/wx4ItY=;
        b=F+hFrfakN2nmuhrBN0YaWTrT0Y+nuLHo8VXIqdiQhg9EIq1BJfVyAlqrvOkBeps7bc
         iUgFWmLb00N2y45GimVdrT5siTiH+d+eXI42OpHn5lbB5VnRJrv9IU8Q1zOO3I5c9vbo
         GFciVgrTkJsqzEbyrmWrFOM9ManChl3RMkxs9f7ltgqtI8chXcpX4djqWrv3tdzQkL3V
         CDLY5NbZmdrRU5iUUpnfWj7BThshBN7cZ1k4Alfey4BUecAEtk/xzVD2BZzAYgP4womS
         hc6wxi4nMqoLpGMhzzcdNlLU6D1OaOiudXsA9bJ7bwgqtbPjYoWFETXo3+PTdD48Bjdo
         0cNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81ASQZgB4Dy/BIympMVKRDum3pP038MVLFsF/wx4ItY=;
        b=L4b8S+DlgfsMjdzP1wA4Jzfqb8KksPjtz8yxmiP82CtVmzl3DblOwi/5Ew0yyNKAq7
         RQChunzEXlVTkLCuXPydlLTtuaHkmK7FaVKh8LQZqwLppGfypudCFNv2LMPOOip8f967
         6IJ4x8/8jrvOocJzI/enU4W5PXlNSDt8MkkPivWbXnk2q+aaaFN9258keNToJgA2gD/b
         iqlJVpox2Gb16cBPW9VD/zjNmx63+fJQBUtZvuTPKKq9IE9fRgZ2B9gRl4QcSGl7WJNd
         a65nvhgIRfIFCcc5EhHB9OoozgWVGvoGUDIJHPOkYPNQFUIe26oX2CsK4ZRlQdWTGWca
         PsZw==
X-Gm-Message-State: AOAM533Rw6AYQRZo+tDXCHMHeEuzw0cSwaEXX8n3bp8djTwmFhPhQFa5
        isHxVe4wTGmbgXJN+R1WP9P9JFwwCh8/u6z0XYJY9vMAI+A=
X-Google-Smtp-Source: ABdhPJw2wo35K3xvPjCXd8hgR6d4GpcDzTmEDWHTGtdjCUIt8jkYZeFkVCFcDBs6/V1uQYLzWKwxRRiGgpy1B8PGvGA=
X-Received: by 2002:adf:f787:: with SMTP id q7mr6331396wrp.351.1619202476458;
 Fri, 23 Apr 2021 11:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+sq2Ce+AW3HUhqxa2Q9+2G0BGTnjuzLdnLLBVfeY=_0s6dANQ@mail.gmail.com>
 <20210421103012.45a3a64a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210421103012.45a3a64a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 23 Apr 2021 23:57:45 +0530
Message-ID: <CA+sq2Cfo4cWGO9buf7uKJrn1SuZF9USFTc4VeQUpus=0cGmUNA@mail.gmail.com>
Subject: Re: How to toggle physical link via ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 21 Apr 2021 18:12:16 +0530 Sunil Kovvuri wrote:
> > Hi,
> >
> > Have a query on how to bring down physical link (serdes) for a NIC interface.
> >
> > I am under assumption that for a SR-IOV NIC, when user executes
> > "ifconfig eth-pf down",
> > it should not bring down physical link as there could be virtual
> > interfaces still active.
> > Let me know if this assumption itself is wrong.
>
> How VFs operate is really implementation specific, so it'd be
> interesting to hear from the vendors but IIUC bringing PF down
> should shut down the link.
>
> What usually keeps the link up is stuff like NC-SI, but not VFs.
>
Okay.

Thanks,
Sunil.
