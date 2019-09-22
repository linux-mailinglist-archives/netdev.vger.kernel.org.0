Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAADFBABF1
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbfIVW1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:27:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41237 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfIVW1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:27:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so7862370pfh.8
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4122js9VzeoHge4cdqVUvNxYMN8/LRqY7OEquLQFbJQ=;
        b=gFi6WBCT2RXWKrRM2WOLIRmqm06uTxsTjzM9ZkFHUuOz5wtfUQDFEUjXiaTB1i2YQP
         yt8wVUq0pvqZ9tuwaNeCBnCBHtEYN5iua9oR7D+rGvqKx7SbmW4hjEvgYa7p4ebKu1TE
         +JCyq6oCJXJ5rnvPbB+PdoS+zcl/9VGsPaYp06k2rKvV9rYXtCMrOdb2xDY98MiUhvCD
         lEdSdAJjkaDjDL72MyFSCDXHxJ4+2rZv+3BblS5n5sXm9VD8xbh7OS3WClnDaLMSFz2L
         qW3fp7zExm6H2WKT8G6wBIRfo75pT/AbrDU2zGH0UN9Kjzf04FGpSeEmK5h0WazJnenp
         v0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4122js9VzeoHge4cdqVUvNxYMN8/LRqY7OEquLQFbJQ=;
        b=Misz47MFd46Uxn6+ZGPsLtH8dj1Ps7Y/i/PhIMq1VrfMZzixO6HwzKimg79XAc03c6
         EiJS/hhzKdR3v8EsECJPLWQYOj5w5sSsEACOZa4oOvEO8+yd5AG+t1fKK1R+X5Atl2FF
         bFGCmxYKgX8iyBajvzepjy9Y075DPXRd5rLdE2UuQEIEMvsht9OgasKeBW/sDAebQiWO
         588Lw0ZmrszYKYFQTZdzvyWmuyR28j5z2YifWMZu56Hk9sRJLo7K+oCoS89OCWh5+VzY
         h030xLQM+H0wjwWQupwgyYaFCMxyEc+MeZHckVpmg3/HDm+5R6pqK7INtSYAbqixxDjE
         SM1g==
X-Gm-Message-State: APjAAAX/FdqRwy0p8AxuuaOyI166rJ0gD49ZbYjDVe/7fpxag6xB84NI
        kf54o7wIRyDDQc6rxoW/T+QI7A==
X-Google-Smtp-Source: APXvYqzyICwgu2nsF0p3uEHmrh0rScEPh1VCeMpKC62Xdw4iwuAiKtc/bOayJ0c7xkb5C7wzKV4toQ==
X-Received: by 2002:a62:ac02:: with SMTP id v2mr29467462pfe.109.1569191227648;
        Sun, 22 Sep 2019 15:27:07 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id u10sm9477135pfm.71.2019.09.22.15.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 15:27:07 -0700 (PDT)
Date:   Sun, 22 Sep 2019 15:27:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Use the correct style for SPDX License
 Identifier
Message-ID: <20190922152705.59b66b0c@cakuba.netronome.com>
In-Reply-To: <20190921134522.GA3575@nishad>
References: <20190921134522.GA3575@nishad>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 19:15:25 +0530, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style
> in header file for Distributed Switch Architecture drivers.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied, thank you!
