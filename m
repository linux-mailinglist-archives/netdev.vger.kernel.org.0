Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8342A1DF2
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgKAMnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKAMnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:43:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E38C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:43:41 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id w23so6814362wmi.4
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=V6/zjG9PiJyoqeqWyMhlmh3XAdik+C1vge77/175sfM=;
        b=HbfXcTmm8qiDOFekE1ZHH8cUDRGg2Prb5XsCPKlfHFxO0MQ1pYnHIw1ALq5jpdgsVV
         2E9S3QFkdTShXwCTscyDwSVNGPJZQ08SQh7w0kU5PcFTVoSpABnKi2930SasKQ9p8LOr
         5Q2X1Ix53Vz8al8LxqWJ8hLV+xl3UjvORHBxDnAe4y9++3rc8UrKhac5w556O5nOUzLH
         dHdMx4tiV3tK6Yy1TqfJiXIFylaa32NeY9JmnfZnUxGKUaCfMuFr84DA0AUXvnk2GFm2
         6kG5yFOUaoBvr0u55U2DmBnz3AfGVOb3pGB7xqST1neEDK3yfm8fSKE4JqJNqbDrngPI
         N+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=V6/zjG9PiJyoqeqWyMhlmh3XAdik+C1vge77/175sfM=;
        b=lhGOLxIfFp1USWhz76LFfHDmskldjyPAOm9lSlON1vBYbGzoTnfwRxDtW2Ig/CVkvA
         NZqvGPRu5ii70xYLsP37+hd9Npca0fVtKv9u6fcUY7PBB+f8Kg6XsYPSc8W4AuLJcQS+
         tQVKs9e08bND4ZUlhUx5Kr/pK0tx/LJPtWaYyAZZMPF+EywundVugvjorlb9PlJXe2R4
         vi7nDgDkhypbrbTtegBCI1DVrbtQ4fEV2bQard6PH8WFIgrF1iaJhEB3kqF4MHrDc0D3
         CbDxE6NKSmwRuzoLzbZhG1j6z/Z+2PSabMB/I7OdJxGvnmmQJtGXOZk0uc1CgLD1Huc9
         grAw==
X-Gm-Message-State: AOAM5335K8I7RxiH3SUKBNDcLB/VghCH9jjgTgJKvE/ciFxHGyR1oaCG
        kT6szOpmdsH3zU1xhZ/RyHU9993ZFa0=
X-Google-Smtp-Source: ABdhPJyCcKQQGUpIuCJH60KH/8CpEBs1+j0hLQyLYdptaDFaTew7VEetDaIxMrkBe7y76cJRayOpog==
X-Received: by 2002:a1c:3c4:: with SMTP id 187mr12270123wmd.14.1604234619054;
        Sun, 01 Nov 2020 04:43:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:dc4f:e3f6:2803:90d0? (p200300ea8f232800dc4fe3f6280390d0.dip0.t-ipconnect.de. [2003:ea:8f23:2800:dc4f:e3f6:2803:90d0])
        by smtp.googlemail.com with ESMTPSA id e25sm19760505wrc.76.2020.11.01.04.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 04:43:38 -0800 (PST)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: EXPORT_SYMBOL or EXPORT_SYMBOL_GPL?
Message-ID: <19f8fdb8-66b4-4c8d-1b62-c41f50c60e58@gmail.com>
Date:   Sun, 1 Nov 2020 13:43:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was wondering whether we have any policy on using EXPORT_SYMBOL or
EXPORT_SYMBOL_GPL for newly exported functions. I've seen both options
being used.
