Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7594860C3C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 22:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfGEUTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 16:19:43 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43800 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfGEUTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 16:19:43 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so8751177qka.10
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 13:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=a94rPwiDKZBynDwcIq7yFbwkjjIuPyUKO7AfOFCvAuU=;
        b=UvE+RGmJSRLlC9P58kULI19PU418zqZ+AjTd1NcOD2JP92DtS2P2prHebhyM8MpqCT
         gkWTt+j45AVEw9tcZHT09DWpannAE4U1apPEd+aPm5HciPNmzVBnINOyY7EGhUeN4fEi
         WOZ4oNndPNMbjK9rAudHDyDCw2lhkb84DFF1/y6X+UirymKLmCzqk9sA3tDdhcRxDBWx
         hMQ9QoWWn3W9uParjPJ2C+PIjrpnYaMjrL9IRZW5FvnQz+Eju26NlroyXYqnWQbzztsb
         h8gd6vRObWmmh86QNLpxD/7jeoZOXBnYSil3210g73E1JgbX1eDwdioOP3Ef/pCpO284
         WrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=a94rPwiDKZBynDwcIq7yFbwkjjIuPyUKO7AfOFCvAuU=;
        b=E8qS4xY2VIt5+Nz2kltEQ7z7W1HevLeetrHGZCsm/TvNqf84bvb20QtnOAvADkTU2B
         qxpcvC25n+whKaicRWvYpKMFaRNH+j3QrxMC0H9Hj+NdT/mEdOLXZZBTOafR0haddVyp
         jXf8bvkdMlMN/i4o7v5GBIlc3antHXlCNS72kygCjuAiCm/KH2EiOb4Aay+eK5qenRGw
         QULDcTNbzYfvDEV618DJN/wQ40mcnFgUEq2FA2yPn3LAw9cYhwhdoBanVwZ3mRzIQl9A
         6+/lWGel76SOfJNn0FeYZl7v5vImWrX1+KGTRRrDTWszZUFUisZbj0pgIKizD0ZFShX3
         2U5w==
X-Gm-Message-State: APjAAAUtg3xKTQWq2MkY/Rj07UkU9Ovd+bBbag+LOZ1Q7IiBC6ORxY34
        COe8YcLI4p6CFlwGuGE3VjC8IHJ16Yc=
X-Google-Smtp-Source: APXvYqwt8i8yUpa0wiPkyjQV1ea5mLGBLO6f1oGBB3qaXxEaWFC53pUqBz6YPtwo5N6mdEt6XWO4aA==
X-Received: by 2002:a37:aa10:: with SMTP id t16mr2990301qke.332.1562357982519;
        Fri, 05 Jul 2019 13:19:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c18sm3971611qkk.73.2019.07.05.13.19.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 13:19:42 -0700 (PDT)
Date:   Fri, 5 Jul 2019 13:19:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Message-ID: <20190705131938.43b889ff@cakuba.netronome.com>
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 18:30:10 +0300, Tariq Toukan wrote:
> Hi Dave,
> 
> This series from Eran and me, adds TLS TX HW offload support to
> the mlx5 driver.
> 
> This offloads the kTLS encryption process from kernel to the 
> Mellanox NIC, saving CPU cycles and improving utilization.
> 
> Upon a new TLS connection request, driver is responsible to create
> a dedicated HW context and configure it according to the crypto info,
> so HW can do the encryption itself.
> 
> When the HW context gets out-of-sync (i.e. due to packets retransmission),
> driver is responsible for the re-sync process.
> This is done by posting special resync descriptors to the HW.
> 
> Feature is supported on Mellanox Connect-X 6DX, and newer.
> Series was tested on SimX simulator.
> 
> Series generated against net-next commit [1], with Saeed's request pulled [2]:
> 
> [1] c4cde5804d51 Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2019-07-04-v2
> 
> Changes from last pull request:
> Fixed comments from Jakub:
> Patch 4:
> - Replace zero  memset with a call to memzero_explicit().
> Patch 11:
> - Fix stats counters names.
> - Drop TLS SKB with non-matching netdev.

You guys probably really want to make 5.3 with this, so please feel free
to follow up on the comments to patch 12 separately.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
