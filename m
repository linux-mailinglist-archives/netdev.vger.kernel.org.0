Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87B12233A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLQEpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:45:51 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45710 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLQEpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:45:50 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so2553052pls.12
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 20:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zavmadytOudz+T/44TMehrS1o8s5e7V8+sU0tqu6M4c=;
        b=Yl7D+tzuSlv3bMSHN1THeOZpm5RuHPGIUT5A+Mjl4CPSZwQ6ua617xnIshk5Dw8Hx8
         kbDay2N4bvLjAKcFt2ulsel5x+3yUPIt9ITwQ5N8Pwk+RGXR0XXHh2rnEcRy1BSgMCxU
         nXIw7E+SE9BT/VU/+Z6e8pCM9mIYdRvivLeccH+1wCViROooPjk0an4vwDrJ9tPdtC8U
         iPk2nKAr5aDhaEWhXF3n16ptBDFq8Vxd2+Nfn5jfIfBh7OGC+yVYJiqE7oMjVYbjFVC2
         mmAFYS9QhszLi0RmO76zJaQG9YgKzWc9eTFpHeH211ngK6FItCs6vHu9iee6iQRpN7K5
         mA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zavmadytOudz+T/44TMehrS1o8s5e7V8+sU0tqu6M4c=;
        b=RTV3lxHwZQWjUFdR4n/qM9MIoMiUUBEfRo1lKtE24ZDyRW8wjHn/e9fIjO1mV9dSio
         LxqiUqYJdylRjWK5vjRKKSdEv0AgE/76gGximsjt77jB8kejYQWHBAIRdCPueR6zY3nY
         veCatrFfLzh1e2Qpgjx+kNx8xZ3F65dm2dHbhMgOKmoBudAPeVVd3STvdX7A6zBFEXlo
         6Imy7XenSL0EW9uzXcyVMaFdEKxAeeAK5Po9/KzH1mOJ2fqu9T+4Wg3NLBNwA50UQ9yE
         +QtToUEn6RLFAWx97rn5B95txRrMx3a3M4e69YIUN4A+MJtN1CLiUj75QuUsLiTjgcIm
         2hug==
X-Gm-Message-State: APjAAAUdKniuF7Py+VA2yPFk0KorE2KcIEoSbB1Ooji01n2hyz0elUiB
        +Ct9I5rbINIwe4uaRLQrLu/EZA==
X-Google-Smtp-Source: APXvYqx4OQ0x697HWrrSi7bQLiJ1jbQNRF39PCZuz3k09Gk0meQXxiSQ2ngA2BBYtkIs+ktBtEDl5Q==
X-Received: by 2002:a17:90a:2486:: with SMTP id i6mr3892704pje.9.1576557950229;
        Mon, 16 Dec 2019 20:45:50 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 81sm24211043pfx.73.2019.12.16.20.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 20:45:49 -0800 (PST)
Date:   Mon, 16 Dec 2019 20:45:41 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 v4] iplink: add support for STP xstats
Message-ID: <20191216204541.0540deb2@hermes.lan>
In-Reply-To: <20191212010711.1664000-2-vivien.didelot@gmail.com>
References: <20191212010711.1664000-1-vivien.didelot@gmail.com>
        <20191212010711.1664000-2-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 20:07:11 -0500
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Add support for the BRIDGE_XSTATS_STP xstats, as follow:
> 
>     # ip link xstats type bridge_slave dev lan4 stp
>     lan4
>                         STP BPDU:  RX: 0 TX: 61
>                         STP TCN:   RX: 0 TX: 0
>                         STP Transitions: Blocked: 2 Forwarding: 1
> 
> Or below as JSON:
> 
>     # ip -j -p link xstats type bridge_slave dev lan0 stp
>     [ {
>             "ifname": "lan0",
>             "stp": {
>                 "rx_bpdu": 0,
>                 "tx_bpdu": 500,
>                 "rx_tcn": 0,
>                 "tx_tcn": 0,
>                 "transition_blk": 0,
>                 "transition_fwd": 0
>             }
>         } ]
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

This patch depends on new kernel features, should be to iproute2-next
