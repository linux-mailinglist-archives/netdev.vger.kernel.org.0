Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73831E5E3B
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfJZRoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 13:44:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38416 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfJZRoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 13:44:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id c13so3872468pfp.5
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 10:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r4CncQVa3UScMSulyjqdZxtk1VswC8b88nQrQt0QJqo=;
        b=cC2cNQ3jOz8L+dwxk+sHHaQdO8tr5MFEFU38kFn2jX8bwia6CPyUz2zpvcL/cbSWde
         iS5RqCb/gEVCB2iKbvAjafn8V/XyAJ1gp0gHMmBgBqiQg6vtuhS3GgnkbP9z8CNWCoME
         5VUlmLPn1yGw+T22MrlrT7Xi7OO6SHRa/ps0eUBJt8h69U4CcqqD+kGRpFK9Ze9dOcoV
         CuWAPtdSA9DnY6wUZih5YbiGqAU9B3g69ZOsheC+9/4N03kKEKBVHiLeENt6rXa2Yrgj
         s1phksyTHlhbVORh1eo9syxovD3itjeAvM3+xbLpVE8Ou4bGnKPWWJK02ry8j6kgUIL6
         Kwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r4CncQVa3UScMSulyjqdZxtk1VswC8b88nQrQt0QJqo=;
        b=IEWmPm2NIekQVh/4RfeDcb4kY7I8MrUbqLmKwtvHWoqu9MKDBfp6kAa1jHhbK+m9B2
         9tlXv9JvQMWnAlvPKy9tBxUXPlv5ip6KE4p+Wwz5rw5a+UiyVLePY7/g36zSfGHk/wpd
         GrHUmr+Ki7hiNnp/ep1VR1+c4FbEMqrR7zQLO8syIs0vceGhQg0hDz05OYPv440g0jYs
         Quv9+jG7g0+waRPaZCxyXkHUJhZEx9fo9DikLmfHs1ThLvq32xgS+0Atbn0P5Abiug16
         bQtIA4CQaP55bjuB9t64DpSGs8/fgLKTKzA7fKnOt0kOFUGcQzy31ydwn16+LRxroQ3p
         XpyA==
X-Gm-Message-State: APjAAAVAmRUGvV64Zf/7CAKSp685WOU1nK7zluwVwyQsLfzrTuQt3T1F
        Q+uxfDiOcktzpUZ562X7AwM=
X-Google-Smtp-Source: APXvYqyRsYH3D99WUvi5xOB6C0sPIlI1kwi+W1QOSL1H0dVGlW8577WXsjCVOfKAIEEGCtuBM+nJcg==
X-Received: by 2002:a62:e40d:: with SMTP id r13mr11617135pfh.154.1572111885807;
        Sat, 26 Oct 2019 10:44:45 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b24sm5784706pfo.4.2019.10.26.10.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 10:44:44 -0700 (PDT)
Date:   Sat, 26 Oct 2019 10:44:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: aquantia: disable ptp object build if
 no config
Message-ID: <20191026174442.GA1675@localhost>
References: <cover.1572083797.git.igor.russkikh@aquantia.com>
 <94c21cdff374078fa8c3a603d8d3d60dcec9537a.1572083797.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94c21cdff374078fa8c3a603d8d3d60dcec9537a.1572083797.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 26, 2019 at 11:05:34AM +0000, Igor Russkikh wrote:
> We do disable aq_ptp module build using inline
> stubs when CONFIG_PTP_1588_CLOCK is not declared.
> 
> This reduces module size and removes unnecessary code.
> 
> Reported-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
