Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4583B2DF8
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFXLhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhFXLhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 07:37:52 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670A7C061574;
        Thu, 24 Jun 2021 04:35:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bb10-20020a17090b008ab029016eef083425so5702482pjb.5;
        Thu, 24 Jun 2021 04:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5fbxh/5VAWoh2a2iqJ4ShFdp7c6ygfNf5JJPqxsGBW0=;
        b=CBeVgQ18DBl/KEDhp9RjDv+CWyRTPhA70WUl6Eq6zG2Eh4O1EkXc7q8BQPPxXvHL0d
         IYiF91sJkbYFAhyxh5xAMjthoujiyK7DwWu3I0u5BPQSCDit/z3ge0ZyirL3vwHoRzc0
         GHBzDktR683TDOwb+OdESTTD19NcYIIOnYJdWOw/Ua0a2C4n1CkbRATqL+RD9mEsHdGd
         by/wnP7e7ljVPo4WEqAnzTPmt2DF/Wyz8OiTwDx+Z08E5f/gnzgZ7eEoKrlLb6mPxLM0
         pcjM8ZPq4ZrUjxZlQ5GPEZg9V9kUo7Meab+BJOk8s9yfFo+n7QepA7O1KhF5TC2mO5DZ
         DNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5fbxh/5VAWoh2a2iqJ4ShFdp7c6ygfNf5JJPqxsGBW0=;
        b=Yn+JATKCfpsluJpShU8VSA/IlJ2tk8TNbMVYQrdm+KZlKFAdcA6Mx54FNUKafNV5TR
         iYRO6Ptxc7BVwzys7hDk40UNRSB4jXgZjPl2dwAntGJSMU6e3QqiaWsBAD/CgwOLhYgs
         Q0r30kezn7fei5ze6g7/g4tWtNAU8XNV+sJ7+NOcGRUPO5YWLAx98RBuyBG0yzQ0yrag
         2kWlCOPPqNkbWbZ4LELpNe1p0gUnz5kcKmoREGwi7HME7G6FvexTdDBiHDEyK91UcAx2
         h+s9uRDjerZyL2jOZHk0nZxUCRAyjbk/td5pfcWvx5/e7O6wRhe1UMR7+Jo2pxAarM9b
         Ux2g==
X-Gm-Message-State: AOAM530Ab/DFk8IfRtoXkPoBYtp5Qv66qcIipqODGZzT9jROU+dFCGbH
        Jm++PWQynXBY+9wTnoiT4P8=
X-Google-Smtp-Source: ABdhPJyqAtCNwVRVd25OYX02VeZWBbjsMFCRxxApl++5lb/Zm6XOEV7KFPDeXiTBJezI/VKygEdMCA==
X-Received: by 2002:a17:902:b105:b029:127:9159:65e3 with SMTP id q5-20020a170902b105b0290127915965e3mr3879272plr.80.1624534532023;
        Thu, 24 Jun 2021 04:35:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h8sm2428058pjf.7.2021.06.24.04.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:35:31 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 24 Jun 2021 19:34:56 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/19] staging: qlge: add qlge_* prefix to avoid namespace
 clashes
Message-ID: <20210624113456.ofqdpdowmqifshnj@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-5-coiby.xu@gmail.com>
 <YNGXfu/wGcKTuJYA@d3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YNGXfu/wGcKTuJYA@d3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 04:55:42PM +0900, Benjamin Poirier wrote:
>On 2021-06-21 21:48 +0800, Coiby Xu wrote:
>> This patch extends commit f8c047be540197ec69cde33e00e82d23961459ea
>> ("staging: qlge: use qlge_* prefix to avoid namespace clashes with other qlogic drivers")
>> to add qlge_ prefix to rx_ring and tx_ring related structures.
>
>There are still many struct, defines and enums in qlge.h which don't
>have a prefix or mix ql_ and qlge_, some of which conflict with other
>instances elsewhere in the kernel.
>ex: QL_ADAPTER_UP
>
>I think they should all be changed, not just the ones have a conflict
>today.

I'll fix them in next version. Thanks for the reminder!

-- 
Best regards,
Coiby
