Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD0CD1BAA
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbfJIW0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:26:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39239 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730675AbfJIW0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:26:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so5793393qtb.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 15:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CiNtf9aBIrrX5eeY+lWUtp3cirNfSmpXQ9FltiktAv8=;
        b=FifhUGIjpae34or/omxVvVhF4rTt/qglBiIOmZrJKECnjR1gVHZsl8LD6YgHFKTCXk
         hCZnog3cO2un3XkGVataAVPc30evbmMui325U5Rp6eS6XapsDteXGLN6FhKqGctsV2ao
         Mx5Ef0I0DwwIRgRslVWXqZydwnLF4QJibAxyqWnlvJgXenZgySzhiKYKJ2uae0g4NoWq
         alJLKjeJwSPpS3TJfgbwb9lEEdUq51XdBXR6eLtEthEIroRTCUZMZeqzJ967zjwYCcUi
         FBTwZhcbcy1YP3GF59x/oZdm0LstQNmyJKF1+4jueJ4vBmMxQkuLHpXREbEd1e/VGs0B
         wX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CiNtf9aBIrrX5eeY+lWUtp3cirNfSmpXQ9FltiktAv8=;
        b=Tj+wDzHf5GGoUMXE+VkU1lfCBv+xIcRqQaHqEItU/2KWgWuPZboX8C133d7KQvvYbv
         borccUkl9jZ9NZfA/EpM0k83YN7WECNENxjeQzgmatM+go7ddSpAiRq7vyOIod0ZiXSw
         Kk++thyZ84KdGAd/PWL+21ImOgTnprMD4oUPEIgJLeYUxp05cGLPohHNSq9JeSZ09/Me
         6HjjbOxVnutyr+kandLZqGsBg+sO7mKWDTqzybpXh5JHAKDP/wSCOiw0lL0Hkxo1jmNj
         sk+iYiivoUWk0TBz+glSOxnUnCQwrV+FakEYsqle+rK0PqnII1EazCLt5RKXfRWlz+n8
         fX0A==
X-Gm-Message-State: APjAAAUbKNpLpn0knPh1bgmJ8X7mdcpSa3gAVxdKFX/oo6bW8zJ1Qo8w
        I5kyLjTQLEReaSWQUsCqypKh1g==
X-Google-Smtp-Source: APXvYqy0slX/EioTfIAvk6LMnCaI+bB5mkLKuNgrupgqFoZCuC6hMmDIMoLJbc3HFKkDgCKbzceKzA==
X-Received: by 2002:a05:6214:1264:: with SMTP id r4mr6460857qvv.64.1570659993075;
        Wed, 09 Oct 2019 15:26:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k54sm2393829qtf.28.2019.10.09.15.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 15:26:32 -0700 (PDT)
Date:   Wed, 9 Oct 2019 15:26:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: add flexible PPS to dwmac 4.10a
Message-ID: <20191009152618.33b45c2d@cakuba.netronome.com>
In-Reply-To: <20191007154306.95827-5-antonio.borneo@st.com>
References: <20191007154306.95827-1-antonio.borneo@st.com>
        <20191007154306.95827-5-antonio.borneo@st.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 17:43:06 +0200, Antonio Borneo wrote:
> All the registers and the functionalities used in the callback
> dwmac5_flex_pps_config() are common between dwmac 4.10a [1] and
> 5.00a [2].
> 
> Reuse the same callback for dwmac 4.10a too.
> 
> Tested on STM32MP15x, based on dwmac 4.10a.
> 
> [1] DWC Ethernet QoS Databook 4.10a October 2014
> [2] DWC Ethernet QoS Databook 5.00a September 2017
> 
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>

Applied to net-next.
