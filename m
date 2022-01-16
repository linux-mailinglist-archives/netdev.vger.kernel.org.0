Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2848FF9C
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 00:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiAPXS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 18:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiAPXS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 18:18:56 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF7BC061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 15:18:55 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id v1so19369287ioj.10
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 15:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=nuUz27WFaBTUUHAOLZodnnPNPA5+GsDkqHPR75nYyIc=;
        b=DzHsGmtP2SUXUZc79e7AF3K8RV49VpFWyTLIGF/IOENj6fKvzzz3jKZ/a8Elstjibo
         Yh/Wmbp0R2y1jx2f+RQnSL1epZFonjxfn0P+GMh8PbinEmtEbnZs7DfA9zgr0Q96ltmS
         2FM7tetXvvvz2JM8UzKBJFe0t4CAPFwIb1eVhQmjDdq1r6EmVBqsOWHJH0UAHuWgekT6
         AgPQUHE7w/JI2jlABJ4zsn2WPgqVmBi1m/C3+DFZwNx0+cKTYmVUZixiYKKY8N9Ke2l7
         hVbvkKmRONrvP/XeEMBezhqk4Em/0r1ig/u8yjKzcHwnHJ4qmJb4XxRnOWqJJxU/xsxa
         3VYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nuUz27WFaBTUUHAOLZodnnPNPA5+GsDkqHPR75nYyIc=;
        b=WCVYLEDW7AhnB+n7y7KjxXKxVghkxHA/QdrCY0t2On2a+bCDAABeGRuEV7e2YBwxdI
         UtgrpwGjj2fN4jYK1przG37fIn/bT8MnktQvgGlr7mwAxkQU6LeGIs7hhSGAIqBdTCAV
         YMHiJHmf1YQHWasDyU53mKCED01TsUD+oazRWBYx0PsD1SJFpimittW6Mb1uKsb1S26G
         EyMtQ95qRca7FcILPms2Ww5CxPAMZT1GsBg9wvGlVbbQZgFnNFpLTCYsVArLC5cIGnG9
         1hbhn9zNe9fAJpHbhoUWkY7O78KnGK9Bg0HPjVXjQkHg1H0vCdFIxeAaTbc2k6vPwYOv
         Z5nA==
X-Gm-Message-State: AOAM532hLrcnxfZF0eqR3nxVbbYbbFwKDU3rRECcOME5EOfUfJHfYOMA
        3EVlFJL1b12DIcdtjEsfgpt+eI6UTJA=
X-Google-Smtp-Source: ABdhPJwz2082da0ypnx5WRvf42eU6OHU7vIhcAP93YWYK2OsnLZYRW1V05y05Aupv4YFuQ37Bmmfxg==
X-Received: by 2002:a5d:8244:: with SMTP id n4mr8904860ioo.27.1642375135336;
        Sun, 16 Jan 2022 15:18:55 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:c44f:a8d0:90d1:51c0? ([2601:282:800:dc80:c44f:a8d0:90d1:51c0])
        by smtp.googlemail.com with ESMTPSA id d7sm3443102ilq.0.2022.01.16.15.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 15:18:54 -0800 (PST)
Message-ID: <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com>
Date:   Sun, 16 Jan 2022 16:18:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 iproute2-next 00/11] clang warning fixes
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 10:54 AM, Stephen Hemminger wrote:
> This patch set makes iproute2-next main branch compile without warnings
> on Clang 11 (and probably later versions).
> 
> Still needs more testing before merge. There are likely to be some
> unnecessary output format changes from this.
> 

I think the tc patches are the only likely candidates. The
print_string_name_value conversion should be clean.

Jamal: As I recall you have a test suite for tc. Can you test this set?
