Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8EC3DE05B
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhHBTzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhHBTzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81A5D60FC2;
        Mon,  2 Aug 2021 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627934138;
        bh=cVytQA6EX9oGtoKcTVDW79o4l34eFJ2YBlkkc+kXI2A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NsHOZLCCNumX/gmwuO0BYBHeQ8gG5g/RTmEEkuN93Z01l5BHRkKKAjaXSGkGgEgYv
         wD5/Q/c4VZtc/DEKBVWGlrgO3drQbMT1InVaqop+wfjZjOKMCYcfpakgIJ+4onH25G
         3Geosjhc+UhHjKGo7H6QBsJxpSfX11ykAMheB0dI+VgxF0XF7cmfxl94eZsTZCqdF4
         UnfawkjQa5tWlVfC0QZjhJHdb74rb8wE4FZROgwOPLoTFRj/pc45UoY7hakYwWoFzO
         vZg6nQ3BwslyGEbozKl5YA79xTz+vF27tMZJstWogeDMd3TTgWCzKBABanodqtcZx8
         cdmPzBCGzjArQ==
Received: by mail-wr1-f52.google.com with SMTP id h13so9306007wrp.1;
        Mon, 02 Aug 2021 12:55:38 -0700 (PDT)
X-Gm-Message-State: AOAM533lACi3MdS26xvzh8WfNCqdUcifCBwxxpy7xLpHeKTJR3HXT9dO
        IQZS0RV1dJ82RMYDFvhHg9cWu3MG1b+gWa8SQTY=
X-Google-Smtp-Source: ABdhPJyQNjnvZGzfhME5WPGj2hKYZ1RGTVy8Wr8dYYbi6BXsyVgtq5/YDBKpZh5bD2QmOblvRBjO61Q3mcK+2i11w1c=
X-Received: by 2002:a5d:44c7:: with SMTP id z7mr19903358wrr.286.1627934137123;
 Mon, 02 Aug 2021 12:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210802144813.1152762-1-arnd@kernel.org> <20210802162250.GA12345@corigine.com>
 <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com> <20210802190459.ruhfa23xcoqg2vj6@skbuf>
In-Reply-To: <20210802190459.ruhfa23xcoqg2vj6@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 21:55:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1sT+bJitQH6B5=+bnKzn-LMJX1LnQtGTBptuDG-co94g@mail.gmail.com>
Message-ID: <CAK8P3a1sT+bJitQH6B5=+bnKzn-LMJX1LnQtGTBptuDG-co94g@mail.gmail.com>
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 9:05 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Mon, Aug 02, 2021 at 08:29:25PM +0200, Arnd Bergmann wrote:
> > If this looks correct to you, I can submit it as a standalone patch.
>
> I think it's easiest I just ask you to provide a .config that triggers
> actual build failures and we can go from there.

This one is with an arm64 allmodconfig, plus

CONFIG_PTP_1588_CLOCK=y
CONFIG_TI_K3_AM65_CPTS=y
CONFIG_TI_K3_AM65_CPSW_NUSS=y

       Arnd
