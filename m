Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A10B734C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 08:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbfISGku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 02:40:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40254 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfISGku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 02:40:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so2505653wmj.5
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 23:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vmF/BjnLbLv9XJa6yVtqTqqJhycrQDU3hXNQWth3Sjc=;
        b=1gbw7HsuprH8/pRfQqhCk8v3Hvzd1VkJogplFKAXbKW0dR4cjHvX1R80mDbWNXJiVP
         t1SWT3/gipngL3Gan7ysUe3FyDB3MoNuyNB/TFOehmONjq+zp+4RIIks4BD5wVamBJMl
         pAwcwx+w2Llfl4pArxV36jvc5oK40zTqJbFcPdtMfMjn1W2Dll73VFPPTHFy/au6oBfI
         1Dd87147YVBZ2FQabzXycu3d6lXDOFgNd+Yw0laUo4zbp1ge2iDBvI3npMjuLkLUKdrj
         HizFboWAQUyGmwNm28rT+7uHOWis/Z2Ubowdurn+QD9Dy1H6X7I/vOhy89rrBvcQU8Ot
         Zm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vmF/BjnLbLv9XJa6yVtqTqqJhycrQDU3hXNQWth3Sjc=;
        b=cKTGKogxzRt6R5rOh2BHOyVQKn2W9YTVg6oVf9KUZwv5y6uTn2HTJfgcTzWBeBLNtm
         Z84zKJUg7ca/hD4N/PNY9tG6sTRlDpzIa5pwOivzDcR5qXR+A08EU1pDvx0fSfuil35o
         D3QjV1XGAVYY9G+5YxAFrABQ3HOLbgVxyUjuQ+2oDt4/mwaLUv5hMcbyGTGx7zJQnQJ1
         QpDNfI14dBtBzvuUWbYZ7/2QAAN4G/rstfVThapzVb0vqeR0TEMZSElKpxlhz0tzmKZR
         4dHf/oN5KaAhmFkqezUEuwl7D4Cl2QRHXR4TdMVK6R6ScMTXw/uvgXbsy7tWl7Xwddsd
         2AnQ==
X-Gm-Message-State: APjAAAWHyc5yQUg6muTPuhl2lmXYhJB8RC8MYWcwOBP2URKU+vsOpTkc
        D8AwkO4SS33o2qcE/bxuavxv/A==
X-Google-Smtp-Source: APXvYqy82DrX61uMHEW8Ty9qtq5GJrpMtNiIIj6VFcQTHwY2T4Nr5oqYrTx7TFDwbnuQFg1tJzKSQw==
X-Received: by 2002:a7b:cc91:: with SMTP id p17mr1283987wma.43.1568875247515;
        Wed, 18 Sep 2019 23:40:47 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s12sm8979369wrn.90.2019.09.18.23.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 23:40:47 -0700 (PDT)
Date:   Thu, 19 Sep 2019 08:40:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com,
        David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
Message-ID: <20190919064046.GC2187@nanopsycho>
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 19, 2019 at 01:24:12AM CEST, xiyou.wangcong@gmail.com wrote:
>The TCA_KIND attribute is of NLA_STRING which does not check
>the NUL char. KMSAN reported an uninit-value of TCA_KIND which
>is likely caused by the lack of NUL.
>
>Change it to NLA_NUL_STRING and add a max len too.
>
>Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")
>Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com

Acked-by: Jiri Pirko <jiri@mellanox.com>
