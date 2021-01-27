Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D8306345
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343975AbhA0S0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbhA0S0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:26:33 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F616C061756
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:25:52 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c2so3601668edr.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLyrvcYAcVBo96ljLF5luMNiswU83i/YP1ssz+Pdy0w=;
        b=BD4Y1PPT3WKrLZSvdaQDB0J+DGgLfStzKkRLKSPdB37wskxvMj1eccwppocHehvf+s
         j1EdCmZccauNP8YVIScplGu+11mNGLehYlmJAmhXtdirND7K+qwKVFAlhBYLofZ0MlOv
         tj6EjC5qoH0i7yfMkrlHBeRhu9IUenbLeDzbsa8Xk80nlj6y5JlWTvOlqCdRGoASsN4O
         L0YoBuwwisTY8Etu4Jgjy7QpvcgSFp8KqixG8QdcWwc7qcT5nz3jO4LzigISEtWzRwcB
         nWEpX8u3/++xee/JyfJ3tUX3os7q7NrKvV0SDpF3sNc8s1FJBbgui8RtYCoBizm5Elos
         iifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLyrvcYAcVBo96ljLF5luMNiswU83i/YP1ssz+Pdy0w=;
        b=K0yz4sfNDhe1RsayYZVUrdLu68o0iEY2Eieb89uJ8TPFzeghvIDqGKfBzgwS4e23jW
         mqUf4ocQWX/ENIOxsYjTp7xBOBIZAeOjyiiqZuK13M7BT0H9BFzAifvPR/PbD22g2y5C
         V3EiWOiuQQvq/B56nytyBR8ZU20hrMMPdQkVWAstLtZPIHmDHU4HtJJl/k1yeY7jIv7n
         WD96XyHtXSlgGp9jxUI5pZS0Gff7xtiaXJYhE3GAgGr8ouRA+tE5JsJ0WZwPxQezV3uD
         Mc3N8EHgXm99l2c10o0ERtqZgzhJGOBZznJk3SOt5lVzs+1t/syfA97nSEp9MXU0aZiD
         KIvg==
X-Gm-Message-State: AOAM5303h8Nyony1rCHpCyuEZdO8PW2K6ZNAv51OkDvUTd1TyDG42k/B
        GTTZ0qxG43YXpFqsXXd0Ugr6c/pApjbfu7JItTA=
X-Google-Smtp-Source: ABdhPJzUKVGjF/Y0j96rC7JLKWYfAQGxp8BUZm+Dl3tupqF1f1b2ImlNjzF0Kp3DvixAaE3NgoxKoem9mq4Zagtf0+Y=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr10586998edv.254.1611771951121;
 Wed, 27 Jan 2021 10:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 13:25:14 -0500
Message-ID: <CAF=yD-LXi1PFPD5QGD+dfjD6ynDk1Q1J1xWfcQgoyAHQJqryTQ@mail.gmail.com>
Subject: Re: [PATCH net v2 0/7][pull request] Intel Wired LAN Driver Updates 2021-01-26
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:15 AM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> This series contains updates to the ice, i40e, and igc driver.
>
> Henry corrects setting an unspecified protocol to IPPROTO_NONE instead of
> 0 for IPv6 flexbytes filters for ice.
>
> Nick fixes the IPv6 extension header being processed incorrectly and
> updates the netdev->dev_addr if it exists in hardware as it may have been
> modified outside the ice driver.
>
> Brett ensures a user cannot request more channels than available LAN MSI-X
> and fixes the minimum allocation logic as it was incorrectly trying to use
> more MSI-X than allocated for ice.
>
> Stefan Assmann minimizes the delay between getting and using the VSI
> pointer to prevent a possible crash for i40e.
>
> Corinna Vinschen fixes link speed advertising for igc.
>
> v2: Dropped patch 4 (ice XDP). Added igc link speed advertisement patch
> (patch 7).
>
> The following are changes since commit 07d46d93c9acdfe0614071d73c415dd5f745cc6e:
>   uapi: fix big endian definition of ipv6_rpl_sr_hdr
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE
>
> Brett Creeley (2):
>   ice: Don't allow more channels than LAN MSI-X available
>   ice: Fix MSI-X vector fallback logic
>
> Corinna Vinschen (1):
>   igc: fix link speed advertising
>
> Henry Tieman (1):
>   ice: fix FDir IPv6 flexbyte
>
> Nick Nunley (2):
>   ice: Implement flow for IPv6 next header (extension header)
>   ice: update dev_addr in ice_set_mac_address even if HW filter exists
>
> Stefan Assmann (1):
>   i40e: acquire VSI pointer only after VF is initialized
>
>  .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 11 ++++-----
>  drivers/net/ethernet/intel/ice/ice.h          |  4 +++-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  8 +++----
>  .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  8 ++++++-
>  drivers/net/ethernet/intel/ice/ice_lib.c      | 14 +++++++----
>  drivers/net/ethernet/intel/ice/ice_main.c     | 16 +++++++------
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |  9 ++++---
>  drivers/net/ethernet/intel/igc/igc_ethtool.c  | 24 ++++++++++++++-----
>  8 files changed, 60 insertions(+), 34 deletions(-)
>
> --
> 2.26.2
>

For netdrv

Acked-by: Willem de Bruijn <willemb@google.com>
