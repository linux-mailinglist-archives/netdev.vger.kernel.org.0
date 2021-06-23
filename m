Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABEE3B2132
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFWT2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWT2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:28:44 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC6EC061574;
        Wed, 23 Jun 2021 12:26:26 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id j2so5946825lfg.9;
        Wed, 23 Jun 2021 12:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1mws8JTsPd9+atb1/JRjdmcWQnXTwDM12m7T79JCDYI=;
        b=QKbruPrK8+r9Z6CHz8ZcBN91/61A8PbpooA0sGui9NBKFgMuuMLoyIVLMKCtsLHdeO
         O3otQ5Z8TPQ3mNDvuIah4gK6NE2M8mDny2i0V4zqrPkmEBomA/Q7hJUhNY5LSAfNWeyk
         YCakA62FspbPtZEMfcp4uNba1bU/SgJV8zIImpK/P61wRhP8ktrcdMoNxNzCdNm4skYf
         +PJ5wjDyv90wNzAAJe1kLHVXvj+bfKbj94AoZT2J5y2wMi78x/Otyg3O+4MFiv6cdEAh
         wnlBsPoAqJq+QtplRzV921rSgv7G2ohU7KVABXL9i5kisZGcI4U0MgFg/v98SChDv3Ry
         axWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1mws8JTsPd9+atb1/JRjdmcWQnXTwDM12m7T79JCDYI=;
        b=Y4Q4CH8RAxUkXNbL4eFNeNIEkoA1dV+0KyfsoV2DHYSHvxZHTwYg3W2waS7YmuislG
         tCRotPZ3WHKr951I7r4GXuzMGelbxNUBp7pGMkg2sB576qW3tanvyf7qjpxKqFax2TXP
         QJ3bk1UvthbOWj3F5kgKYJzQws+oJFFEveeU1O+T4wZRha8dllKxMTCDT6pE/AjzfJze
         xve3aZdbOJf5OGzcO/fCOqmxbxaaD/hdOQJotXQCPNeDprr8OMOvrJ9cuOnZ5D8GObHM
         bmBO3SaVPfhq4Bxg7nkQlycEK/cb9riLpZUAJQv18SLMnVqEfgAt3OAwfd16zljN2dDK
         G7NA==
X-Gm-Message-State: AOAM532jcjXvprogBhN+oNVL8dTKK4TRuX4mt7IYqytozDcrL5ZwYOK2
        aHcsh+ZU2yDF07+8hmjXp/k=
X-Google-Smtp-Source: ABdhPJx/y3z1NxEj0i19lW89L1QoDy9Hp6WsBpHJ7H8yUQyHKJpyoJlgX9mJBjXKMibgHc5AndiiIQ==
X-Received: by 2002:ac2:4c48:: with SMTP id o8mr876420lfk.332.1624476384620;
        Wed, 23 Jun 2021 12:26:24 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id p5sm50912ljn.109.2021.06.23.12.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 12:26:24 -0700 (PDT)
Date:   Wed, 23 Jun 2021 22:26:20 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        Yang Yingliang <yangyingliang@huawei.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: ath10: add missing ret initialization
Message-ID: <20210623222620.06b6335a@gmail.com>
In-Reply-To: <a0805010-788a-5ff8-2e6e-34e7ded8c34b@gmail.com>
References: <20210623191426.13648-1-paskripkin@gmail.com>
        <a0805010-788a-5ff8-2e6e-34e7ded8c34b@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 21:23:27 +0200
Christian Lamparter <chunkeey@gmail.com> wrote:

> On 23/06/2021 21:14, Pavel Skripkin wrote:
> > In case of not supported chip the code jump
> > to the error handling path, but _ret_ will be set to 0.
> > Returning 0 from probe means, that ->probe() succeeded, but
> > it's not true when chip is not supported.
> > 
> > Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> I think this is already fixed by:
> 
> commit e2783e2f39ba99178dedfc1646d5cc0979d1bab3
> Author: Yang Yingliang <yangyingliang@huawei.com>
> Date:   Mon May 31 17:41:28 2021 +0300
> 
>      ath10k: add missing error return code in ath10k_pci_probe()
> 
> 

Ah, i didn't check linux-next tree, my bad :(

Thanks for pointing it out



With regards,
Pavel Skripkin
