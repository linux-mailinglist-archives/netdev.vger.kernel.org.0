Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8E2E9260
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 10:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbhADJNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 04:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbhADJNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 04:13:32 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE190C061794
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 01:12:51 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q137so24332816iod.9
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 01:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=DcvwkzNsryECdRx5e1rnB4ZRJBiQVALuS7Q6uWqaIAw=;
        b=J17XMA4dBLIqYbqrC+9S7/9I/ZqdTYPnLMU8BPvBW2z12S8MFE97kYNntTDSaIuqbu
         vXvSJkiz73PXjxlzKyDjbpkwM9SZ9K7E4c0J/DXXZzehFzvDWRFeuocsUp+kz7vABBHv
         wu+mbUIzHmwOc/bfr+UXB1/DqyyaThPoP8KRxvhgsWt8q5diIz0uB9a+PHSMfmaDfQB1
         7nMJD/wutFobWu3q87ZKDdt9+UDJe/4s+4luE9ISR3SOJ/JRSmeWpKkjEUY24GKM1d6d
         59/m5tZq3R34/t16xX2zJM3RSwReTBfg1hnu4sLDglnvWp+zpod0xVh1D93ojK0KrEZ4
         sUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DcvwkzNsryECdRx5e1rnB4ZRJBiQVALuS7Q6uWqaIAw=;
        b=j+ZtfiCS92njb+nCs5aLl2E2IR5SpgnRJb4jMbgKxzMX0UHAEl3dRpnwUqnRz08U/c
         mFqJZsZqkKUa3mRj4zebN6j86c9NYuge3cG/cQiRPwo5uvVWbNSkCshq1BLFzdaKpLu3
         V4UQoCMH/GrH0wTwZXvo4ykWhz/0czsZKcudrNamc47/D5PYELnJ4QusdQgjeYcSRTFs
         r2yHluQjWGYMIjb5zF0xOhPSOP7ov3m4/po5ztju9JH1DP6hnSYBkrePRy8AfM9YS2wA
         IHBcFsEYYyK5J6vH+MildCKTnJWYddghL4YOFTpCeMCrb/yiMpsM+oeASa9KJWO+Y/WJ
         Bl5Q==
X-Gm-Message-State: AOAM532ZBs6why2Vil1jOoLM4ILMizWRI2uj3nCybCSFjGfZD4wG+Qt8
        PuzuPyg6MCWTFTmY2O6pQ4OM8jBchpkcUa77qpdaY7nyFUAwMCLVVrU=
X-Google-Smtp-Source: ABdhPJzqFjJ6vGOQYIR6h2AVd8ewGBq2rSWNtk1m88sSveIGxZaKZCRi1fcwViIjzx4Ln5IgoXSy3EW82U4NrERKWJQ=
X-Received: by 2002:a05:6602:2b01:: with SMTP id p1mr58217763iov.156.1609751571029;
 Mon, 04 Jan 2021 01:12:51 -0800 (PST)
MIME-Version: 1.0
From:   Shawn Guo <shawn.guo@linaro.org>
Date:   Mon, 4 Jan 2021 17:12:40 +0800
Message-ID: <CAAQ0ZWSs+osniXBsaDonLiS1=ZeOc8PdQx_XA6tpkxe+HKi2jw@mail.gmail.com>
Subject: 
To:     Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unsubscribe netdev
