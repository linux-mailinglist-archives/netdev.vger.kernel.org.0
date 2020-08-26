Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDE725382C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgHZTSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHZTSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:18:06 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445ABC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:18:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so3331777ioe.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=es9Q7UGeVyvRotLvkovnauMBqWoFEz9GTys5DHBJ+g8=;
        b=jj/sPUkzfL0wna7C5AMCplpLbH5DhB+De7JWr6eysFWNLiKcVvDUdChkqFyo74+0nv
         vMYSbypqaUcS5VTzbVy8P7A3kdeXawwPkK9bB3hb6D4AROAsJyYTBw5H9dAf9RGFpGIe
         SG4ohvNGGa5CyPALVDJltDgcryOHp60JH/GWrUn6LtFFhdERwE6t3bpjw8FGLtDwoop7
         uB18u8B7SB1m9PYKNqvHuLn2f8h8SkRgJDUAbDqNpE63KCTrWEXBB+0rpBwPXeeK13d8
         ElHHbms6WOfZnQFOzr8TL+QpyzXiv7HaNk4/ZDCrKZ4ZoS2gMcdWH14iuwdq9rqM19z7
         DZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=es9Q7UGeVyvRotLvkovnauMBqWoFEz9GTys5DHBJ+g8=;
        b=EEizCOUpnzGE9VmzTHbM505BRp/J2IN/DW7MK94K2BFoFJFLwccenYi/2jPezVdeZg
         yCmfMSCmBKdSHs0d9kMOx3cN22ovjwnyhv6add9rqV8xIov9RpnBQtYSQX/+kFlXcA9K
         zKpB8ZiTxg/QVh2J6skwh6KBi5eZ6135HGvR1tlp97nriGj2tP8N5Iqasl+Gun5CJuf1
         /x5EqWMAwZgocXDlfxgEJ9vcb0WgAZI6CJne/uScCzyS1MRhSEM3od4EDW64nDqf155o
         516fGTrjL4LYs1x7yj+47b7V/GeImC4OJPjGpid0w+5SxCeA8TmGfPp654w6spEfoiIx
         QGpA==
X-Gm-Message-State: AOAM532iIwss1k1sJlTInS4i0o55WEltkd5mY42cO8rkRC2xoi+9bjnG
        Cvt1jzlqI4oS3H3g2Mf2k6LeekQBQCsclw==
X-Google-Smtp-Source: ABdhPJzT2Mi8hGQPB50+91AtcY7I1hdZK7m/KfqxbJf4L7BbxB2ioOxTFKm8xyiUqcJnpGrkOQo3LQ==
X-Received: by 2002:a02:93ca:: with SMTP id z68mr16198047jah.3.1598469485672;
        Wed, 26 Aug 2020 12:18:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id d19sm899755iod.38.2020.08.26.12.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:18:05 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] ipv4: nexthop: Various improvements
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a2a9859e-9615-d9c1-1ade-e79d453106ac@gmail.com>
Date:   Wed, 26 Aug 2020 13:18:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> While patches #4 and #6 fix bugs, they are not regressions (never
> worked). They also do not occur to me as critical issues, which is why I
> am targeting them at net-next.

I agree. Thanks for the work on this.
