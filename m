Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7FAF0408
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389062AbfKERX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:23:27 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36958 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388711AbfKERX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:23:27 -0500
Received: by mail-pg1-f193.google.com with SMTP id z24so10165147pgu.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 09:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MQwOs7BGLYUmstR6UT45dZrr79XwLyKNpCbl8kUzLXM=;
        b=dDfZX4jvraACDwM5CScDONYggjdiNweVRkJnsXt+ae9lW8C41m9iKFAM9lwmR9V26n
         EILFN+Rb3gRLPYD32Mg+oopJyreXyjQWf9Y5dJ0Y7Ms1VR+5O2/Wz5L/jKVEmD72VUTh
         AHrHKZnrluArwh0BrgiYaUEgHwrhebs+wToezgC1vjmSa4P9OtMUsBi8b0of+HpHJr7F
         OimQZPrgccyaHBVXOpCC00wwGnN8/t5wtCAK4l2xlFoDjQu8WksLsiqoSBea97o6Lbca
         zFcLtKKaW31pRoEZaaD5SsYs35YxHjbv+7guAV0RWVVsaZg+Xn68kDxOF2frvPiEuDKY
         Ws5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MQwOs7BGLYUmstR6UT45dZrr79XwLyKNpCbl8kUzLXM=;
        b=pb37gsXL62DsdbRjxisPek1CgKyus97VWxpsmsI7XtFOG6YUDnb1QBnIj3Cwfz5JQA
         nkF82MAiwC6Lj49B2NRoXEvzUIXSKoejOgwrMp51slW/fE0307KgbEHXOlLZD58LQpdM
         gLK/80PDmXNIeu1lZ+pNgCTGwx/on8h2NDJbB+tRhnXSGgZ5Pb8gJzXTqmAvOIdWuSxM
         dA26jr8gkiyWu64WFdSx+cuJgjKD8rxlaCGKIC+VY2M1VSZcYDNLKW142AvXl7epgRhv
         NdItzKYRDixOFss7efdJmOilaKWil2gxz2wgVJ4q2C0PakqroyVoIdnBlaHCa8kfEb7D
         hcXA==
X-Gm-Message-State: APjAAAV6W/xlVjuqb16JHp0fQ7lhW5wjNw3SiDzhScN3pI0FCBIjMJIF
        JxeyPV13iJffyMuimibUTinaQw==
X-Google-Smtp-Source: APXvYqyd1JLQHFOCxVOlWxIEj3xvrnqgXdolp05wiFDR5WnYfg/TfyNm8HocmYWrs550Z8519GiSHA==
X-Received: by 2002:a65:5885:: with SMTP id d5mr36781516pgu.278.1572974604577;
        Tue, 05 Nov 2019 09:23:24 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id j18sm1654316pfn.127.2019.11.05.09.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 09:23:24 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:23:20 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net V2] Documentation: TLS: Add missing counter
 description
Message-ID: <20191105092320.5e84845b@cakuba.netronome.com>
In-Reply-To: <20191105121348.12956-1-tariqt@mellanox.com>
References: <20191105121348.12956-1-tariqt@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 14:13:48 +0200, Tariq Toukan wrote:
> Add TLS TX counter description for the handshake retransmitted
> packets that triggers the resync procedure then skip it, going
> into the regular transmit flow.
> 
> Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Good enough :) Since record sequence number is part of the state
installed in the kernel the pre-kTLS part of the connection doesn't
need to be part of the handshake, application can install the key at
any point in time. But in practice it's going to be handshake most of
the time, so perhaps that's more intuitive to understand for people.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
