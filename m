Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA107114808
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfLEUY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:24:56 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42466 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLEUY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:24:56 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so2126685pfz.9
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qFbyHRBwHHkzQendxTzgeJN641cBaeFQeazwdrNkSfQ=;
        b=s98Njp7zUWJJZIlSzCwAQwzzuLHF6FCcJ8R5Cx2XwQ7r1xMpDkVmirF9Q/7+KvZQN7
         9eGvHvWeaNXY0R+6D4wUH5FotXdshaISBbUbmLPQn9oB6k84cGgknPfmoN+O2P7bXojN
         H6U4vCC7lqfejJNb05CYBxZ8rFf49v6Yn8SlzwoH/XHNYCCM2vTVa5wgElaSVg/dSINO
         ZixI4zeoNoCo5T0vacja0W7gcPCJ9cBRGHE87dGMCSW0g96NAuGXknM6xtpOCHJ6jbjr
         WFyxVZKrnsTAcPkpOPXy0LQnJoq1oABQNCtHMjlNDuzej2Ild2NScwCYloOk6XWRAadd
         9qgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qFbyHRBwHHkzQendxTzgeJN641cBaeFQeazwdrNkSfQ=;
        b=KV/dNMGdz36+W32DImySM7UPMq3HPqgQAVnXGGfopwFoWLXQPPxPxfgzY9LhAb0pyd
         +DYSZ2MIwUNilMi/7RA9sJZkWU5cul4evXwQNbUsQ3NBPmR7rt8zdFAHyysrLw2LNqnb
         ZsyMD/d0dF+ruqYdqZf4xt1i6cqqJNGgKcBMn/EGnMSaUADxyEZX0trvBogyDQolI/X0
         WuAljvr82BzKUb2GSRfRVcu+Y8JEXcaAFNypY4kkgBrtcJKkZfhOMhemLnegXwnSaUZ0
         yCixLX4uVTpZvjeadieh8gf/Z0v7S0deIDrVwX6YLiX+iAHk+MsU2m9g8PAMeJiEYC02
         /SGg==
X-Gm-Message-State: APjAAAXT6VFMoYkjAF9BFgAcjblR1hsFIKv5hnd125pdrlzIswCISntl
        odw+Lp6BIw5R2ybZd3CtI7K56A==
X-Google-Smtp-Source: APXvYqwReznaks5gx9U1KHmxOuHmjI9G1tu9l+llO0OP6xYzF1oL1vWl40wPwBc7wb7KuB6kMVf7Hg==
X-Received: by 2002:aa7:90c4:: with SMTP id k4mr10497674pfk.216.1575577495438;
        Thu, 05 Dec 2019 12:24:55 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u20sm12185596pgf.29.2019.12.05.12.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 12:24:55 -0800 (PST)
Date:   Thu, 5 Dec 2019 12:24:52 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Hritik Vijay <hritikxx8@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH iproute2 v2] ss: fix end-of-line printing in misc/ss.c
Message-ID: <20191205122452.5922112d@hermes.lan>
In-Reply-To: <20191204213228.164704-1-brianvv@google.com>
References: <20191204213228.164704-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Dec 2019 13:32:28 -0800
Brian Vazquez <brianvv@google.com> wrote:

> The previous change to ss to show header broke the printing of
> end-of-line for the last entry.
> 
> Tested:
> diff <(./ss.old -nltp) <(misc/ss -nltp)
> 38c38
> < LISTEN   0  128   [::1]:35417  [::]:*  users:(("foo",pid=65254,fd=116))
> \ No newline at end of file
> ---
> > LISTEN   0  128   [::1]:35417  [::]:*  users:(("foo",pid=65254,fd=116))  
> 
> Cc: Hritik Vijay <hritikxx8@gmail.com>
> Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> Tested-by: Michal Kubecek <mkubecek@suse.cz>
> ---

Applied
