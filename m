Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5193F2C40A7
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 13:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgKYM45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 07:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgKYM44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 07:56:56 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7785BC0613D4;
        Wed, 25 Nov 2020 04:56:56 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y18so4110220qki.11;
        Wed, 25 Nov 2020 04:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nNpoxskH44KK9KKuJ0pwAXxPc7WlonO/AVDvFJYaTko=;
        b=kyfFznwFpssDqWqK1A5JgwNdKa6yVAJ+mBMjofSKBvAU6ZKKWBZuSJ0jfcPOPmtq84
         bbVFCNJFKwgSFr4M2mOFguiLUh8MU2O2p/9mzOXo/tV/eNITnU3Pi1IgDicVfurnklB5
         rzY7zCceW9oaxIyptlaB0JUYsVjtokvbXWtVmXI655as7UOlm/JDxTDSGHLSuwyNZpsK
         y999e+tUAx20Xyu0x87WO6lBSlCXyTJ9duWU+MIxytl5ieQNkEljo5fHxQoS3JGPKABG
         Z0ddyatzmmp6zwty6MFjaGnIEoJT64QuOxadPHVr1nrH3bAgQAUJE4uqbViTlJxhqDG/
         Ievg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nNpoxskH44KK9KKuJ0pwAXxPc7WlonO/AVDvFJYaTko=;
        b=VKRNgz3TDQ2NnaCu18OlqcuO2/tgdKU7BlLHaJNyNIeMTE8LeNz7Rw/byhFcQklp4V
         AW39hhN8vQMp3lYkqsI7lNC+7btqf2kTLoqL/sxwIDgO1R8ORO5L/y5rl0U8u4UPfkuN
         WezejggZhZDz63uRSZXNAxAAQI1M5VcZxo6VUwoYf0q4YDub+hFhBVHt+DnZcmXlO+67
         K/sO6LhJcWi7vYqjMKcJqqKMCyRDXZMdVq/EeflAiGr8ViOIk/SHABcpxni2nj7/I/QN
         NvFobw9CTkx9WIukuiIxAhfZojK9+GlW8ImLnVls43CSkRFqSpqtqoRSvRZ2d8EWaZh3
         ttRQ==
X-Gm-Message-State: AOAM531UpvG+4IwyJ2qP/eurchnFKqOzqrW3yYa3V9wYF0fBIcLx1/eW
        Irv4zHWJXtdAstz4MTrJ0nw=
X-Google-Smtp-Source: ABdhPJxRCQXHNQOoJssE+ci+cutD9wtDvvPGp6Y2V8zgIIt9kEvbmCBIhvzEWNU3Yd15VxFc6500LQ==
X-Received: by 2002:a05:620a:710:: with SMTP id 16mr3219043qkc.202.1606309015653;
        Wed, 25 Nov 2020 04:56:55 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id j63sm2229529qke.67.2020.11.25.04.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 04:56:54 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 25 Nov 2020 07:56:32 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     lizefan@huawei.com, hannes@cmpxchg.org, christian@brauner.io,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] kernel: cgroup: Mundane spelling fixes throughout the
 file
Message-ID: <X75UgCWXJjplQ8Kw@mtj.duckdns.org>
References: <20201109103111.10078-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109103111.10078-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 04:01:11PM +0530, Bhaskar Chowdhury wrote:
> Few spelling fixes throughout the file.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Applied to cgroup/for-5.10-fixes.

Thanks.

-- 
tejun
