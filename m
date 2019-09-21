Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1567BB9BD1
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbfIUBRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:17:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44534 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbfIUBRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:17:08 -0400
Received: by mail-qt1-f193.google.com with SMTP id u40so10759976qth.11
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yGJWC7TGy5SoWTG1ig0XZfXKA3y4WbgWOuyQKkzgtJo=;
        b=oGcG2iTdZ/Ejigq1BEnLvpCn72emkWprGWOjmr57USL57Zdq6FXuSETnNuF+ckFg5G
         H7Pj0VlLLbDmyiaCqEDCfkmv6GXPCYe2IySdPfKFA2FHkwCFalUkj/U8+misT5rQKnxs
         AwCsLVLRW4eakON8MR4wVsAiqOwYbPi+hj25h/VgELfOYGcUxior+6RU/WSyMSpNtXor
         XzdHg/ERgDhdmbxKPF1zB/ErZrSp1tTrjm/qSovZYgFb0Iyaz+cr0raqlKiA+V/czB1f
         eP8k3CaSNoS9oHC8sDMhPP5cBVJMpjfQgcG7oM1NIcTz8bOy9tcyzFgWiKXlAQ/0EYIs
         M58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yGJWC7TGy5SoWTG1ig0XZfXKA3y4WbgWOuyQKkzgtJo=;
        b=og6IYL5OvtLerQMDTCzppMaE/KBJuVg+xiZgc3wWjt7nxmMCCHmab0OFu/nhnBoBNH
         A13PrZPIhTyqoy0zjUz8YDO4H/IQNm2Y4uRiXahg4u6RZOKs1u2lbVsDWCFdS/u6Gj9C
         LL3Cl665Qm+effommQnJ4t8bDmLVIdA+BkDMdn/R1i0ms4TgFcsqo6jBpw9f2TKU1BEx
         ZW//MeGQu8HGg968+Q2s8WzeZY3QLosM7uBAep0zUqKHjTiZOAtI02Xx+aAxmo1XVE19
         PNOkUK3wggb00GzWRZ6tuIWxkPMuYfYZFActckiBgndOOCVPaiKzOHzxJFyEYlRymFyY
         7SaA==
X-Gm-Message-State: APjAAAWw6RdtaWYjBmho0/76wN0cvJ/cpsJi3ZsCs6krBhV4r22Z+LuZ
        wnYJr12+dgaapbiX+znKCdOkYA==
X-Google-Smtp-Source: APXvYqyukYH0n0qQq3n5uCwyZ4a/Q10NBDzhmBikGzAPwuz2RQsTtvS2ZiYFTEptxGWKMMv6/Wyw9g==
X-Received: by 2002:ad4:5483:: with SMTP id q3mr15804690qvy.238.1569028626975;
        Fri, 20 Sep 2019 18:17:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a72sm1599335qkg.77.2019.09.20.18.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:17:06 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:17:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] selftests: Update fib_tests to handle missing ping6
Message-ID: <20190920181704.04764084@cakuba.netronome.com>
In-Reply-To: <20190917173021.19705-1-dsahern@kernel.org>
References: <20190917173021.19705-1-dsahern@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 10:30:21 -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Some distributions (e.g., debian buster) do not install ping6. Re-use
> the hook in pmtu.sh to detect this and fallback to ping.
> 
> Fixes: a0e11da78f48 ("fib_tests: Add tests for metrics on routes")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, queued, thanks!
