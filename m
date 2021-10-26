Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F09543AC7B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhJZGz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhJZGz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:55:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF363C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:53:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x1-20020a17090a530100b001a1efa4ebe6so779278pjh.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:to:cc:subject:date:in-reply-to:references
         :content-transfer-encoding:mime-version;
        bh=fIt4yWK6oNbLe5r4ujDi0tqyYk3dKLvG+e6XdUrf5sw=;
        b=eVJPbTVKX9l7pkqqE5YJUcmhCcfubsvKsB1PoKiZcyHaoSdrRCfX8a4oOhODq8qxQJ
         lN7gFRUUgPQKi2iiWQEDyM6t/uVUWg7rCm+xGshc5UiWzIdK6P5pSY3Rf4692FCBaEG7
         9YFFT8RDOGwqrLqb42Uk85IxekeTQM6sZ3EbB35nz9lA7+MtNdcIOsKug4GZ3i/gGw4h
         5RovJSPXfpKIFaWVfrDtqmnSl5mNeLV4kaJN6pttn6Ds15y99E3aJN/ZXjEXcYTUb0JV
         HZ+Z/l7qbg9Qb8p+KgJVf1p+wRTyGEPb/f4508ypTgTVlVDSlvIMEGv6+A1DCyRIMjMl
         ZNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:to:cc:subject:date:in-reply-to
         :references:content-transfer-encoding:mime-version;
        bh=fIt4yWK6oNbLe5r4ujDi0tqyYk3dKLvG+e6XdUrf5sw=;
        b=Qc6kbU49g03/ISeNcmWCFyhXycOmJGk7PX8yGBHpJtTCU1ZnN0dM688lPv1AyjZIHJ
         dj88d61NqCP28SN68vrII494dKC/FLqSLYniWy5PEwnG1hlfKMWKeuqJzQ+wHTFSzzuB
         J5A+sl0L8HP2o1NQ+3FukUFVpG5rRJmrlQdLNr1l0ARuQVSeBzUjjs7spizEkHH+sw8c
         F7bVWasPs81sntbDhCLjZwHwez5j+DlNQqQZzKkadWG+e27OaKFfcd7qlpwLcTLJaxL4
         OkipK+/jXeBvn5l7ZB2PRybwgqQ4hEXYtXF1KmoVIszD+l+yqUcQIoNShmq8u8nVo83q
         oZmQ==
X-Gm-Message-State: AOAM533vbaThl4KMis8lDHFPetPzAmnuE5hHUoBhsr/1pkE+4dkvvvKf
        IzJEqwess8vWd/J4Ez27mQ==
X-Google-Smtp-Source: ABdhPJzMALdXMZQVg2JuXeRHTb9LoPRxTXarciRFkswXHbEdXARpSxLPMlQRi/w3zN7zfnM7crPC0g==
X-Received: by 2002:a17:90b:17c9:: with SMTP id me9mr26564585pjb.197.1635231182379;
        Mon, 25 Oct 2021 23:53:02 -0700 (PDT)
Received: from localhost ([114.201.226.241])
        by smtp.gmail.com with ESMTPSA id j15sm16017530pfh.35.2021.10.25.23.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 23:53:02 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed
Message-Id: <1635230861236.3613504193.3943068936@gmail.com>
From:   Janghyub Seo <jhyub06@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     nic_swsd@realtek.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Add device 10ec:8162 to driver r8169
Date:   Tue, 26 Oct 2021 06:52:46 +0000
In-Reply-To: <20211025180105.703121f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211025180105.703121f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tuesday 26 October 2021 10:01:05 AM (+09:00), Jakub Kicinski wrote:

 > On Mon, 25 Oct 2021 14:55:43 +0000 Janghyub Seo wrote:
 > > This patch makes the driver r8169 pick up device Realtek Semiconductor 
Co.
 > > , Ltd. Device [10ec:8162].
 > >
 > > Signed-off-by: Janghyub Seo <jhyub06@gmail.com>
 > > Suggested-by: Rushab Shah <rushabshah32@gmail.com>
 >
 > I'm not 100% clear why but this patch does not apply to neither of the
 > networking trees. Can you please rebase on top of this tree:
 >
 > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
 >
 > And add a '---' after the lspci output, maybe?
 >
Sorry for that, thanks for pointing out.
Will submit it again very soon, thanks.
