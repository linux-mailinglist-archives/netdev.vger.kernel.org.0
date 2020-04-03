Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A90719D963
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391072AbgDCOpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:45:10 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:38437 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgDCOpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:45:10 -0400
Received: by mail-qv1-f67.google.com with SMTP id p60so3682279qva.5;
        Fri, 03 Apr 2020 07:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MqUKZEQW4ktugpJoN6yg32u1OINgXC5Ef9CKI/ulXcE=;
        b=qHuagVSw8AoY49GuqNt4Gyp4jl3Y5A6Zny5YowwmaLIOfUdkYqgJrdhGbLqAbimiOd
         IWVRwHVhkr5RChCnMkes71SpREXTrBmXtegDcscwc3bIqR71AJW0Lgxu+I0+Yl5TFmzy
         akUWBL5VTWVFteCSVIoQRGM8dGqqLIVdX16P+sSXDAZhNrPmnHuOc/lxMlLaIUZ05MrD
         TxkS3mAR4Kn6N3Z08aEICPf0TNg3yyw/OYdL1SLobcYzYmO3TlUCYSQiVcbyrwo2s/EV
         I558rvJoaucMCbX7w+2g7eQdntMf+OaN5JtcILeNSEJcKHCa5C3E5HuyrDSUU9MUp3Bn
         GqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MqUKZEQW4ktugpJoN6yg32u1OINgXC5Ef9CKI/ulXcE=;
        b=BRxB7EsXrsBZkwaDuS2Lk2RGxO9m3/7xCxV1609IIvMy623IAeVprvq88X98NgEJsG
         aziyySMiPPCDJknSv/U0FRGDco9l6GNvFh/dJ4pxi6AP5jgDvugMVNabAfH1/rt+Oq7C
         GqNCq7c00sRuLtlATWuG0s1a7RZL4yd8jjNgC5OalbJvMAAqTkcXPPmmvupsMjSmH1yU
         krx0lumrTY1lRSuMgAORaH2nTcMXQkYUM7Kx/zHa2NiPSsSEubV/jTeO6eXGu0TMju9h
         ftU7MnTqXcSdnAg5jGd8pOC2+gnHXj2VpAWYaLhtudCZnnWnNuqeBCkpQsHxo31mBg8r
         QFLw==
X-Gm-Message-State: AGi0PubO0RbTtxKUVpT01/79Ewyc9qb9l76oJLCyZMz9PKrjt548Tu6v
        K3NSCxTsuP/CJmNVK865Hag=
X-Google-Smtp-Source: APiQypLKMJyOaqljvYwCu2gv/ka32v9q7O0r9h0E8LAU7t2Pefkn+ucevHTCNlTgoA2NZ462wjrbXw==
X-Received: by 2002:a0c:a284:: with SMTP id g4mr8384614qva.131.1585925107631;
        Fri, 03 Apr 2020 07:45:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::842b])
        by smtp.gmail.com with ESMTPSA id r3sm6469393qkd.3.2020.04.03.07.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 07:45:07 -0700 (PDT)
Date:   Fri, 3 Apr 2020 10:45:05 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        netdev@vger.kernel.org, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Message-ID: <20200403144505.GZ162390@mtj.duckdns.org>
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
 <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 05:37:17PM +0300, Konstantin Khlebnikov wrote:
> > How would this work with things like inetd? Would it make sense to associate the
> > socket on the first actual send/recv?
> 
> First send/recv seems too intrusive.

Intrusive in terms of?

> Setsockopt to change association to current cgroup (or by id) seems more reasonable.

I'm not sure about exposing it as an explicit interface.

Thanks.

-- 
tejun
