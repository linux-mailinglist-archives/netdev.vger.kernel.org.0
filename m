Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184E330B3D1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhBBAEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhBBAEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:04:20 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116EAC061573;
        Mon,  1 Feb 2021 16:03:40 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id k8so18171134otr.8;
        Mon, 01 Feb 2021 16:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=37pynsMAQx3bXMKrumdsATxdXJWb85qmhwgI2jnrHk4=;
        b=DIRtUvIpx08YmXkbFBlMWDnbLx6noy+35F+dgPKt0nG69KPoOolr0APkj/vLZebqyM
         CfEi1QS8f0cUnOHnQTaOMqn/UGjDa6onie/06TAHgxv+LWdfWv9lOSs7rUZbvgcelmE7
         3xMQdvY1203NKQrIqzpdhHioMUqIvZTN4x0cqigbGyw1vjb9EFkX2oqTgpZDBwmFs4Li
         u/w/eRx+ZxLASeDbsrYqdliRW43g0U3TTKFME4cPczQ5B4CazVg+bMmlrYN+D+oxWfnN
         2LDpFKRMtBB6Zr43NehXsb9EEWyR3yT2XIPPLNgFAdHO2HAnJ2PQnbFeFJFj8G/kGqWE
         MNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=37pynsMAQx3bXMKrumdsATxdXJWb85qmhwgI2jnrHk4=;
        b=CNULjUnijdn59D4PkLq5ng/cquR7vxS7pdx91DCxjpwiIpKjcgfiz4MXHX3P8zDzr/
         BW6FiVrKfyX1xrKWzk4gdWV7ij7hIdgH0ZMMJUPseSKMx7kDS1+DxzKM0AfO3ysXhzAk
         qnKKgPlr3vJ6JjNkvztHt5OAxzYOWl/SaTPpDY8ZmQjeC3nRetpzN9u0u4iHgIkyBl/i
         CNgXNOnmtySGlgL8rUYVWWbqrUEr1WekBwOc0hhOZyu679A/61v8qIwi4FkHonvCBgYo
         CNO4xOEuOrHhlYMhBSglqYGOenrZn4BOh2RUVPqpbY245icBgXTuG/tvTrAdkl+CyU4y
         3uhQ==
X-Gm-Message-State: AOAM532Iwm/aZeotB1S5zo8Ll88F9Cxfzls6IFiEMMyj1CN8WFhAAihd
        rR9ynHQEWdL6A/eeU58KhG+xpRmkXeCSf3EXpsc=
X-Google-Smtp-Source: ABdhPJxVf/uxXcihOHt+fv9aodaCiGp1tWIfZ1FIbvwctTZzHCizFsnO1ZnOSQzbkanBGzy+nxOxM+kX77eexYFrGfQ=
X-Received: by 2002:a9d:1421:: with SMTP id h30mr13793728oth.45.1612224219576;
 Mon, 01 Feb 2021 16:03:39 -0800 (PST)
MIME-Version: 1.0
References: <20210201232609.3524451-1-elder@linaro.org> <20210201232609.3524451-4-elder@linaro.org>
 <CAE1WUT6VOx=sS1K1PaJG+Ks06CMpoz_efCyNhFQhD83_YNLk5A@mail.gmail.com>
In-Reply-To: <CAE1WUT6VOx=sS1K1PaJG+Ks06CMpoz_efCyNhFQhD83_YNLk5A@mail.gmail.com>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Mon, 1 Feb 2021 16:03:28 -0800
Message-ID: <CAE1WUT7Q5NGSYbhwidmfV3bjTg0pme9y6vMbFsN4UtvgnGrDhg@mail.gmail.com>
Subject: Re: [PATCH net 3/4] net: ipa: use the right accessor in ipa_endpoint_status_skip()
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 4:02 PM Amy Parker <enbyamy@gmail.com> wrote:

> > Fix this by using u8_get_bits() to get the destination endpoint ID.
>
> Isn't
>

Apologies about this - premature email sending. This was simply going
to be "Isn't endpoint_id u32?", which was addressed later anyways.

Best regards,
Amy Parker
(she/her/hers)
