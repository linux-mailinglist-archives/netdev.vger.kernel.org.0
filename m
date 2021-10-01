Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5071A41F418
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355600AbhJASAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355546AbhJASAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:00:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1706C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:58:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k23so7100452pji.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qj32+1ikr5PmSZVtwJjbL76UEFZNDtD4xuG9qYfI+G4=;
        b=Bg33rmZ2VlaRofGIyxZ3xMXlJ0eSjrxEM+ifb+tkZRZ4R+gOnFXWKCcaF/ZzeqJGKw
         ar5nxqPavxbcBpPE1nvYFHglQlpNQDxQVSZi0wm/n9LzDoyS74PcQ/INAH/cpoBm+w4t
         /GcIN53WvKQqYlmpMA35y4du8sPi/WN2alHGXWplgeltnbPLTjoBdivwPKU6r334zk0A
         1GkgrHzVs2BSACZ/SLKOhach5FaM1oF8F2G3DULdfx0pPwXyAq8t3moNJFHxDYmV/DEB
         88vdXz9+wqzQq6YiEIyPTnG8VHWdueYDCvaQVaHSa+/9Y1QBoskZUM8JBHiuiZyFKNvt
         hlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qj32+1ikr5PmSZVtwJjbL76UEFZNDtD4xuG9qYfI+G4=;
        b=F7Scj/3Y6oGo4zMWkcB1HQ6rcgaEMYlRiY5YtHPj93DnyRhvJEtUijPs3EI9uz86D2
         iV4sggVUuhMHi7QVQJyDFdsz9FVbQqNupGM3D/fbEFlDiUWA68Hhz//e6b8JMKLGCR0c
         nIns8X7zToEkCrDrFryHkpXwD1ozhNx++0cZpyKQxmYZLFMr4Ao5u5Q2oi0p6OYlkasz
         iiVd+PO2P+HovlLv/OmclIOwCAGiqiO1p8+H/t86ailmFA6wsop62nzsbRSKr5iSxOsl
         xhyoj6K5NuKqxamF34PsTKpwWJMnlh4E7NfrAu7TA3CAcy+684Au3Wbc8Y7vT4GcAJSa
         VIfQ==
X-Gm-Message-State: AOAM532yp5TWT+Hk+dNXCXfomx5K8sOuMyK/+SFAo0FJA5umzzqPsRZ2
        0dhmDGwNjNVtE8HBGrJkoj7W8A==
X-Google-Smtp-Source: ABdhPJzAsZxuWWVt8HCI5wjeN5EEEsX8JOafBQVzPGRNZsnt+Yax23tMmzi2MR83E6H/jar6r8xO9g==
X-Received: by 2002:a17:90b:946:: with SMTP id dw6mr14839533pjb.41.1633111118458;
        Fri, 01 Oct 2021 10:58:38 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id g3sm7395514pgf.1.2021.10.01.10.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 10:58:38 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] ionic: housekeeping updates
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com
References: <20211001173758.22072-1-snelson@pensando.io>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4ae97ce1-77b0-e285-4a1d-c5975aec18a1@pensando.io>
Date:   Fri, 1 Oct 2021 10:58:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 10:37 AM, Shannon Nelson wrote:
> These are a few changes for code clean up and a couple
> more lock management tweaks.

Hmmm... I see that patchwork is complaining about these not applying to 
the current net-next tree.
My apologies, I'll rebase and repost.

sln



>
> Shannon Nelson (7):
>    ionic: remove debug stats
>    ionic: check for binary values in FW ver string
>    ionic: move lif mutex setup and delete
>    ionic: widen queue_lock use around lif init and deinit
>    ionic: add polling to adminq wait
>    ionic: have ionic_qcq_disable decide on sending to hardware
>    ionic: add lif param to ionic_qcq_disable
>
>   drivers/net/ethernet/pensando/ionic/ionic.h   |   1 +
>   .../ethernet/pensando/ionic/ionic_debugfs.c   |   2 -
>   .../net/ethernet/pensando/ionic/ionic_dev.c   |   1 -
>   .../net/ethernet/pensando/ionic/ionic_dev.h   |   4 -
>   .../ethernet/pensando/ionic/ionic_ethtool.c   |  38 -----
>   .../net/ethernet/pensando/ionic/ionic_lif.c   |  74 ++++++----
>   .../net/ethernet/pensando/ionic/ionic_lif.h   |  45 ------
>   .../net/ethernet/pensando/ionic/ionic_main.c  |  53 +++++--
>   .../net/ethernet/pensando/ionic/ionic_stats.c | 130 ------------------
>   .../net/ethernet/pensando/ionic/ionic_txrx.c  |  14 --
>   10 files changed, 89 insertions(+), 273 deletions(-)
>

