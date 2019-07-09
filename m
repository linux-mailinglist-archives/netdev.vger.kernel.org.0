Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343A5636F4
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfGIN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:29:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33860 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGIN3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:29:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so4704092pfo.1
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 06:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1y0fLaN1apsJQTWOTXlW35i/vqfKN25gZTy76oTiNA8=;
        b=JG/DtjNnCkY/GELC7MmV1H00C/PoBRHeX2Kmg3F2Pk7RrFSP/qE7Hs+FFCJitYInuW
         aPcX0I7WGAC9ZkbSto25nUafoHAsYAz0eKgMgLU4niwhEIomqAL8fcdpe7xCzdnhIiPp
         UNqP9Mq6r5oy41pJZLwFuZwSjOyaJsZlAXfD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1y0fLaN1apsJQTWOTXlW35i/vqfKN25gZTy76oTiNA8=;
        b=msRxJ4Tqz+Yw8D4qmJgIYBVAI2IsXIGT3BeEVPEwRV66bJU+Uara7NJScuzFieeP6f
         TWSdcJaTMu1f6GkZcitBjZxmRJDQwSL9FTGQqRv5oqCWutXaq81yKHdblPCovYntFCT4
         /x3ywggiB182z+gBj7gBaTbdUz2r2Mu+3ViBwO1QreKTkj3u3/2tbz6Hi1arnmeMp6VN
         8kDoWANt4ma+7K4qtTVoE4IX8SjnArCjM/FNh77OSqfClHNU3eqZJGD239cokitVNn7b
         r5auop84Q/JOycUTlhGrszZ9yBcJhmWc7zrbXWWVgFEDxrjYJ5POahafnTDfke9rj0O9
         jCWw==
X-Gm-Message-State: APjAAAUKAozutDRQmHyks8FA3WMLlUkyeGMYf7DjgxBbvXD6Lnm1pSIT
        KTZycDBB+hF2p1RIJguODji+rw==
X-Google-Smtp-Source: APXvYqz0SN5R6Uz+e59XBsuPsAOkr+etwbTPoBVLPf7sIDuWRJlMhvewyJ3+EH8bBs9BEKzDvpqkSg==
X-Received: by 2002:a63:4554:: with SMTP id u20mr31418102pgk.406.1562678962280;
        Tue, 09 Jul 2019 06:29:22 -0700 (PDT)
Received: from C02RW35GFVH8.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id t96sm6036304pjb.1.2019.07.09.06.29.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 06:29:21 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 9 Jul 2019 09:29:17 -0400
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: Re: [PATCH net-next v2 4/4] bnxt_en: add page_pool support
Message-ID: <20190709132917.GL87269@C02RW35GFVH8.dhcp.broadcom.net>
References: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
 <1562622784-29918-5-git-send-email-michael.chan@broadcom.com>
 <20190709062746.GA621@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709062746.GA621@apalos>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 09:27:46AM +0300, Ilias Apalodimas wrote:
> 
> Thanks and sorry for the inconvenience :(
> /Ilias

No worries.  I didn't know Ivan's patch was going to go in so quickly!


