Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D8513B25
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfEDQO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:14:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34073 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:14:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id b3so4477630pfd.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7w1yvQaiks6DAQUx89ULVAINRnVEbHEMWXBhS9ClnV0=;
        b=C+zu8W+ZPRNcMZZantBfgRHzRIOYf27qEKJEjkLdkxZPfqqV7nUm6l7nBbd7MmF5wg
         cTCb/UTWVRalS0L6h3+oNUymdcoNbrT1q64ckRoFX74KotcG7T1zqPV9heBP5nNM9eZa
         f6AcriorswnwCuo7/57oqoOLXUXkbV69e5z7/OSkBOOO/QHMgcGYeDMmGP+d0LFT+RRQ
         eHEjOIV+0EVnXSULk/PtptyXmG5LuzTdWUrGl2OsiPxQG06NStmKK2BXlLo31cC6ONhS
         6Mn7QbtPxYFY7Nrea5/v1veQB6PeP/1yEisR/b1vznxchr9OB/m+nUaIcAswptXH959W
         Yd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7w1yvQaiks6DAQUx89ULVAINRnVEbHEMWXBhS9ClnV0=;
        b=V1qifDrWJgJGlKvbH2nbwZ9BK726oxUSV0/9hJLWtFvFJ7bonIUiITgkJB2uxmEsWo
         qZfPC2kkBae4yPUAUXgT2jDeXpWow07J6At75zDGz9eoKgkspBisWtUU4MgRUcldNaTI
         JDKOuq1WR+vh0GaIaUHYeNxU2JlD1H+HhVyItPENhkm4juMcvzw/51v4/LyHB+TBGG10
         AzdkBCNJxcsX8QuGNwiKo3Ip2ciF692dOvP7ed7WRNnvrmrIaeH8rMX/mizTwTnMbA9i
         Mdznc00diufL5Lf5VSkqKXn4FikHGWz4kz7LWVfLD4SG+SFYLt3CV7qPZNlOYjv8i2o3
         Yr0g==
X-Gm-Message-State: APjAAAU7dD1SsZSUI3C/PRTog2sTvCq9juOCu3209iaQcuc5noPnaATg
        +TG0JYgsn4l00lJHo+UJ9Mx1LYWE
X-Google-Smtp-Source: APXvYqx/GVl0pBeRBQR7d7vjpnxLhLvF1r2Gi2kB/nJdCbBfn49Jc2ttRBtMHaSWmGzQH5Mv43RozQ==
X-Received: by 2002:aa7:8458:: with SMTP id r24mr20328202pfn.231.1556986496126;
        Sat, 04 May 2019 09:14:56 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ad89:69d7:57b3:6a28? ([2601:282:800:fd80:ad89:69d7:57b3:6a28])
        by smtp.googlemail.com with ESMTPSA id o3sm6543996pgk.84.2019.05.04.09.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:14:55 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] tc: add support for plug qdisc
To:     Paolo Abeni <pabeni@redhat.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <fe5c248b0eb19a2dd42bb1bff8a0c40c1e9e969f.1556640913.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <69ac0f81-76e6-391f-83df-727783f48956@gmail.com>
Date:   Sat, 4 May 2019 10:14:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <fe5c248b0eb19a2dd42bb1bff8a0c40c1e9e969f.1556640913.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 10:53 AM, Paolo Abeni wrote:
> sch_plug can be used to perform functional qdisc unit tests
> controlling explicitly the queuing behaviour from user-space.

Hi Paolo:
Do you have or are you planning to write unit tests?

> 
> Plug support lacks since its introduction in 2012. This change
> introduces basic support, to control the tc status.
> 
> v1 -> v2:
>  - use the SPDX identifier
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  tc/Makefile |  1 +
>  tc/q_plug.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 tc/q_plug.c
> 

applied to iproute2-next.


