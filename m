Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2B214869
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 21:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgGDTbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 15:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgGDTbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 15:31:18 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078EEC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 12:31:18 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id rk21so37890555ejb.2
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 12:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=h03Fbu5XRRjde3ErQJ4FjQpQyaCnXkxBjXNCWkoCe9c=;
        b=YcAk3ALDpKCPqY/U9k3FY7Jt3sa/SvOybifDkoX7z97aYEMrR/S3rvYSYG5HheF6Ya
         SNKhDu8R12gwph+rBTlKSD30qTve5FPu86iHGV1Cd86cFOndJPmc+S2Kq1aKVbcs5waw
         MI5ebu+TCwFtq3kNBGGgKaeRVMVxaw3eHNZtUAqYXMOu/1Zd28Pmr0Lh4CWbl3WQGJ5e
         oNP5JaGwV3Z8rV9DzYhq9Hz7H1JmgJ++7Jwe+6G0MPru6VVvmQ55BXqYpopAjJpD6JPa
         o3/CigoaRbofF1qKFncbBuhlvCgyUNdE2utWsi0TzAyVTqDWKP0TCDONZ/syk4ayR0L/
         wKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=h03Fbu5XRRjde3ErQJ4FjQpQyaCnXkxBjXNCWkoCe9c=;
        b=K6JkyaOINhTfWsbs+ibQ4qiiGCwmMbpip3FwitzTHk9+1bHiovyEGoWJXmw7Y+ASzz
         bM7KBGw1E3t400P1WJyVPLEGFofSEMXVKY6BdUvqB/QunEMisjxoUk2wybdN6tugrOfo
         Jk8unlBcCpL1trJxj020kI+QOem5xfJhajYLR3z28Awhu/D8Nb7T8Zq9Rq17G3P1hv25
         Dp5XS2wPcHq9RI7jw+DmlIYiLr7RGdzAp0010EHVKusaKtCoK83VIOXMOeO17skMOtHo
         4zH5pC3oYnLXFA6kx5vnEbIK6A5OYgksUD6nHkuaqX9v2mOBmjK/V7NvbUZe7RTz3Wht
         9gWw==
X-Gm-Message-State: AOAM533G3JuMca7ZCxCn7K2Ec+G6QjoBc+2/oR7EUqD1Xe7htmR3H2+o
        KAutLk+NZASUruCXUlAV//ICNsVtYSs=
X-Google-Smtp-Source: ABdhPJzVNeWJoV1IWS2E4SL+hzstqYO78HOe91OZ6qo/zhnQoN0TheKRHMpdlgIe6ZsC1KMb3hkOCQ==
X-Received: by 2002:a17:906:c14f:: with SMTP id dp15mr37432420ejc.454.1593891076426;
        Sat, 04 Jul 2020 12:31:16 -0700 (PDT)
Received: from [0.0.0.0] ([185.220.101.140])
        by smtp.gmail.com with ESMTPSA id y7sm16539054edq.25.2020.07.04.12.31.15
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jul 2020 12:31:15 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   Vasili Pupkin <diggest@gmail.com>
Subject: Why ss output is machine friendly by default?
Message-ID: <6560f9db-03c2-81db-2af4-f88fe7238380@gmail.com>
Date:   Sat, 4 Jul 2020 22:31:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --processes switch of ss program outputs strings containing 
"users:(("ntpd",pid=1888,fd=19))" and it is too long for the purpose of 
system administration. netstat program output "1888/ntpd" is more than 
enough for humans. Long output causes line wraps in terminal and hard to 
read.

