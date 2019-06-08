Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABD939C4D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 11:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfFHJ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 05:58:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43635 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFHJ6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 05:58:44 -0400
Received: by mail-ed1-f68.google.com with SMTP id w33so6255042edb.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 02:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pVQD+7WOfdpWFWFI2jxtt+9qltaicuURkNvQ87WQmR0=;
        b=hz+j3oy/nyzF9piwGPumN0hpZ6h9XX0XUuCLkTXaUGvZF7enwcbK2Pq3dMZbGMNXmD
         k2QPKWR6f9no8aJQZx2zsAi3weAupwW9EVXmpVNGrfyzzgGwWXshbvln34+/WR+YFaN/
         RCyD791MIli7p88wIlQ0b/teUmrUq0435zRqWON2j6UlY6fN8Em6gYtVfsk1eH5Ca9Nl
         EztKrCJ83tIZZ2xGzm0oWkduCbJG5qmVC8KA9xTqq1zoen4tLVLcGf6e1vORgwxKHNfg
         6bPiPuqGBZUtEtUTflBh61YL8KksYDCs1/kofdysE268YM+fzB4r/AXVEmjKUucBxiOO
         3euA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pVQD+7WOfdpWFWFI2jxtt+9qltaicuURkNvQ87WQmR0=;
        b=QpfjofTCWBRLHEn+pFALDFzgr98VVamquBm+wU1j+XVE7H+TJ45uGQHmeTMwm1G2IQ
         WL4D+o0iMa4ke7KOcW/W6R7fC5X/1qCD2KXqo3t2eAnRpQjWVPXbYa8Q6JXdTf3ZOqPT
         /PxXKe7eoz4oH9S7BQlH829LsVLYTyKhsizHujzt/xWVPkFEbXNWllTExx2KlSuH2n13
         SHhnKhTwicVhguwTgCF1AKWI6R1ARi/3jJHsdZP5ZxLcuxyjHVUuacwe66clRECegCHx
         w99H/4Cm2Uv7Q1p+Yv/+QTqPB3EMtzzjePhNbKvUV6jnIC9yrVaXUGH59Q/zF/K84flk
         RZbQ==
X-Gm-Message-State: APjAAAUc/hsnO/inou1P9XMuKo0Vhp9VgNbFh0JJv1tIobHKATG7dpiT
        rWrvoTrlsdj2Xtx1sWq5x78=
X-Google-Smtp-Source: APXvYqyFYw+jcN+9YQSGP3WqombyJ+cw8asKYHVkClqG+SLKm9QP6kNmFzFDRuoBLw1FVNNPBT9JIg==
X-Received: by 2002:aa7:c5c7:: with SMTP id h7mr62108712eds.81.1559987923218;
        Sat, 08 Jun 2019 02:58:43 -0700 (PDT)
Received: from ?IPv6:2a02:8084:601c:ef00:991d:267c:9ed8:7bbb? ([2a02:8084:601c:ef00:991d:267c:9ed8:7bbb])
        by smtp.gmail.com with ESMTPSA id j9sm783547ejm.68.2019.06.08.02.58.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 02:58:42 -0700 (PDT)
Subject: Re: [RFC v2 PATCH 2/5] seg6: Obsolete unused SRH flags
To:     Tom Herbert <tom@herbertland.com>, davem@davemloft.net,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <1559933708-13947-3-git-send-email-tom@quantonium.net>
From:   David Lebrun <dav.lebrun@gmail.com>
Message-ID: <eabbdf1f-b39d-fc1a-531e-dca6d1aa8473@gmail.com>
Date:   Sat, 8 Jun 2019 10:58:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-3-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
> +	int len = ((srh->hdrlen + 1) << 8) - off;

You want << 3 instead of << 8.
