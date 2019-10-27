Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24915E6481
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfJ0RZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 13:25:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36436 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfJ0RZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 13:25:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so4895239pgk.3;
        Sun, 27 Oct 2019 10:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J5kRa1HrIBqZ9C8hLLWifHat3GVoLBM4/UKYdlK/LY0=;
        b=S1x9yYy7WzVfKjqn9nHtdKF3LRZeAn/DlcUcvQ4JnquccgqAekxNNDiAg5W7ch/GNX
         hrkYdwt94FCKA+KUsa0QJLfT2E5gvzNEej7HFSuKZYj4YKEtbW6W2YvifwAyc2U4Tdb7
         spcvvJtgv8CDkPe26h/PvWqNadEtx17VNgDD6JLdITWUD242pA0zmdZ+pI1q1cTonSRI
         MAkGdJfUze2+g2jTSSAdQFWQj3Ni7zLZArNYMAWCDwTpQrs9kCacNvR6SbGMa3OGIBAH
         S7riE+bR7IZP6ach7CumQ4O2vLbe8/61JRInBBV/CEckbWxpp2eiZ278pdPMVD2u5Waf
         mwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5kRa1HrIBqZ9C8hLLWifHat3GVoLBM4/UKYdlK/LY0=;
        b=qIzhBf0cqdRpiKS87RB1mv88TJMHyorgycaApsQqYpeoE32gmianz8yeiwZQKOKoBq
         tWP7e9QXXT0+6iZauNgrCvDORKE7U0WtQawCITGqcPKs+dVCobn6VgM/+FKapzQw/Ak/
         9hBiDTp6chehrjtW0uvxd5oBmL/bz4Ga3o0oE9ojAw7S/f0czdKidxvTMfTSw3El7a6x
         RCnnlTaAxV45qy/XTZfrGslrwQLlaf5gVztMxpE+f8mvbzvGx7bKGYslmFEhgNuF2FgN
         pCL7+cm5lholBNzPw6u6gneBRvjSnwYdSuUcoQCsYgMkHHvI76ax13ip3JpqouQuLsVt
         ID6w==
X-Gm-Message-State: APjAAAUlaB9xJicU82kox44rSS1SaFWoiLVaFpESj/fR9qGBl8w6Sgwo
        VQNqjPILQh1V9xKvkYBURuw=
X-Google-Smtp-Source: APXvYqwsx88qhINGq1e2flUeIYqasiOCpZOcbSZUAE57dgnYugJSj4+JUEUxj83apB197nqc2wOF3A==
X-Received: by 2002:a17:90a:dd43:: with SMTP id u3mr17709531pjv.130.1572197119032;
        Sun, 27 Oct 2019 10:25:19 -0700 (PDT)
Received: from [172.27.227.183] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b16sm11288464pfb.54.2019.10.27.10.25.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 10:25:17 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] Add MR counters statistics
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191023103854.5981-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ddecfe1-12d9-0e3a-b1c3-b2919a4e7030@gmail.com>
Date:   Sun, 27 Oct 2019 11:25:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191023103854.5981-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/19 4:38 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This is supplementary part of "ODP information and statistics"
> kernel series.
> https://lore.kernel.org/linux-rdma/20191016062308.11886-1-leon@kernel.org
> 
> Thanks
> 
> Erez Alfasi (2):
>   rdma: Add "stat show mr" support
>   rdma: Document MR statistics
> 
>  man/man8/rdma-statistic.8 | 25 +++++++----
>  rdma/Makefile             |  2 +-
>  rdma/res.c                |  8 ++++
>  rdma/stat-mr.c            | 88 +++++++++++++++++++++++++++++++++++++++
>  rdma/stat.c               |  5 ++-
>  rdma/stat.h               | 26 ++++++++++++
>  6 files changed, 144 insertions(+), 10 deletions(-)
>  create mode 100644 rdma/stat-mr.c
>  create mode 100644 rdma/stat.h
> 
> --
> 2.20.1
> 

Applied to iproute2-next. Thanks,
