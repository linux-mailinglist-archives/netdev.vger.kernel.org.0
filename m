Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225753EC48E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbhHNSqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhHNSqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:46:44 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D85C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:46:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso25821469pjb.2
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qMmEN6fkn5xOHO/gw7fO3+SKdn7CZIA19ThyKlT2o+0=;
        b=KvtAXQKUwI+rgoHB8s5wT2oyxo3ZPSrspSGQadJUc8D49bkdDBK6o1tw8/osHOKTa9
         NsdrbMhWyS50v+TR0pJ7/CL6vFOZgcCjPVaeYIN2h6HKWwJkWMlcKFBgpa60e26JlV22
         LYaInDqgYGrC4hMan/KUst2Je0uGFSYIXA9QnaPriI4ggExvzlLwjuJJIvhBaRz7XRty
         B/WBnGBbpSn+mRb/YWmBk86DV9SXdVKSPvD3qgo5RWT2SKWWAMBeWvpLFcm3bvojRT63
         YG75SdOg51X1KoJgmvV2u5PciyPE2ztwf88iGi8p6PBHXsTbFuUA+47gRgJHPh694p0Q
         YTaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qMmEN6fkn5xOHO/gw7fO3+SKdn7CZIA19ThyKlT2o+0=;
        b=kBtBTWxlRc/oRzs012RjKARXfqaXatKeZYed66D5rp5+l8Ab/3XrE8UgqLtKy9sBlo
         1wgRnEiUOJwLPGduTu0tpO7ErsKqZ7SWw/zshtspkUwQw1Xol2AAoVn/fQurNx8hZqX1
         OzbJUn6KZ9ZguOP4UAYUZogKBP9gYJy8POHbSSvHYmEDC5ZgTlkmk8u1AU1D2qd4YCPI
         yhQgiHGPcNFWdM0MJvrBAVZFu7bhe9LnoWoPdWZbtxF338nEtI5yvuH4xSBH3WEYRxZN
         b567lfzPexfZ0OuLYDj8LBI7eg2AOV4yU6PhbqmkV4kL/HWk82A/nOkGaSp+/aCIKyik
         6YHw==
X-Gm-Message-State: AOAM531kUWpX0DaO4H+iFGHXd+8DDjbJJX6EiGdlRvwnKlfLvxMU1ZMg
        2a+jJvLBcWePRPBUYQiY73JMMzvLuPcYntpz
X-Google-Smtp-Source: ABdhPJyuCzV6PJAfTfhrIbcR0mtHMYkalfzT6ZaXXr9zdR/ycsOEvtoMv7QklbyawDLIonomkRajYg==
X-Received: by 2002:a05:6a00:181e:b0:3e0:fc7e:50a4 with SMTP id y30-20020a056a00181e00b003e0fc7e50a4mr8226551pfa.0.1628966775614;
        Sat, 14 Aug 2021 11:46:15 -0700 (PDT)
Received: from [192.168.150.112] ([49.206.113.179])
        by smtp.gmail.com with ESMTPSA id y8sm6460353pfe.162.2021.08.14.11.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:46:15 -0700 (PDT)
Message-ID: <ed7f6a42edb01c203e1d6321124184820a23f1d0.camel@gmail.com>
Subject: Re: [PATCH iproute2-next 2/3] bridge: fdb: don't colorize the "dev"
 & "dst" keywords in "bridge -c fdb"
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Date:   Sun, 15 Aug 2021 00:16:12 +0530
In-Reply-To: <20210814092231.23513631@hermes.local>
References: <20210814095439.1736737-1-gokulkumar792@gmail.com>
         <20210814095439.1736737-3-gokulkumar792@gmail.com>
         <20210814092231.23513631@hermes.local>
Content-Type: text/plain; charset="UTF-7"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-08-14 at 09:22 -0700, Stephen Hemminger wrote:
+AD4 On Sat, 14 Aug 2021 15:24:38 +-0530
+AD4 Gokul Sivakumar +ADw-gokulkumar792+AEA-gmail.com+AD4 wrote:
+AD4 
+AD4 +AD4 +-	if (+ACE-filter+AF8-index +ACYAJg r-+AD4-ndm+AF8-ifindex) +AHs
+AD4 +AD4 +-		if (+ACE-is+AF8-json+AF8-context())
+AD4 +AD4 +-			fprintf(fp, +ACI-dev +ACI)+ADs
+AD4 
+AD4 This looks functionally correct, but please use:
+AD4             print+AF8-string(PRINT+AF8-FP, NULL, +ACI-dev +ACI, NULL)+ADs
+AD4 
+AD4 The reason as part of the json conversions I look for fprintf(fp
+AD4 as indicator of unconverted code.

Ok, thanks for the review. I will send an updated v2 patchset now
with the 2 newly added fprintf() calls replaced by print+AF8-string().


