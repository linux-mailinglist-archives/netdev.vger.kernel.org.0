Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77FD1D9C1F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgESQLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgESQLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:11:19 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18288C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:11:19 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s1so15833108qkf.9
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QYaD+vKpCghiWlomg0zaeBFKwQp5liAOcCNnnjClB7s=;
        b=F2LHBQrDbHElOfnT4ifl8BWlSPam2Xi8FcMGRF36Z/US9HFaSBHeXGGwMYkX+JmB8s
         smm/EeWRp830ar2jGLcoAtRKnjDZV+r59iiqumdvTOF7ZcdX6nYycTmqraqcvO2Mlju+
         04oVPfcJgZBRYi9HTjRLjQvJWUvBu9lqPrhwKYrVEJIRF3JUxjJmOUMIleidFJnxwX1t
         KGQol1ilYZvQEUKozof0IN5ck3ogmFoC4FjqmLHY1t7gDMp4bCjpC4Xoos2RRM5RP7qY
         mWD0ajJmguPpuxrOn+jlhA5aIlCGwHz2Vba/i77eZPz01cu49T6PwRnLj/eZIPZukyOz
         XQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QYaD+vKpCghiWlomg0zaeBFKwQp5liAOcCNnnjClB7s=;
        b=ogJMxKNwIJdUBuJI979AxIUQ8BmNalVbZbBqRcH9ClDuhQ0EXNqdyechtX7LoNoQfW
         xGGjyjG0ILP0ArPlJkBLYiiAVUkRvlNZ86j3MD2Mno4RgGWIk8OyYOWhYXE0ngZrdork
         fYcRHpOKp6N1+kyg5E1jkFYVUJ1H1mEwvzEYM2+kfkgKXooYPMeYkIlBTc1tBcFHIOUV
         y971W5jp0LfUzlj31PuPezngVE/XKVBBqmoPEuzSDg7AsT8c8Vt8JzzoirfrQcD6Wf0l
         tZ5PcskzvpKd1ZDK30+ZQDmXNuL01ADES3QhgkHt5d6hxzrrW/6h4XwSHN5Uf+Sr2OMZ
         XHtA==
X-Gm-Message-State: AOAM531mlv0mYU1ywcyDzYkF3Pb+gmkc9kWm36lMsrUP7BcvfqWuko+7
        /wgIgKHfq5wqL/j63VK0XwI=
X-Google-Smtp-Source: ABdhPJwsj8z3muqaG2+TL0oJLv5CU9geaoV9fiLz9UsfBZGI9RsA1Jofe5pmtwSyh2NwVnuZDWDFMg==
X-Received: by 2002:a05:620a:6d5:: with SMTP id 21mr54010qky.417.1589904678126;
        Tue, 19 May 2020 09:11:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id d50sm98207qtb.13.2020.05.19.09.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:11:17 -0700 (PDT)
Subject: Re: [PATCH net 0/2] net: nexthop: multipath null ptr deref fixes
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com
References: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c0d7aaf8-90a3-5fb1-5f97-263df3a6ce22@gmail.com>
Date:   Tue, 19 May 2020 10:11:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave: just talked to Nik. He is going to look at an rcu replace of the
nh_grp struct versus this change. Please drop this set for now.
Thanks,
