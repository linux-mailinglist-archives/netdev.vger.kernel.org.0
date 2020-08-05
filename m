Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B123CF36
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgHETQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:16:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39361 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbgHESA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:00:28 -0400
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1k3HXC-00086E-9p
        for netdev@vger.kernel.org; Wed, 05 Aug 2020 11:24:38 +0000
Received: by mail-pj1-f70.google.com with SMTP id lk11so4668238pjb.0
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 04:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lF9ALM9gRuD9sB/pHsvqa0BtUHkbcECALGd1yP2+BEE=;
        b=JrbIObIEnnRsTwt2z7f97O6ncqQA184gBA84VrbAMqIlY61zVaS3z6Sp2Dt4ESiWnX
         rSiNi9nb9RtjXgF3QxBGHijpbM3gVwK1l+7DMKEH6qra67eqwLskapTaOhs7yecNEFIi
         QbX65TqrTv6S13noGDkUF5qmNz1vTBLq0pk3SygLUln+GO8EJ7vzzCVnKocstFO4GGh4
         Xk2puiXbtu91F4+UFvk+z77EeBuXDdo1R8ocABJn0dPXbsMBYBJRv5WD9BGfbTwg95OZ
         Ka8hB43XEViuDr+I4iyV/DAuk4eEhzNaHaj8Av/V4pV/NhpIgyeM0lLEm/T5Kot6M07Z
         FQfQ==
X-Gm-Message-State: AOAM530wabuLFNRdsPORx6RSJgcAQduDdbP8TzGZIDwCrMAedh1ywK1q
        +Ge1RVcQbMe5MU/VoaZI6hbXo6KuzMWer3lGd+anCD/UH+ggpaH1GtltgPdwRDXFPp/+wg0/zQW
        R4JJGizMIdtEEA8Ji8nUgcMsuefo+YT99vw==
X-Received: by 2002:aa7:9a4c:: with SMTP id x12mr2894371pfj.307.1596626676926;
        Wed, 05 Aug 2020 04:24:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJvZXSuRgwTlY5y0En/vjiU7lqcs7sM2JL0qxNrQv5cxET1ZLz6FnSZD2pMhacVp3VGxyXoA==
X-Received: by 2002:aa7:9a4c:: with SMTP id x12mr2894345pfj.307.1596626676533;
        Wed, 05 Aug 2020 04:24:36 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id i11sm2613913pjv.30.2020.08.05.04.24.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 04:24:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] rtw88: 8821c: Add RFE 2 support
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <c0c336d806584361992d4b52665fbb82@realtek.com>
Date:   Wed, 5 Aug 2020 19:24:32 +0800
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andy Huang <tehuang@realtek.com>
Content-Transfer-Encoding: 7bit
Message-Id: <9330BBA5-158B-49F1-8B7C-C2733F358AC1@canonical.com>
References: <20200805084559.30092-1-kai.heng.feng@canonical.com>
 <c0c336d806584361992d4b52665fbb82@realtek.com>
To:     Tony Chuang <yhchuang@realtek.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tony,

> On Aug 5, 2020, at 19:18, Tony Chuang <yhchuang@realtek.com> wrote:
> 
>> 8821CE with RFE 2 isn't supported:
>> [   12.404834] rtw_8821ce 0000:02:00.0: rfe 2 isn't supported
>> [   12.404937] rtw_8821ce 0000:02:00.0: failed to setup chip efuse info
>> [   12.404939] rtw_8821ce 0000:02:00.0: failed to setup chip information
>> 
> 
> NACK
> 
> The RFE type 2 should be working with some additional fixes.
> Did you tested connecting to AP with BT paired?

No, I only tested WiFi.

> The antenna configuration is different with RFE type 0.
> I will ask someone else to fix them.
> Then the RFE type 2 modules can be supported.

Good to know that, I'll be patient and wait for a real fix.

Kai-Heng

> 
> Yen-Hsuan

