Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23D3062D6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbhA0R6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344321AbhA0R6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:58:15 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC30C06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:57:35 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id r12so3908341ejb.9
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIADIskXOt6EwQDIH0t0Yqhw8qy6OhqJcP6VGVadpTs=;
        b=eKkwZ6fyiV7/shXeQvsTF9cb+eVUKh+W2VmSo22ym8oqM50bHTcZngtoeV5WCEoHIn
         MxpLbpzotO5G6Tq3SmZir/6AzF/mE5bQcHecwLY8nB2c2lCgbY25nKDuFCdwIOX5tSwq
         yvK5q1YhQTT1Ei73VMDVVpQYNVQDaqE+yVvYcnHQZHra6qivkqABFnNQLp9CL1XAeaWN
         F6pZwwKnl9ysthBW+et9PCmzC4vAbkGTdrRne+Q6qCbRHihDR3dRKasAYBuHG7+VdoWE
         PD4SJ1bKLm9gn/VB03SkoBEMq4wZAYYef1YOE24dsKhKciyMledldv5RlheFfiqgz5O7
         jJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIADIskXOt6EwQDIH0t0Yqhw8qy6OhqJcP6VGVadpTs=;
        b=DOEgzn7m9IaqIgw9zTrAPNWhTSYK6M4g4POuOq6zuyQkMpPhEtqJtuc1vdc2Q1d0ce
         U2fCP8Xa0dxdfdGSsWNWbTy+n7bDjZLbqH6kloirewCmibXGTQKVx39C63Y08jTh3MYj
         zVTR1bHmTk1aDeGi6kOV+FD/p8k/2495gKIoqgjQDCrk1bk8PWzkYamiYQEP0o3bD8E8
         P9IuauhXPwPx2bE4tX59vF5FNaxbBYKV/1Yq1GwaZ9hVmR0/jhIp0G9bdaMlVN4YbwGu
         JQel9Zj1WAgYiNDHTEG+Cl214KWslVK1yWGevypuFkYS18KmYuI4deW45YSVLVeltUCf
         7Fpw==
X-Gm-Message-State: AOAM533bZ5cK87mwrTVUuAGQ/wYaX1PUOlAmFlVty1nC/4MOmLfGOpNl
        c41S3ykyx2BonQf1T0kcnWMrZPMlfLEF9DXzTxU=
X-Google-Smtp-Source: ABdhPJysa4OpI0FLWOgXqfZez2JGa0liDZbUdY66XCUb2Y8fvsPVC09f9+wgUXbQCmTdrkCOCJzGnuR7Ud6LTgt6ZJc=
X-Received: by 2002:a17:906:44a:: with SMTP id e10mr7481810eja.265.1611770254118;
 Wed, 27 Jan 2021 09:57:34 -0800 (PST)
MIME-Version: 1.0
References: <20210126210830.2919352-1-helgaas@kernel.org>
In-Reply-To: <20210126210830.2919352-1-helgaas@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 12:56:57 -0500
Message-ID: <CAF=yD-+cRJWv8J3Dvhca=1U-DewzgvWAGnrVgMEx0ryk8pxSdg@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-af: Fix 'physical' typos
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 6:29 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> Fix misspellings of "physical".
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c      | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

If doing this, there appears to be a third one:

$ grep -nrI hyscial drivers/net
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2:/* Marvell
OcteonTx2 RVU Physcial Function ethernet driver
drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c:2:/* Marvell
OcteonTx2 RVU Physcial Function ethernet driver
drivers/net/ethernet/marvell/octeontx2/af/rvu.c:649:     * create a
IOMMU mapping for the physcial address configured by
