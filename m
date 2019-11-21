Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD17C1059F4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKUSvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:51:55 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33072 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUSvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:51:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id t5so4472351ljk.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 10:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9r43Gyu+k6rZwXDbj4SEFP+nyD3oJd1wYjTMWGzNJBk=;
        b=iy3r0FlAnwca15ty61+eEa+zsQlB2TpUM1MmT276o0Qzi0bVGxz4awmFz7pjmOjGZj
         RejumRgwtvWJEFqAolT/KUfKJdn0uAvtBqYybnZhEdsgYfMoTfucHptUm+wJNfq517FC
         ggtCbE/G+09/n733AAL/nCn74iJGCO2utf71DEe9ATYlsEvseVuqL/xOCtJuV7kldHBO
         xkGwqBUIvBu7sr6pq72kMKlf1m6QKag4NT5Ojiyf6uMLAK3kvYF5bdsBwQ3WOubnj/uU
         d9+F8zABW5SZZf45f4DdU/VdqUKuqT7XK201zxUQJbLvzb2r1vGBiCG+10dofIdWXb4b
         ON0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9r43Gyu+k6rZwXDbj4SEFP+nyD3oJd1wYjTMWGzNJBk=;
        b=A27KU7eVbSfc7FUWNlqZHM5ZCwo6DNj9iEVKRRFZJM+O6Po20mHgZFQtPdhHM+579j
         FPmZn2odx8MuOVtWHk1H5jKyGZGnksbZLYU2iJHgdqmV0ybYczJGjjmmn0vC41k7XFJD
         6Qy5FmgYDbpPtWzK3YTWllgVNIZSSi/7rpltSQsaEDsZqn4XRRteDMXUA15sp4x7tpDt
         ANro2Aejh4MeZmYFfXGUnWbc+3adeDqc72qx7mJ1u14a8EOgTeJhsDhpPrp2ydijPQ2O
         Y8Ip+QuagJQkDKpJkwaem75s8shniwXHqnMfOgkNMslGn+22+/PkZEUt/oZ+/4gVIDWR
         zmqQ==
X-Gm-Message-State: APjAAAWH1P0MsK1XhUW+h2poxarwlidQuMncSO+WMzsqt15VJyYt4Cgs
        94aDsbMDErTQTOxJMzcFvv0NlQ==
X-Google-Smtp-Source: APXvYqxSnXkd/Sp80TE2c2DhVaaNQAmOlUH0Ygb4wdQv5N16jCWf9JSZ616tTT90YUzBPCKFmr1OyQ==
X-Received: by 2002:a2e:8e21:: with SMTP id r1mr9017328ljk.81.1574362312866;
        Thu, 21 Nov 2019 10:51:52 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a5sm1690573ljm.56.2019.11.21.10.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 10:51:52 -0800 (PST)
Date:   Thu, 21 Nov 2019 10:51:36 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com, "dsahern@gmail.com" <dsahern@gmail.com>
Subject: Re: [PATCH net-next] net: remove the unnecessary strict_start_type
 in some policies
Message-ID: <20191121105136.79fcdc83@cakuba.netronome.com>
In-Reply-To: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
References: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 18:08:38 +0800, Xin Long wrote:
> ct_policy and mpls_policy are parsed with nla_parse_nested(), which
> does NL_VALIDATE_STRICT validation, strict_start_type is not needed
> to set as it is actually trying to make some attributes parsed with
> NL_VALIDATE_STRICT.
> 
> This patch is to remove it, and do the same on rtm_nh_policy which
> is parsed by nlmsg_parse().
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
