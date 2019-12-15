Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AB411FAAB
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfLOTIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:08:37 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32785 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLOTIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:08:36 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so2400419pgk.0
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ffq3e+xNajXiXzf0nKb5DnbnszpStX3STdz1UBDKPPA=;
        b=r8nG3dCZVubSAmDS3a/inFm9wBMjXR35ZaYMHP5szY/+FViaASj794Tjq16Czcj/IH
         yaZPdniHUaZ3I66e5QPSsk/jqva4AQbqmf9CQyff6sE8BNK/boiKuStGfNA8/Y+5lbNf
         FwKjSf04joWMTJcEgN03ssDwjrsXyo31yKSHGXcT3WIKLN0w4kOD0BvVJwjR+mWPIk+a
         99HZDyCgZ3m0mUjsZ0YRKeBK43fpCw/n3wK1w1c6TU5Qrk/BObKLPrZRiEM7lEzbn5aY
         7j4KDoAUaHi5YeEdzoefJlyzhbe+EKV1gFktXo+6b9Sk3LhMBQ+6QcmCX79zwa81x9DS
         Ewrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ffq3e+xNajXiXzf0nKb5DnbnszpStX3STdz1UBDKPPA=;
        b=BbPz5c2czepVoh38ByyEKgtr0wCHq1vpOLmS2Xs4zDklU4pqy7oEbtUfHXDu1kdaoF
         3Es7xEMdgbWRSrVVhsV9nqcgHF2LbiTvJGD7MwboMHE9K/6MjOxKBikunxCCtD9y0QW3
         lwRvkAvKn8acIAVWv3uk/S0CfIRujqu8QfTAxziI220nKhioNgk87AqlWtfVn0GuZN7A
         g9EyEgtFqPJM4QGWUvK871O1aAvECFOj8QCrfB4vLvSlhFinDjjqNEuyM9un8O0eWiuP
         ViWGJ7BhGbCW3P9W+qGV1TIoBKiGGJr8V2znAMbSy+qos05OpB4be5LIpGuHyNya/Em5
         Sqbg==
X-Gm-Message-State: APjAAAWMz9sJyoNBTDdk6X4vV95zCN2y5VyRdOGcEIZhfZfc8UGizIUU
        b0M2I3sO66hYC9BomlnoQQTvOw==
X-Google-Smtp-Source: APXvYqz741YqBoBqQerGhr9+w1GwNzsLDWE4OFO8ZBvQdMcLPzd1eHpOlZk9MJiUO/2PApOQ1a5MpA==
X-Received: by 2002:a62:243:: with SMTP id 64mr12421660pfc.49.1576436916157;
        Sun, 15 Dec 2019 11:08:36 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o31sm18258898pgb.56.2019.12.15.11.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:08:36 -0800 (PST)
Date:   Sun, 15 Dec 2019 11:08:33 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next] net/smc: shorten lgr_cnt initialization
Message-ID: <20191215110833.1746428a@cakuba.netronome.com>
In-Reply-To: <20191212213541.10485-1-kgraul@linux.ibm.com>
References: <20191212213541.10485-1-kgraul@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 22:35:41 +0100, Karsten Graul wrote:
> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> Save a line of code by making use of ATOMIC_INIT() for lgr_cnt.
> 
> Suggested-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied, thank you!
