Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8AC1E3633
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgE0DHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0DHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:07:37 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56061C061A0F;
        Tue, 26 May 2020 20:07:37 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id a23so18133122qto.1;
        Tue, 26 May 2020 20:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T8gy+yFpfZ4hOGhvJE/RyIEn15jYLcBPiDAa2ro4zYM=;
        b=SW5yY8M0W6utAv+Rwz0EMaad8IwceEYJUj/yZnmudJJ39JxJf3MigMZV41kL3C6u5O
         N9hcG/lrX0WimeJrFvpx5MGascyoucbWNerRiIrzPKwSWp5xwF894VKc9Hm8rO+QUwy3
         1uHoKUHqIB4et8q1Y/03WutTpFll5UjD/42nKgEbUPzmvk+T9ay2Xn3gpfqZ6sw7K+j1
         jxa+Q/coRvSW0ACbfBpoAwsDMMQO+rNP22Gu9gbcDCZKf/QbUM6Ls+4P4e5YSP/ZAvrM
         FWkZcQTKJnHQfSIbUjpfIVqnKaQgXmkzukQb57YkIZH8/JAxNzj1fFA3xAt1MNd5JR8N
         DUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T8gy+yFpfZ4hOGhvJE/RyIEn15jYLcBPiDAa2ro4zYM=;
        b=iQCA624YS2VHyokQQbUGxV553YzknGFkSiqXqr7Kc5IV0aa9BciFNHSQh3XlSuWDXX
         381Is8JYqGwWvv54ujYuk4I/OJG7kcF+OviWj2TNrygzJCsSZZlk0pFR7VNr3VirK/Re
         OoCQMGdm4J6pySOgwoBFSa67nEFYgVRR3VIYtxSQN7DL0tfuCly5lhg2uCdE3hUOQej6
         Z48pl1OB2xET8mNzxMSegtGCiXxkvDcUnf/6L1TVu9odsNBFGBWRUXtVAOZkLOWQow5s
         1UCOpaaI3I2Xd8YQ6OzP35Yac71BxvzUfKmUPoWPhUPuX7sopnkgMAQpFsGUtS6npjtv
         ODgA==
X-Gm-Message-State: AOAM530lrQfOSadWQYQgwl4AJrguuygbCWlqCa8PwWEk/I0h60bJ4YeV
        tdq9/DkIIJzDPSCIyjb3iioNcbG5
X-Google-Smtp-Source: ABdhPJwciWHmVm5GcOYqRoQNOGOFIvYAgUKVFcVEySNNWnAgaKb2swwpVv39p2PB4oc9OjClkA5PEA==
X-Received: by 2002:aed:29c3:: with SMTP id o61mr2123077qtd.15.1590548856536;
        Tue, 26 May 2020 20:07:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id d16sm1460500qte.49.2020.05.26.20.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 20:07:35 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/4] RAW format dumps through RDMAtool
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200520102539.458983-1-leon@kernel.org>
 <acfe3236-0ab9-53ae-eb3b-7ff8a510e599@gmail.com>
 <20200527025921.GH100179@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d9606bc-8829-f6c2-e2d3-6aa4eabfa840@gmail.com>
Date:   Tue, 26 May 2020 21:07:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527025921.GH100179@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 8:59 PM, Leon Romanovsky wrote:
> 
> Yes, you remember correctly.
> 
> What should I write in the series to make it clear that the patches
> need to be reviewed but not merged yet due to on-going kernel
> submission?
> 
> We are not merging any code in RDMA that doesn't have corresponding
> parts in iproute2 or rdma-core.
> 
> Thanks
> 


Let's stick with labeling iproute2 patches RFC until they are ready to
be committed.
