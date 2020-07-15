Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD363220253
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGOC20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgGOC2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:28:25 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C961C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 19:28:25 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a1so432629edt.10
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 19:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NzQjEy96mwvK5RqK1HselxgI2oA5I911Qdx2GNiQhg0=;
        b=pd8yJsIzUV+lmtpXyBfCDr7n3+H80zSFriHlcIPUQEshJKvvGy7eE8F14z2Me5kfma
         VchPpX69Esx3VqPLBaPtWBzKR87WMmuAAWVk6Zxbb59t8akiJqxXSK2gY6bFjn29yKdB
         u5gQKb2NXD0jidguQUC5MRpGj0zHsrpcgQuBsGynE5bZ8s9cVj6Q8jAbJceW4ZopqgQo
         IvkF1Gx536gA5Y4BkC0O7XTgAUc4PVIK4icnKvo1lQlDCDz3x4NjAf2shtmOTNMFbH8c
         +IGUMuuj3R2wNaCqM1RuDMeE1vo+SB1yNukyNP1BaeyfimEuy9EkvDvAtPydf4lgXJ5S
         7CCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NzQjEy96mwvK5RqK1HselxgI2oA5I911Qdx2GNiQhg0=;
        b=srPGkpUPI3xfNCiJRUra+5gs/p3DLZ50ZWHhNOSa5YSgS6/Nzq+P7+MIFj37kantaw
         wEvKHnmore55vLuTUrVYmWsaEqHtyfUHTjX9KU4Gdaown3przv14dzJGvgO3CvGZQ+1Y
         /Mh9Z/SHDrN1CwBURU5dN4vl421Iq04B3Y+n/NaMaV3OI8a041601MzEGchoTxEbOJod
         t9GBd9KhjFxAnHF/JzSd1sMX6xUovcACLxD5xL3Lmz5MWW7FucKTvre0yPfLMIqyyxUT
         Xmgv99K6kCsJjKQDk0vz0pxB1+NvWbl+r/ioJWnfuyuP7+iFTH4I7ua/U5Pl0DxzpgX/
         qO/w==
X-Gm-Message-State: AOAM532EUozt3SjO/01oEQl2DHLIsGqBkeJj2sN2QSqKiYZ7CMlgs8IH
        Z8uLAGp/yNKVH1yaDaCk83aLwVntMhiGJ4uBtAqt
X-Google-Smtp-Source: ABdhPJwC+iS+MYu3jbSKussTXFfhjkiopLyiCmfWTihVgPblMmDRROS4S+1ydwyZ0bTIgA2yjuH02BgGUJUMI4Q0zDU=
X-Received: by 2002:a05:6402:742:: with SMTP id p2mr7142885edy.135.1594780103839;
 Tue, 14 Jul 2020 19:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200715021846.34096-1-yuehaibing@huawei.com>
In-Reply-To: <20200715021846.34096-1-yuehaibing@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 14 Jul 2020 22:28:12 -0400
Message-ID: <CAHC9VhTPhtx-t7_WucUyKg=y1g_0OiFFs1RdvfuixOUoytWmvA@mail.gmail.com>
Subject: Re: [PATCH net-next] cipso: Remove unused inline functions
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 10:21 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> They are not used any more since commit b1edeb102397 ("netlabel: Replace
> protocol/NetLabel linking with refrerence counts")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  include/net/cipso_ipv4.h | 12 ------------
>  1 file changed, 12 deletions(-)

Looks good to me, thanks for the patch.

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
