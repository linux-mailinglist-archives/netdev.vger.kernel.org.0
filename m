Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FF411EE5F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLMXTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:19:19 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38599 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfLMXTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:19:19 -0500
Received: by mail-lj1-f196.google.com with SMTP id k8so453411ljh.5
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=WtkBDfsu+zN66MW4p99gf5h2Qf6ar53LzznejbBjRaY=;
        b=VDHsojpB8QCs2wmQtGSz7VBNO6OI7HYQQw2tQNAzvOEJ5W6ZPenTGQAQH6XuhpLgQh
         z2rxoMV0Tur/h0za8xn5ReHLeX/TOwIL+0mH9Y2PRIUlXnEp/2EWgqUon3GqEFJRnnmt
         G/sMC747GZF8d7j5KNZhvcNBLPJUwini1xvMtcKoclbnep+nrI/FIJn7wibAjfBJtgod
         +FgTpaaCJP1x97JM0GyrIjalg5rCUQbZVCjkGTsY1y5+k/qRzHPmiDTjALdrTLKuLfK4
         kCdtvPkqk6ZMMZpwEvOe1odvMQPIiPp7qMipEXiMl4gdrjCQUTjWIv9N5OUSJC8TL8aW
         8O1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=WtkBDfsu+zN66MW4p99gf5h2Qf6ar53LzznejbBjRaY=;
        b=Z5jZDMt9DnhLwmPMxMrP92cGfj7YC0wypTy199v+sRf3SN1JFRTMZjHLxaE/lH1XVF
         EBXhhs1+ShtAhcqGM0jez63fuiNUmjJ52l5YgKJb45WoeBCtQ1MvpmiYtM6LcoUQYRxC
         kwX+XdUDXmulWN11h+mzuZ1JZquj/LQnt6m/r/5wBhoDdX6HE5I8vBpdrbdMXEO20JuY
         SQMXbd0ybMld2KQOt/K0/27GuZiNx74FGEIXWxStsexaOFZ2UT1e5LjWgc0bpzdyBlam
         I5NjOQw6WdvRmQfJB1lm0Dmj20DAiRaiFZ3T4ocOwpObUzyfQuaG/dEdDrCBkDiv3aJA
         Di6Q==
X-Gm-Message-State: APjAAAVuzqBTqYp8WyQBzFQ7A7dtMxMXH9CPH2FguII8+bLGzGL1ZeKD
        dk+PczMwx9RtYxYOtqhCn2iqkA==
X-Google-Smtp-Source: APXvYqwwAIvZg0FvvigqVsmTMLueLybEPZrXSGW8Bp9nXSe0yupolOGjeT7ZE+hPnu2iEYi7dQe+iw==
X-Received: by 2002:a2e:9890:: with SMTP id b16mr11494733ljj.190.1576279156909;
        Fri, 13 Dec 2019 15:19:16 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g6sm5615494lja.10.2019.12.13.15.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 15:19:16 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:19:08 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: [PATCH net-next] MAINTAINERS: Add maintainers for rmnet
Message-ID: <20191213151908.098d310f@cakuba.netronome.com>
In-Reply-To: <0101016ef843ac7a-9e999ba4-e595-43dc-8646-9fa3959fa4b8-000000@us-west-2.amazonses.com>
References: <0101016ef843ac7a-9e999ba4-e595-43dc-8646-9fa3959fa4b8-000000@us-west-2.amazonses.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 04:00:15 +0000, Subash Abhinov Kasiviswanathan
wrote:
> Add myself and Sean as maintainers for rmnet driver.
> 
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied to net, thanks!
