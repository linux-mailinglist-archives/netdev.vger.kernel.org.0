Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9656EA61
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbfGSRxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:53:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42630 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGSRxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:53:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so14770688pgb.9
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iGPvaS6tOep7fRaUDJWwY9IkFV0/KggdJvA3ALwITQw=;
        b=hvQROMCLq3L5eZAkxO/KIRlTY9DIpBChOD6/tojKLvSA3S2yX1Z1aO8F+rZ2e4hUJg
         nMpoffYWm9TP1diQlKqHZHrFnDsvozVjUkYKNbETQZBMyytHkDFPKNbJVQ6sAZTXXT9e
         FCsLO/e2s4b8Tg5ozVsFhsGnlxx7g0YK99SgBLvG4Rb+FK0XBQaRO8fczVA6LQxv68dQ
         ScRCxQVoRCk6F9VZhs6Mz0T0IRIteNYUbyKISbk8aRskxTxFqI6HPYY93RPwsuQ5dSLM
         vzxaUhsXq0W4kusG5qehPxJJpiPUDobSMcZCJeZQS//QLU9CvTBEaOKNvG2SEh5ZqcnF
         9vDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGPvaS6tOep7fRaUDJWwY9IkFV0/KggdJvA3ALwITQw=;
        b=aNOhEsX8e/ilv1I7+Jm3dGjeDXrrQjVBBtbacHR5C++VOCJts/Ub7qvnEzInNKHWuM
         tmPVYmb7gpja16gfVX6OoCQB5gE9OTWOHgfB8EhH1nqWkGWVnaOKa4yu8fzWPRDrLY8c
         x+6usrexTrZG8LIp9ey+rxE9ftAmYvQ7rgtjTQVI81pQWm8UKyRXM0yDf351B/LDj9Wg
         iZ997E5VUn++fPSq4xOuQ3Wc21ZDYTPSQMPzepKPiVJqovLiLUbX+gFvU6Wzsw5hAh56
         XilcQ1+yR6/BParmHzOlPJ6pq8V7k5J0RQcGMZCf1E+cE2+b2O2CJRDY3DSc1gWA6DTK
         G6Gw==
X-Gm-Message-State: APjAAAXEH9aaqh68tvHNxdPean7BMPn28gx5QIn9UgspruvNAFz13Usj
        Keda2Z1yHZoYE0n6u59dU5Q=
X-Google-Smtp-Source: APXvYqwib9BkocGO+RxsJnw9zvThJEdIsAOzsdb7zIqPuBLadwJZmCDwMhH0B/wItsIJyQIMkkPewg==
X-Received: by 2002:a17:90a:2305:: with SMTP id f5mr62219338pje.128.1563558826591;
        Fri, 19 Jul 2019 10:53:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a20sm26261877pjo.0.2019.07.19.10.53.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 10:53:46 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:53:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc v1 0/7] Statistics counter support
Message-ID: <20190719105339.36432e1b@hermes.lan>
In-Reply-To: <20190717143157.27205-1-leon@kernel.org>
References: <20190717143157.27205-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jul 2019 17:31:49 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog v0->v1:
>  * Fixed typo in manual page (Gal)
>  * Rebased on top of d035cc1b "ip tunnel: warn when changing IPv6 tunnel without tunnel name"
>  * Dropped update header file because it was already merged.
> 
> ---------------------------------------------------------------------------------------
> 
> Hi,
> 
> This is supplementary part of accepted to rdma-next kernel series,
> that kernel series provided an option to get various counters: global
> and per-objects.
> 
> Currently, all counters are printed in format similar to other
> device/link properties, while "-p" option will print them in table like
> format.
> 
> [leonro@server ~]$ rdma stat show
> link mlx5_0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests
> 0 out_of_buffer 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err
> 0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error
> 0 resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0
> req_remote_access_errors 0 resp_remote_access_errors 0
> resp_cqe_flush_error 0 req_cqe_flush_error 0 rp_cnp_ignored 0
> rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0
> 
> [leonro@server ~]$ rdma stat show -p
> link mlx5_0/1
> 	rx_write_requests 0
> 	rx_read_requests 0
> 	rx_atomic_requests 0
> 	out_of_buffer 0
> 	duplicate_request 0
> 	rnr_nak_retry_err 0
> 	packet_seq_err 0
> 	implied_nak_seq_err 0
> 	local_ack_timeout_err 0
> 	resp_local_length_error 0
> 	resp_cqe_error 0
> 	req_cqe_error 0
> 	req_remote_invalid_request 0
> 	req_remote_access_errors 0
> 	resp_remote_access_errors 0
> 	resp_cqe_flush_error 0
> 	req_cqe_flush_error 0
> 	rp_cnp_ignored 0
> 	rp_cnp_handled 0
> 	np_ecn_marked_roce_packets 0
> 	np_cnp_sent 0
> 
> Thanks
> 
> Mark Zhang (7):
>   rdma: Add "stat qp show" support
>   rdma: Add get per-port counter mode support
>   rdma: Add rdma statistic counter per-port auto mode support
>   rdma: Make get_port_from_argv() returns valid port in strict port mode
>   rdma: Add stat manual mode support
>   rdma: Add default counter show support
>   rdma: Document counter statistic
> 
>  man/man8/rdma-dev.8       |   1 +
>  man/man8/rdma-link.8      |   1 +
>  man/man8/rdma-resource.8  |   1 +
>  man/man8/rdma-statistic.8 | 167 +++++++++
>  man/man8/rdma.8           |   7 +-
>  rdma/Makefile             |   2 +-
>  rdma/rdma.c               |   3 +-
>  rdma/rdma.h               |   1 +
>  rdma/stat.c               | 759 ++++++++++++++++++++++++++++++++++++++
>  rdma/utils.c              |  17 +-
>  10 files changed, 954 insertions(+), 5 deletions(-)
>  create mode 100644 man/man8/rdma-statistic.8
>  create mode 100644 rdma/stat.c
> 
> --
> 2.20.1
> 

Applied now, thanks
