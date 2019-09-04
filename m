Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E360A891B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbfIDO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:59:36 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44634 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfIDO7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:59:36 -0400
Received: by mail-qk1-f193.google.com with SMTP id i78so18405216qke.11
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 07:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lLWByCn+2pQBcuv1hYWdFa737ROB/e4Wp77nL6+S7oQ=;
        b=A/YLVuylKKWqcmRlKHHYY010VkYfDyDbXUVImzIMm+sp7wnRK5etP0FyAipIzy8HgO
         E7M06Eyrbu/LW2Gtf6Tul/ajMYDiXrkRT7RgMlRGZEeAZza046RkSPPmtz6b9VwLFrlg
         xfMtF8QeJzZ1s01g5fBziO9P5ORSzpZl1LfdBu1kfsT4q1uGNBLcGxbxUSf3s4cPOybP
         NnJBk2HYwY/ldoTiBmWDRwXOAYCH3FH56RJS6qiw5oFcH6scXt6y/0bwM3GKmb0kJJhZ
         OfqNSJbHkQ0T8q2YihFyXz/zNzh/J4YZ5U3UB3F5p0xGTWB/cXzRL6gDDiN4SGPRgrXk
         opvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lLWByCn+2pQBcuv1hYWdFa737ROB/e4Wp77nL6+S7oQ=;
        b=dhNqOLcAA0uo9br73WPw+RYQaqWBB7iom7mMYCBC5hZ9sDZMMLvYqumUzd0wUq4RtR
         BsL0Vv0X+zBoiBRxxt8RccBkYk9WkkVKTKOOdgabDjP3NO9OCQlc2VGSzoJxFslAlFxY
         2sOlivWjqs8/5RT8O6qUqP+S2Kq2Ld2by2mXCPE0sQpboiFH7LIwenTobPrYsxtsfUC2
         KMlD6EI8q96YNYSZS6LeV/k1vT2/A0KLxp6KQ0EkHK82Rgs3I1LNYj01Ac968B5lG+Yh
         NGWZ2asIWUSTzfoEkxhdRy6xyWH9rxDGnGM8i6fmA5z5L9DSFbJtqDg86/uuh8CljbEK
         0/fg==
X-Gm-Message-State: APjAAAUlDNKvuX0kGfl4UR5DG9RwfV3uCLgZgqj6ZLCxoCcS+Sgt5MRF
        K0qnOwL3YcITNOUtYJowWHg=
X-Google-Smtp-Source: APXvYqzs24CXWZfGasqYYE2eoMEb2+fpKZBGqGVgFX2DaKnZJJMyn9jZkqSF00aHGS3RGEAaG+DFmg==
X-Received: by 2002:a37:a083:: with SMTP id j125mr39408990qke.329.1567609175097;
        Wed, 04 Sep 2019 07:59:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:fd80:3904:3263:f338:4c8b])
        by smtp.googlemail.com with ESMTPSA id h29sm12073995qtb.46.2019.09.04.07.59.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 07:59:33 -0700 (PDT)
Subject: Re: [PATCH 2/2] ip nexthop: Allow flush|list operations to specify a
 specific protocol
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org
References: <20190810001843.32068-3-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0931aee4-b92e-dc89-8414-fa144062258f@gmail.com>
Date:   Wed, 4 Sep 2019 08:59:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190810001843.32068-3-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 6:18 PM, Donald Sharp wrote:
> In the case where we have a large number of nexthops from a specific
> protocol, allow the flush and list operations to take a protocol
> to limit the commands scopes.
> 
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---
>  ip/ipnexthop.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks for the test cases.
