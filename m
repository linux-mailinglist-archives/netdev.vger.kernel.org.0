Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1551E95C6
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 07:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgEaFR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 01:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgEaFR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 01:17:26 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CC7C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 22:17:26 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y17so1126238plb.8
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 22:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bkuu4W5eLmvBnT3KA220Ei4/2sRMUClowQA+Vmtf40s=;
        b=LZKeGp6iIi24OfmSyLT3Q8jv+p6tZTMWDQ4lrNPldTRQ9K/C/OQ2OmFEwO5Ve9HBYT
         HHEr+qC86rHfiOapkf9NuxFFUP5/vwtlGoxLXw9BFjw4lmh7VUT+4+MqED44cVoYPItf
         Ct3xx9qiVSZOKqUWdq8hC48OVuKIe3FtbUAVImZVRlqay33OB0viNt24zVg0uoKpnFcH
         KT/Vo6u+MM3rj8K43/jmQuldDHj1t4iY8P/LZlFNVaVHuIwaJD6lwtJ2O8KH9mOBPuoX
         aoT9xYiT3NRRc+PTUjdzcWFYoxJsLMr4B+jqdWMhkulRCMrADuRn9VS0CYXZAnODBu8A
         5m0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bkuu4W5eLmvBnT3KA220Ei4/2sRMUClowQA+Vmtf40s=;
        b=FKI+EdRapiG2XZAGxX/3WKjujNBO4pfUKcdZSIcPGWQqtOApuYOLpmnLVH5JE47l5V
         5+0oSAOr3FybakQ8a1VjP6JBp5vAWqURm1fLAG/94ENf9NJKjkPvmRB1aLRHzIOAuj7d
         0X7GL/0Xm6/vYeNpSV8aPPNbz7JlRZkWNTc/jvupc+LbDxwlBDYjyfuYquE9HLLalP+F
         eWXxA2aWW5H3T8XWOoaZVnwdQxHfmly9MgBHp4Mjsyoyg/+Iw7zDoViBE7F4Pq4VlIZi
         xGKBR3ACDblhiRxscwqIs0p7/ZGHIOq++LUpSwQjePiHqg7Mu/lfU9JK/uR8SDh5IqUV
         kKVg==
X-Gm-Message-State: AOAM532PwuNKu2nRpPN6r+ZxYmAuap7HH05R4qDs5ruKx9ABrqCP6h3y
        hT3G9KD6THAB2KsCiPiTMzL4Yw==
X-Google-Smtp-Source: ABdhPJzVE79OtfvFTt67v/HxAC5R6MOrVdlxLrbRza85Y1Ep3AC9Ecf87WScSiU/gCqsm0AER4t/9g==
X-Received: by 2002:a17:90a:aa8f:: with SMTP id l15mr18074803pjq.211.1590902245928;
        Sat, 30 May 2020 22:17:25 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t12sm3580136pjf.3.2020.05.30.22.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 22:17:25 -0700 (PDT)
Date:   Sat, 30 May 2020 22:17:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/6] r8169: change driver data type
Message-ID: <20200530221717.400033de@hermes.lan>
In-Reply-To: <29eabcd4-fd77-58f8-3091-acc607949e28@gmail.com>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
        <29eabcd4-fd77-58f8-3091-acc607949e28@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 May 2020 23:54:36 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Change driver private data type to struct rtl8169_private * to avoid
> some overhead.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Are you sure about this. Using netdev_priv() is actually at a fixed
offset from netdev, and almost always the compiler can optimize and
use one register.  Look at the assembly code difference of what you
did.
