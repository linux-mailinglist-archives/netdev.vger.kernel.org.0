Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBF13D7B04
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhG0Qdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhG0Qdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:33:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E14C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:33:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so5225511pjb.0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=OieTmgx++vvnOey4FYBOlU4qylF+YsYc6lMQN3Mi+Jo=;
        b=G93pfUYqTa0/mEU9bW1O8Ppvq1G7HktP9MTy8Iy+XZZj6H/gQSX/kKhExlityvGXuK
         H2kKfCp3r4+R4O/GPlAnwmB2KqTWoVZBG5sTlC/m6zvvbBTr44SUmq/F2dvyv10PV3V4
         NEyT+Nlz9PQg+Zgk4hVCXVo3xjsBPUrw8XGCZB8O+8uQ46DOBs4ClH2VTJ53raPqfw43
         hpEMCuXhJf9BheajXR9ocxUIMUla5KNOBSKi7Mt8wAkk01gIkFtIzoxUXs/CnmpSxfF2
         L1G7MFf0h2VqaTfkmoMDLuYOdkIB3YB7kBsB94PKbOwh/QbhgB5N+p1Lmwb4ttKkeYkA
         GByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OieTmgx++vvnOey4FYBOlU4qylF+YsYc6lMQN3Mi+Jo=;
        b=Q2BG7vjllqnKUtuCxywvueYWyV1D3JG8ZplyvHFFc1WdPl1i0IrHIR3hjKphsb3xgn
         aexnyqiZi6cCERLYJY3ukmyq2qCuvZEg8eM7zzAT+QNk8QXp7S8MAW531qDozysk2ptl
         XEKIqOF50BRqvP+5fVufQ4ZzQRQK5SFSZl1jmgOZ2o73nUL0t6t3QiT5AMR5fhqJOHyP
         Uo7GbKH5l0qYObprBUS/FcZt8RsszWpNxkGHqBaZw3r1Fa7B0/CiaGYCGq0b6v47GAUN
         8O0Y0D4AmdGaAg5BPfks2zjVkYqfvbbBPXsd9Xs54kyoajxYst/JVf+RLU3Mix85B9GY
         4yLw==
X-Gm-Message-State: AOAM531R/L0oFQwN81hPq4edZuKsc7asObI2HUyb698aKkVrhxnOcQiG
        MOtUH16tGY8nDrgPaC8omNs=
X-Google-Smtp-Source: ABdhPJxRMG5B4Ir8rVJGnLkA2zGyrEN/ZAWGGQwQfZHad/6ibIXnvcGGxv+a69Pm8vUFhD+lAemc/g==
X-Received: by 2002:a17:902:820f:b029:12b:a6a1:57f0 with SMTP id x15-20020a170902820fb029012ba6a157f0mr19615536pln.48.1627403631778;
        Tue, 27 Jul 2021 09:33:51 -0700 (PDT)
Received: from [192.168.150.112] ([49.206.114.8])
        by smtp.gmail.com with ESMTPSA id z13sm4402154pfn.94.2021.07.27.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:33:50 -0700 (PDT)
Message-ID: <b9f79fa651c025456b1cd8b071210480b0733348.camel@gmail.com>
Subject: Re: [PATCH iproute2-next] ipneigh: add support to print brief
 output of neigh cache in tabular format
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Date:   Tue, 27 Jul 2021 22:03:48 +0530
In-Reply-To: <390278ce-2405-ae9e-9b07-ea8c699d762c@gmail.com>
References: <20210725153913.3316181-1-gokulkumar792@gmail.com>
         <390278ce-2405-ae9e-9b07-ea8c699d762c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-26 at 15:09 -0600, David Ahern wrote:
> On 7/25/21 9:39 AM, Gokul Sivakumar wrote:
> > Make use of the already available brief flag and print the basic details of
> > the IPv4 or IPv6 neighbour cache in a tabular format for better readability
> > when the brief output is expected.
> > 
> > $ ip -br neigh
> > bridge0          172.16.12.100                           b0:fc:36:2f:07:43
> > bridge0          172.16.12.174                           8c:16:45:2f:bc:1c
> > bridge0          172.16.12.250                           04:d9:f5:c1:0c:74
> > bridge0          fe80::267b:9f70:745e:d54d               b0:fc:36:2f:07:43
> > bridge0          fd16:a115:6a62:0:8744:efa1:9933:2c4c    8c:16:45:2f:bc:1c
> > bridge0          fe80::6d9:f5ff:fec1:c74                 04:d9:f5:c1:0c:74
> 
> I am guessing you put the device first to be consistent with the output
> for the other 2 commands.

Yes, that was my initial thought.

> In this case I think the network address should be first then device and
> lladdr which is consistent with existing output just removing 'dev'
> keyword and flags.

I understand, will send an updated v2 patch now to print the brief output with 
columns in the order that you are suggesting.

Thanks.

