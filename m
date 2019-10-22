Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF4E0CED
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbfJVT4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:56:52 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37597 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389098AbfJVT4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:56:51 -0400
Received: by mail-lj1-f196.google.com with SMTP id l21so18530728lje.4
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 12:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mJFn/3QyJLqAcJcgayRN2NV4RnnfMUx/ZNp60iWEx0U=;
        b=qx44oaObOl5Z3A8Im8+pd3RJwQ67FnX72mNIzR2fNuacOOqtifUryGU1mSP9cx9Coi
         OwlA4xg5cu62BzgCmrFo5BHDbaaGce4VYz17waemIbXYi5mvl63eMCn1dgsguehVvGzz
         8FWw+rCapfcw470Q3OkxUgJLJZ6281Y5WYQ6xjxRMPHeGeaydHSo6q7bC0Fj1D8IBmrE
         C5VNjCF6+ZzPXerBYfKuZu0o13OdANRZGkEtC+iORESw+cDO+e2pK9sGFqBhY5qe0J9A
         okyPozGjA72PYNCGJSJqa99xICbZJZ2SAXpl+lLoT24JPrzHoUY1HUpwK4rdzQ0aRSwp
         CHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mJFn/3QyJLqAcJcgayRN2NV4RnnfMUx/ZNp60iWEx0U=;
        b=HbRqDFC9a7zkWcrIKdMaODrIKwEPmYdmHH6tEv/EIrECqdRQxc6wpP2pU5v7uQ+nQd
         tpvInlQCqlHoWJz1w9qEAxpnced8oEctYxycnZYWltbNebXjPr4+9ZYsl8Uf5gPSz03u
         q9yAlfY6nUG4ngSFOvx80XPHYhAKz1y1ck3V1fZJ7GDwdkqb205QOVhHESpvbTm1CBVC
         K97YTAe8cVyRp0SQVQMjTnvgZ1f43wS4Td4MeLJgXfONvMLqVgAXC9hBNJQARcDEH1TP
         Mv1xXYx95LT0e7NGD22EAvQayNmU18T1RWzGXZvy6LKd297f9md7IEF2GNnQAbRhrPxI
         vhOA==
X-Gm-Message-State: APjAAAVOLrQaEq57//o62oKqN65wNFBx3NMbjojH2JmyqeW7wJUQPG7k
        8aPJqmAVnxjBC8u3g2AcUXSwbw==
X-Google-Smtp-Source: APXvYqxV+52xwMMCtGYUGGGLHmIa0mfaTIVpi2sWRWwgXWVGuY7Yc9SOZf2U7O6CBUohPQt+DgwJWw==
X-Received: by 2002:a05:651c:1023:: with SMTP id w3mr3672555ljm.79.1571774208276;
        Tue, 22 Oct 2019 12:56:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p22sm9942111ljp.69.2019.10.22.12.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:56:48 -0700 (PDT)
Date:   Tue, 22 Oct 2019 12:56:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: provide dynamic_hex_dump stub
Message-ID: <20191022125640.02f02424@cakuba.netronome.com>
In-Reply-To: <20190918195607.2080036-1-arnd@arndb.de>
References: <20190918195607.2080036-1-arnd@arndb.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 21:55:11 +0200, Arnd Bergmann wrote:
> The ionic driver started using dymamic_hex_dump(), but
> that is not always defined:
> 
> drivers/net/ethernet/pensando/ionic/ionic_main.c:229:2: error: implicit declaration of function 'dynamic_hex_dump' [-Werror,-Wimplicit-function-declaration]
> 
> Add a dummy implementation to use when CONFIG_DYNAMIC_DEBUG
> is disabled, printing nothing.
> 
> Fixes: 938962d55229 ("ionic: Add adminq action")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to net/master, thanks!
