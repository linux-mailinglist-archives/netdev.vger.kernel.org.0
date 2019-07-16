Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89AA6AF81
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbfGPTBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:01:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45566 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfGPTBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:01:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so9538627pfq.12
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BWIbzxSA7URw2KomYKGJvPyHtNEDhxY/2R80Q7H8wmg=;
        b=GtnzJZlX5U7uGAyRvDby/8uuD3lzllEvwEbPNHzIKsrVIhwEhQRXycROPL9pOvJZx3
         9rxaCBq1dIjA9NqN0p80Ax2iWsDTvnqZNo5jC5Ebq+rOH+Y21fxsfgeUfvDIaZTo3Lbr
         f+9+EOwa5MGZcFEZHAYrw9mv9NYFTm5MAcjQRp751zofaK97AnVV7ab7vDspEAR3N+CW
         o8IO/M3obJq4+juvu2teTH5I1eEnOdRUAo/lYInaV0oJ8ZbZ6O71Wb2axAUJ2XA23cPz
         7LiAAEsooseZDKPdWYZi+laklQikEmDKuPiqEcP6V3fknCcllAWvpjRYd9wjzalgStmq
         KtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BWIbzxSA7URw2KomYKGJvPyHtNEDhxY/2R80Q7H8wmg=;
        b=Y2Ua6c5oZkQt1Dhg29ZuE4UPUFFy+Xd9YapntOlUsJO0Lys6EQWksuxMnpbJvXp3j0
         7Vfy6a+KxC3N3diDRKwFb6U7elkaSZ++N5ZB/e/EdiHwyG9oXGvqva7AH0dQNroVsp4U
         xR9ZZgkJcuUqtHoC+tcmJND4myV68ULEBjg2A0ZUbs8iUw3DpquWU2/9PJXXj5tfgRcQ
         wPYSxlv6WVmZHrBDW9dACUWu+3yOSKXrwYNUKm5gx2flt7/meNaMM3LvO50NMoUs3lXi
         2IppCjxdiyMMo0g0UAaKs7+fUIdCS/2rKKfKfoep9xEncxgFzKdvoni6lopbD2PxqSIW
         31dg==
X-Gm-Message-State: APjAAAWETJ+ZUwpLNBYSmB+iTfuM5GEpwxigm64QFFYjswnc7//japWe
        00H8EK6ywr7B5AfDZSHKUGcsBnBQ
X-Google-Smtp-Source: APXvYqyeTqUPdnh1qrKYnkb/2/4hthhKH+JShMoOCdcjcvbrTTjGpwP8ohC74IEZtXcmK9zUId0Ffg==
X-Received: by 2002:a17:90a:1b48:: with SMTP id q66mr37038674pjq.83.1563303695136;
        Tue, 16 Jul 2019 12:01:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g66sm21891830pfb.44.2019.07.16.12.01.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 12:01:35 -0700 (PDT)
Date:   Tue, 16 Jul 2019 12:01:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc 2/8] rdma: Add "stat qp show" support
Message-ID: <20190716120128.6beab22e@hermes.lan>
In-Reply-To: <20190710072455.9125-3-leon@kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
        <20190710072455.9125-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jul 2019 10:24:49 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Mark Zhang <markz@mellanox.com>
> 
> This patch presents link, id, task name, lqpn, as well as all sub
> counters of a QP counter.
> A QP counter is a dynamically allocated statistic counter that is
> bound with one or more QPs. It has several sub-counters, each is
> used for a different purpose.
> 
> Examples:
> $ rdma stat qp show
> link mlx5_2/1 cntn 5 pid 31609 comm client.1 rx_write_requests 0
> rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 out_of_sequence 0
> duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0
> implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0
> resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0
> req_remote_access_errors 0 resp_remote_access_errors 0
> resp_cqe_flush_error 0 req_cqe_flush_error 0
>     LQPN: <178>
> $ rdma stat show link rocep1s0f5/1
> link rocep1s0f5/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 duplicate_request 0
> rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0
> req_cqe_error 0 req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0 resp_cqe_flush_error 0
> req_cqe_flush_error 0 rp_cnp_ignored 0 rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0
> $ rdma stat show link rocep1s0f5/1 -p
> link rocep1s0f5/1
>     rx_write_requests 0
>     rx_read_requests 0
>     rx_atomic_requests 0
>     out_of_buffer 0
>     duplicate_request 0
>     rnr_nak_retry_err 0
>     packet_seq_err 0
>     implied_nak_seq_err 0
>     local_ack_timeout_err 0
>     resp_local_length_error 0
>     resp_cqe_error 0
>     req_cqe_error 0
>     req_remote_invalid_request 0
>     req_remote_access_errors 0
>     resp_remote_access_errors 0
>     resp_cqe_flush_error 0
>     req_cqe_flush_error 0
>     rp_cnp_ignored 0
>     rp_cnp_handled 0
>     np_ecn_marked_roce_packets 0
>     np_cnp_sent 0
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/Makefile |   2 +-
>  rdma/rdma.c   |   3 +-
>  rdma/rdma.h   |   1 +
>  rdma/stat.c   | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  rdma/utils.c  |   7 ++
>  5 files changed, 279 insertions(+), 2 deletions(-)
>  create mode 100644 rdma/stat.c
> 

Headers have been merged, but this patch does not apply cleanly to current iproute2

