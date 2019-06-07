Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004AA39492
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbfFGSqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:46:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45075 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbfFGSqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:46:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id w34so1589163pga.12;
        Fri, 07 Jun 2019 11:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z4R/A+c7peE9kIyceAe4LW8kI17iOhPfKiTxuGTvFbY=;
        b=WXVFD4SniiQTHxsMMnzHf4YxH3jkD3TbVbIj9A71Hn+NpbxejpDtqXTrtn50E/+l5f
         LT7UPXxWQflrHAurUnAgMV0+dpuWY0tkeicdMqIaey/dqWpY39aAiiqRCUmxSgSc2xc1
         kOLOZMdU4D1RvgaQ2sXIg9p548OFbx9TkXWKuIMdAvmM1t/lTMLxOEQYjr6XSj2veL6D
         0EIcScKvLqQVQqNda0uFyFlQWhlTuZBFn7xLqJdYmdtT+SZLEPWzwD6GJFx/T0c5mEMu
         VWXv7Bz4yMUn6ePZNZK/o2clj0jsJj/uePBA0tYkFeefNOqXCBomhau6yYWBeONiVDVY
         sclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z4R/A+c7peE9kIyceAe4LW8kI17iOhPfKiTxuGTvFbY=;
        b=SUkF1qiJtERqHX4BCy2kpA9gZTkfd4TcRhG/p6+LfpSuHogUKqd0zzBGvqW+5U2Ey4
         bbw6sgjU4OCaNvZVOiNGeBddewJo5YOnPoa7GllE9WmSe/xR2Okd6pIaCUyBUzoN8Qyr
         1Dbm6rrETc+Lzp/MfQkmkJHuYwk5gjNqvnLdBZra8HSAjkKJOSrLzXOfq21NLFBlchq3
         9zzI+o8lwDzQswrVl7FIMM2fp2EUiNIQmakdnwtbNJR4rx9RPi2HCj8fOVbj1yoONBUT
         FyLe0F8XUUk2H0OF69eLCUmqauEof74rrdnnXTbE2F3Whuw0ELPrFegZr8dM8Jn4yANc
         t91A==
X-Gm-Message-State: APjAAAXtKNF20FTZaQsdweK2wjOEnFCgD6wuTa/vlryhREFZrMyTmj9d
        yzLGIIGWpg3M6bmOmTn6pgE5QckwdQI=
X-Google-Smtp-Source: APXvYqzxUUOczQlFQk080F3RPgI6vBdOsB4jni2YUcIV01O1vCjRDDK19TNf84AfKB68VP5Dz3sbhw==
X-Received: by 2002:aa7:83d4:: with SMTP id j20mr62285296pfn.90.1559933180050;
        Fri, 07 Jun 2019 11:46:20 -0700 (PDT)
Received: from [172.27.227.254] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l23sm7423762pgh.68.2019.06.07.11.46.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 11:46:18 -0700 (PDT)
Subject: Re: [PATCH linux-next v2] mpls: don't build sysctl related code when
 sysctl is disabled
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
References: <20190607003646.10411-1-mcroce@redhat.com>
 <ea97df59-481b-3f05-476c-33e733b5c4ba@gmail.com>
 <CAGnkfhx_h1d6k+wZk7xZXnECDZ+Z+oLw9zAWvDFRe+mHLksszA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3dd078f1-c8a7-6b9f-b14c-444b48eda3ab@gmail.com>
Date:   Fri, 7 Jun 2019 12:46:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAGnkfhx_h1d6k+wZk7xZXnECDZ+Z+oLw9zAWvDFRe+mHLksszA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 12:20 PM, Matteo Croce wrote:
> This would explain why so much code went under the #ifdef.
> Should we select or depend on sysctl maybe?

I think so
