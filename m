Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEFE2CEEE4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgLDNkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbgLDNkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 08:40:40 -0500
X-Gm-Message-State: AOAM532wejPURLcvXkvFysRBQ9/M1w90Ob9xwy4bKeVVGI79AQ7N/eDO
        6ldqvCj012Rd6Jh692+04YLeFzoPzWq4T/xDwXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607089200;
        bh=by+WemB1peGkDQCzG6Dx4fJiZpkp8EyT9CK+EgBPFBY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P9fqTJYnovZ7CqWKNLPqp3JDvu8xXsPnj8jn7pH6Ug+r6FzupbvR7zlfXpYzya5ML
         7KZYDSndDV+ef+CoikM2o2unFtRjbLfdufK9+/KzZxjYljiz4wWL/IjWEHAk/jys8l
         aRSHgr8Uh8xIhFkeeyYYN27zubt95Eo8486/2WJfqU/82Sgk/0tJnHPhx0DznvKKi4
         MGRAAOeXXyQAzrg45t7PuZdJKIcAFCxgz9MHi6PKEHznUVSyAaedtuVtkUzDuMGAnP
         qxoGHLfxboturzy9mux7mUlcKbEouhPhHp4AbW+Nz/+UnfHgIcgzTe/Q8DwQRqjW8h
         FuyUpmicxAUEg==
X-Google-Smtp-Source: ABdhPJyVvyTGM7IAyI/w7/Qek6izIlhZgoKlo/DKiQITg//JIDtXfBeRI4Dxv4lRMr11iPKdROVTob8oGvClJSg0LxU=
X-Received: by 2002:a05:6830:22d2:: with SMTP id q18mr3651139otc.305.1607089199092;
 Fri, 04 Dec 2020 05:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20201203232114.1485603-1-arnd@kernel.org> <20201204110331.GA21587@netronome.com>
In-Reply-To: <20201204110331.GA21587@netronome.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 4 Dec 2020 14:39:42 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0Ncuo6yq2rPpB6wV_r8B87qZ3Ba7to1zdM_BL++j0ksg@mail.gmail.com>
Message-ID: <CAK8P3a0Ncuo6yq2rPpB6wV_r8B87qZ3Ba7to1zdM_BL++j0ksg@mail.gmail.com>
Subject: Re: [PATCH] ethernet: select CONFIG_CRC32 as needed
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 12:03 PM Simon Horman <simon.horman@netronome.com> wrote:
>
> I'm slightly curious to know how you configured the kernel to build
> the Netronome NFP driver but not CRC32 but nonetheless I have no
> objection to this change.

I ran into one link error on a randconfig build and then tried an 'allyesconfig'
configuration, turning everything off manually that selects CRC32.

Working through the resulting link errors ended up being more work than I was
planning for though, so I don't recommend reproducing this. I have another 25
patches for other subsystems.

       Arnd
