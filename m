Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED9E7C23
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfJ1WDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:03:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39501 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfJ1WDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:03:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id p12so7910816pgn.6
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ayHeK6JSrV5mX+VQA5GXXP/WrgH0T4zF2nzaKBMGqTE=;
        b=PBaV+zEC2dSXacfwTKn0Ugw4lQ/upQKoU2SYjFa/iFeRoLpmek7yZtKJZ2Y2MkeuSc
         ROtXd7RQLn7J/nW9dKxj5sms6L5uolgkm48bKSRIPVlwWLdKMGRDiHqaMvD0xkvtVAOF
         1EpPT5EyzV3AJ3C18agdle2wMwt9D6ycmRE9dyrnIHq32KMYVh2e0ZKH72XvI59F0azE
         zPlyBpfYYv1Jz1a5GgIdL0He4iyEtd8TtV+SSKbyccju7aKXPywl+VdLs6Uj5B2RCY3c
         t7trEl5WbpWeptq3cXaDU9xc6Q4StVfY27iC8lFWljj26RXT2evxHXn9CV4MKVtUlJVn
         koKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ayHeK6JSrV5mX+VQA5GXXP/WrgH0T4zF2nzaKBMGqTE=;
        b=CwxYCN5mo2W90Go+t9ru/V6gvMov22Dc9vlCE+j6Au4g7pCcYSY36vnnZ82JWrCrw9
         llJBjagMRUkPG9czmvvfgjdpKadO79EB/v161QMufxV22sATgicDH/5cAeHt/sT4yZFA
         mCKU+6hFBpKadikO/oMKyjrDLKDwxRtuy/JG/syNLrxwqq6CE1naEANcr9AFcNUbdvFl
         nyohCjcx7ofp1bD59ySpYFGWGzpmD0xegdYHCyXnKWVlFC2COm/YQbgE0zPYJZL7opVq
         2Lz0r06JXdEBwCxHRAkpCIwzLtVkKYju6hupLwkyJV9n6JC57NuD+sTW/ivqoCMpmWwy
         /eSg==
X-Gm-Message-State: APjAAAXvlxASi9Yl99JAw3rOc7Gr8Q/+xL+6esO7xmuuqbfZ0uaOHg/H
        i2Vy9n0fWwDr7OLH0T+ftFs=
X-Google-Smtp-Source: APXvYqzNvA/+D0D6TR8hqaX5B84X1ynVWpSjf4mIuLeR6WQNuDtqWJw/K3trUgAnzfDu7ilNHaf4fg==
X-Received: by 2002:a63:2042:: with SMTP id r2mr1887863pgm.32.1572300195827;
        Mon, 28 Oct 2019 15:03:15 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:284:8202:10b0:9e2:b1b6:1e7e:b71e])
        by smtp.googlemail.com with ESMTPSA id i123sm13850703pfe.145.2019.10.28.15.03.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 15:03:14 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/6] sfc: Add XDP support
To:     Charles McLachlan <cmclachlan@solarflare.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        brouer@redhat.com
References: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8af30fef-6998-ed20-ba7c-982c9a4d263a@gmail.com>
Date:   Mon, 28 Oct 2019 16:03:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/19 7:56 AM, Charles McLachlan wrote:
> Supply the XDP callbacks in netdevice ops that enable lower level processing
> of XDP frames.
> 
> Changes since last submission:
> - Use of xdp_return_frame_rx_napi() in tx.c
> - Addition of xdp_rxq_info_valid and xdp_rxq_info_failed to track when
>   xdp_rxq_info failures occur.
> - Renaming of rc to err and more use of unlikely().
> - Cut some duplicated code and fix an array overrun.
> - Actually increment n_rx_xdp_tx when packets are transmitted.
> 
>

Hi:

I was hoping to try out this patch set, but when I rebooted the server
with these applied I hit the BUG_ON in efx_ef10_link_piobufs:

	if (tx_queue->queue == nic_data->pio_write_vi_base) {
		BUG_ON(index != 0);
		...
