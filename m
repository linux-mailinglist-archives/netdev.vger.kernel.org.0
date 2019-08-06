Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0D839C1
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfHFTkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:40:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42318 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFTkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:40:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id h18so85850939qtm.9
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 12:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Y7UpGezK0Ud1sFcHnTxPRnpHSsAKoECEyD/JfXJH5eE=;
        b=I5CqAKAJvqBMZ7cVCkQIZzJxWZqDXUmJ4fuZDVxnWO0sObj/kWqJbEiCN/DzeHzivD
         8qIms80lB/zz/ShDMd1VDvdRN5EHjP6LkKuODP2W1iTPeIp7KvpeOh3En1pcYoAc3Skb
         b/zSpO5QpmAhh+C24sIQTl8wTjGjmmr2hy0pKlto1ERsY3Q+W6NriEtj+HuB9Y6nMnW7
         JqSd1u8UcvNaomN3QglbfI8msemVHGvNViZ3+xfWbF5a4Qdup9cHeqGz4eEbTGK4PHmu
         4XeeL8psXWyoNs2BhXqpxpv7h2YNndQJsFnQrVsxQfthViC+T/3V6S83+MCSBw1y3pgZ
         1J6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Y7UpGezK0Ud1sFcHnTxPRnpHSsAKoECEyD/JfXJH5eE=;
        b=CnI/VomdUXm8pJCLuSI0YwAgnhPWlCIt2AqAo5uw3oV/wsGxmEHY84YdedTChwxd7W
         oWdbeHgqm132qiXP1qGwnEqx7Oj57LPflZ18nv0aAO1lJijUGjbKchintxlBc50D9q/T
         Xsb23rQPqEfuoHlsfzCkG6rad7dxjE11CwR282P791aSLlSGjXuBlZ49Qt4vYUcYWaWL
         yIDMIAVf4QxouvCXJj0KVbQtBw+Gsy8xoDDIpN+VfLYN3i14kqz/3hwKeD5LgXCkApVP
         LZP3XxvnHqciMA9wsRLxuzQrmeXBqMw4krq+H9ByIVqd70KACmcokKkewdzJOWmet+wa
         o37g==
X-Gm-Message-State: APjAAAUte8iTUy1Sj7pPQnonwu2oaw0/9zpZGEzBIHi/+rT6oi1Jis87
        ltlu31YxzSPpDS6WAf1tS4VetQ==
X-Google-Smtp-Source: APXvYqxi59nkItJAOGN4OwKGOH4912Tt8J12kJYya2XOtlNL8EkJaIagn0XHoE9jbWY9aKFh4K3utQ==
X-Received: by 2002:aed:3091:: with SMTP id 17mr1193900qtf.290.1565120444179;
        Tue, 06 Aug 2019 12:40:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y9sm37534001qki.116.2019.08.06.12.40.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 12:40:43 -0700 (PDT)
Date:   Tue, 6 Aug 2019 12:40:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/10] net: stmmac: Improvements for -next
Message-ID: <20190806124017.77e0f63c@cakuba.netronome.com>
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 15:42:41 +0200, Jose Abreu wrote:
> Couple of improvements for -next tree. More info in commit logs.

Code looks good to me now, thanks!
