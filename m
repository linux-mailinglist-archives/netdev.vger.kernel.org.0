Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46AA39C41
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 11:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfFHJu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 05:50:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41706 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfFHJu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 05:50:58 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so6245612eds.8
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 02:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SzcVARsxjSGu89XucDrb0gDxbojdGFnUqfa9ln4uXwA=;
        b=p5BjofFIcSbg/cDaxmOB744avexToSh3iPfzWYM5zBjegd3p7HqAbsd1iPVW6VEBLX
         BcxdJerAuqRpziHtuYrJqVx7GF62VfKdNx2Cu+z32eaaobY1f912CuJ3ulrO3XzSZueP
         gakKq3QEGmS8NZVOBeFRlSUTjcCuLsV0jQnSPoiLzFkYAhQDs6U4X6/8K1J2F83ujjNa
         g0Y29USntg48zNV5yaqH47dsSwZ2I5NyuXTks2CZ2Ydq3DhpKgD8i8RVDg3MWGqAuzVg
         ToFoY8X7j4xZ3U/xrFJk6MEXM6TZ4g9UWVM2gEwRxAGGPcDzoBbb1qjLCrKB4wfGsaee
         LDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SzcVARsxjSGu89XucDrb0gDxbojdGFnUqfa9ln4uXwA=;
        b=qbxShKhxyttmldDs2sJ27rMMVQVs493A0xZrRfinWbrxJaYThgEyfWKhPd2LbtxvQs
         lW0h+eWqGqVy66t9F1bl9K2phoN3HwbJ+vXbP5wnn0+nERPv4beryUVAsc85Xe6L83t4
         wpWGQt8LTts0jd8XYIAaxicJWY9dkAnrwu80Jqs0QVriyCY875+qdDDh+b5DTgWtW48Q
         mW4qxknxf//mx1K/UKgU67uM2JhLArqkx7iXhhX8KipMu/oMnNt3BiKUJ/d8OCVbOPkH
         tB8+JV65D/VgOeUVGVFQzZj3eHvDOpN1x+SwLEzD6QugFpivOdQynm78rPl03Kkgmb7a
         plYg==
X-Gm-Message-State: APjAAAXlZQ3hmVf98h4XZsICbeEgqBprOYoYTVnYhfm0etBg5OVtwNfS
        rl9W8fBYnNd3SejuDa8nTUQ=
X-Google-Smtp-Source: APXvYqyvU/Hl/6PqD0YhLXzjxs9db6j0CKs762veq7bGoceuhNGsc89jwr0RRYjvSJQXeHCgUnrqWw==
X-Received: by 2002:a17:906:4d88:: with SMTP id s8mr28310037eju.225.1559987456400;
        Sat, 08 Jun 2019 02:50:56 -0700 (PDT)
Received: from ?IPv6:2a02:8084:601c:ef00:991d:267c:9ed8:7bbb? ([2a02:8084:601c:ef00:991d:267c:9ed8:7bbb])
        by smtp.gmail.com with ESMTPSA id 10sm336417ejn.8.2019.06.08.02.50.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 02:50:55 -0700 (PDT)
Subject: Re: [RFC v2 PATCH 1/5] seg6: Fix TLV definitions
To:     Tom Herbert <tom@herbertland.com>, davem@davemloft.net,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <1559933708-13947-2-git-send-email-tom@quantonium.net>
From:   David Lebrun <dav.lebrun@gmail.com>
Message-ID: <215ec4c5-bef0-f34e-20d5-3c35df0719f4@gmail.com>
Date:   Sat, 8 Jun 2019 10:50:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-2-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
> -#define SR6_TLV_PADDING		4

 From a uapi perspective, should we rather keep the definition and mark 
it as obsoleted as for the rest of the TLV types ?

Note that I'm fine with both.
