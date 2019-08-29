Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422D7A28B1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfH2VP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:15:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34768 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfH2VPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:15:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so5629826edb.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 14:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hS3H3Fejm2Ld774V0kLGhVDnZ7eJ/Yrt7rdUWYJLuoM=;
        b=JHGw61XpDQ9qnqJjDlskimJniYIpe80UT31I54hzhlwkNrwJdOXVB7tFd/WP7WpaEI
         n0tUYc3qXXL9vzjDC/ggBWHuTXd4Zw7o6AMgzRNZXgOYt3D70CLylInM/ujPlx2fjIM/
         5jD1M0KKWYd+76MH/4apoF3xHOQgdtgJuwQW2VFjGsWQ80gR1mLQCGhP0m33LmOL6YpN
         JGqJDDBCCH7aWJRnWF0Ngnxb0ZdiCV5z+LPr6A3eFpV1cSjrQp9NiM/SrO8ZQcsr8RB2
         ucfFURwBmugSzfO9gwGkewrlfFUtfHSMh3Q+4j1aSAXjWJj1D5kvSkAV9lHf6KbUKDoO
         Vw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hS3H3Fejm2Ld774V0kLGhVDnZ7eJ/Yrt7rdUWYJLuoM=;
        b=AhFUFr74pa/zQrk+UBN92gQAIlzKRbGNSRumo88gGwS60f7wW8ZeIlee8R4ZZB9HCY
         yYYSoZdaT9v/sn6RkgEjWeLp6gkdNjQWfXQ/mH/8Haqkz5P12JvxHMbwLZXKLh61s9oS
         kK6gEWjnQn0n/t0uMSLbrPf34Oc8NWXQElRNjI4HDzOyI+tfLtjTz1FUnw+X9f7R8rit
         7FTI2TZm9zxXolBBbtqtaTTnFnPPIJt1XMQ1njejfPzdfErFk+Hpwd25fVHLGvfHVl6G
         wx2vdRh4IMJg/n7yyZyZWdfo9WBQvmoEeKF273SlkQBsLX7n2uL0wKavq5rCdxPKr+sn
         Xefg==
X-Gm-Message-State: APjAAAXBFVx0LIGCwocqgMMe351tHfthf8lpczCjuP1yN0yCC+5dBDmA
        aPzLnA/eE5Qc0YHOfBxfmONh5w==
X-Google-Smtp-Source: APXvYqyGVMQtZA1SqbkLWfBw96/KNVS3JYfw9CNvXDg9o/pN/JnASnJoDjrfTrcZwqQd33q4FUbBtg==
X-Received: by 2002:a05:6402:170f:: with SMTP id y15mr12624176edu.55.1567113350852;
        Thu, 29 Aug 2019 14:15:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id jr2sm529163ejb.13.2019.08.29.14.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 14:15:50 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:15:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/15] ioc3-eth improvements
Message-ID: <20190829141525.7b56791e@cakuba.netronome.com>
In-Reply-To: <20190829155014.9229-1-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 17:49:58 +0200, Thomas Bogendoerfer wrote:
> In my patch series for splitting out the serial code from ioc3-eth
> by using a MFD device there was one big patch for ioc3-eth.c,
> which wasn't really usefull for reviews. This series contains the
> ioc3-eth changes splitted in smaller steps and few more cleanups.
> Only the conversion to MFD will be done later in a different series.
> 
> Changes in v2:
> - use net_err_ratelimited for printing various ioc3 errors
> - added missing clearing of rx buf valid flags into ioc3_alloc_rings
> - use __func__ for printing out of memory messages

Only a few more comments on patch 5, otherwise looks good!
