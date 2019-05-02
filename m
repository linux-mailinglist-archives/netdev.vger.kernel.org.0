Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05038124EE
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfEBXLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 19:11:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44390 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfEBXLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 19:11:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id z16so1735344pgv.11
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 16:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5uOmrse3OrrTabvGv8JDc6t1bnjYpsuzAtsDdD7pYkw=;
        b=seRNFyPdJZsMsyTvPfjDviC+vBEFcWu9Qqzi39YzV++CulopyiUDRmanpEJqMSLG57
         ez2NQ59QXPlH5b5Qbx6O/GgyD6EBrwmk+QeG6xWmS/QOeebZ3tM0kcQQCPraGjm2DKaT
         Zytvsq9mAVQMgbcbEdF8dwJ3jsItKF/rfhujJ7RvwpqZEo7tMQDHtPTxktezhHRbIibN
         hJaOurGuwmN84PGsoTd7KpbwMCOXhFptn6UzewNOE8IRe1tN027KG7LzO+3U2rmfCi6+
         aAhdw9JRTjpDvkbotJq7woCvk49kp2rM7c+Uq9luGq3tcfcInvWEocOQmE77jFY/hjT5
         c6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5uOmrse3OrrTabvGv8JDc6t1bnjYpsuzAtsDdD7pYkw=;
        b=oPPVrSdU3SMMo1VM0FMijx4zvdXSC1ALXoVBDnkQYUMKnj0o0QBp1pF3Suzdrvtah7
         fddHDSmjfWLXzsHhUxUnw9Iz1PUT4JpDvEQpXutvz7Iu/b2+Od50Jor6YvjVO4AW0m5Y
         PqANwNdSNBHnxPrs/NVzeoDLU7mVvcdcChoCd7mgNI44KAAXQ1C+pAWo2cVeSJe6jcPm
         D0OJZGrOgV4T6ECuEbdFu0XiKgQySbzzq+YnZVmL+AIv5c0pHh/9afBAZ15IqkA366X6
         rkQqG+wjFgXIgNmEPEqkX+NU4DSqHNX8tArt4btM5Nts5bip0kHHMdu4lbQLei0RT2yG
         fdDA==
X-Gm-Message-State: APjAAAVfo4H706HuuimfYwLy3RrTLZBmW5xvWWVCOvWV4CYwgehpdEiB
        bcFqmd9DMj8VxghvsxnZBC74zcPE
X-Google-Smtp-Source: APXvYqyug/s4ZdFCVGJ7YyPIYfNGuvwyXxPD7hq1oiQhCcGgDQHhwQlwiFzPAE/w7FbqmB8i4KJ9TQ==
X-Received: by 2002:a63:1b15:: with SMTP id b21mr6555641pgb.364.1556838697614;
        Thu, 02 May 2019 16:11:37 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ac7a:3232:c2d1:fdde? ([2601:282:800:fd80:ac7a:3232:c2d1:fdde])
        by smtp.googlemail.com with ESMTPSA id w190sm307797pfb.101.2019.05.02.16.11.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 16:11:36 -0700 (PDT)
Subject: Re: [PATCH v2] ss: add option to print socket information on one line
To:     Josh Hunt <johunt@akamai.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <17702d09-ebfa-c3a4-e1a6-403a3c552e37@gmail.com>
Date:   Thu, 2 May 2019 17:11:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1556674718-5081-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 7:38 PM, Josh Hunt wrote:
> Multi-line output in ss makes it difficult to search for things with
> grep. This new option will make it easier to find sockets matching
> certain criteria with simple grep commands.
> 
...

> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
> 
> v1 -> v2
> * Update long option to --oneline to match other ip tools as per David.
> 
>  man/man8/ss.8 |  3 +++
>  misc/ss.c     | 51 +++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 44 insertions(+), 10 deletions(-)
> 

> diff --git a/misc/ss.c b/misc/ss.c
> index 9cb3ee19e542..e8e7b62eb4a5 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -121,6 +121,7 @@ static int follow_events;
>  static int sctp_ino;
>  static int show_tipcinfo;
>  static int show_tos;
> +int oneline = 0;
>  

dropped the ' = 0' which is unnecessary and applied to iproute2-next.


