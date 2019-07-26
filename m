Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5DD772B6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387437AbfGZUZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:25:02 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42265 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfGZUZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:25:02 -0400
Received: by mail-wr1-f43.google.com with SMTP id x1so5726774wrr.9;
        Fri, 26 Jul 2019 13:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HHa17vzHiWrmjHIgGNiq1sBSijdQrhuWsaVzln+Qeqo=;
        b=NqYanJMeMlq7f59a5Vx+cpN4OhiLYHISnSWuGi10y8cX0lZ8SwUE/nEjE6gJaQxCLZ
         vH6G85BNMWNP5MwNCtd3ggpJkONNQEPLA/Aj6ifxIOEBoC4q5lon3pTtlpmCR96gFWVH
         VB8wH04xYTrBu9jWagarmMvOhd/CoI2Glwd8PDwwhDzsThfVSTswY6+TsflbqN5FTQD5
         ErsnzeDaTh0J095GiBgFMxQb7vHIy9Ee9u5CK9GuoMBLzMmZV8UhNYe8M+/ZxMl9uXkL
         zdPax2murb+DLnUM80uLYlaCjzf+bp7Xv+lyYCqcrJeXfkphh0VlQwIAwLubQ5JHSlVA
         yy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHa17vzHiWrmjHIgGNiq1sBSijdQrhuWsaVzln+Qeqo=;
        b=JLd2LUcIlfQmWIckmMj2AKK/Eg5DYWgbjFRAe5vCiAOJ1XK27fAX0N0ANHa2+bpGgj
         RrF6nDkwBh2M6bmZoaxlS1r25jCLL5bbn5SkAb5Ab4CYREJL4lPbL+iTnDI5tWrKK0MC
         792Q99ANhat1o2FSZl2zfNpaw2JsuJWgtYtpKdjbt1Rqy/gcFd57fVT7GBs1pOXrRP2l
         zRwwdFE/+EQ2g9VazuAX+FhVEsce/tY2jiGX7hfzCmO/k83WWpg5Gv5P8Dyktbjhopud
         Af2w8QomWJoOHxLJbmlSlV+VetUhYGSND3f3HV+Ba96xfzvJxx7RWvDWBaoz6Jfe8Y+v
         YlgQ==
X-Gm-Message-State: APjAAAUB9fwOlxnuo1gkWLfPm+rY7a43iSZC1ortz+qVWxKXaoUWzanI
        V4aEZqFto5CHhHcWRbIp45Y=
X-Google-Smtp-Source: APXvYqwI/jKDZZBIgzVuqZkeovAMfFMCa09B4bwsnOveIrm8rzZDQQbInVD0IpbVLhJ30EZ5bO18PA==
X-Received: by 2002:adf:f28a:: with SMTP id k10mr25374515wro.343.1564172700616;
        Fri, 26 Jul 2019 13:25:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id r5sm56829890wmh.35.2019.07.26.13.24.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 13:24:59 -0700 (PDT)
Subject: Re: [REGRESSION] 5.3-rc1: r8169: remove 1000/Half from supported
 modes
To:     Bernhard Held <berny156@gmx.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
References: <a291af45-310c-8b60-ae7e-392e73e3bad1@gmx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0a48ecd7-7134-222d-833d-c1f65e055c02@gmail.com>
Date:   Fri, 26 Jul 2019 22:24:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a291af45-310c-8b60-ae7e-392e73e3bad1@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.07.2019 22:16, Bernhard Held wrote:
> Hi Heiner,
> 
> with commit a6851c613fd7 "r8169: remove 1000/Half from supported modes" my RTL8111B GB-link stops working. It thinks that it established a link, however nothing is actually transmitted. Setting the mode with `mii-tool -F 100baseTx-HD` establishes a successful connection.
> 
Can you provide standard ethtool output w/ and w/o this patch? Also a full dmesg output
with the patch would be helpful.
Is "100baseTx-HD" a typo and you mean GBit? And any special reason why you set half duplex?

> Reverting a6851c613fd7 (while considering the file name change) fixes autonegotiation for me.
> 
> Kind regards
> Bernhard
> 
Heiner
