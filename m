Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83432B6E4B
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbfIRUqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:46:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41101 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbfIRUqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:46:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so747888pfh.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 13:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WcFSQhyzT5+TpPTmaqxANm1q7R7Sdxzaz+lcQw14DuE=;
        b=vy/XpBtVnFVt9dNjuf3Z8i9pWr4rAANU7kvTq3YIkVlcSy3BB7KDLrfKUFNdDifbUW
         MbGhoxUnfP2DvynYXc8nTDQTsJvGci3pbvNKICSJ3H2wJNkI27Ck/0+hvFbS3THB7D6R
         5oh+jCv9LYUcqZ1u9KU94yJzAu0bjepw5n6ICLZ/ASZ6KYubluw4rS3KRpTWyJeKmF0B
         rUtVGBI+TmNHX7R8qBLG3jT11e+lytIR6xUmuiCFtl9rfOuuGwwLSq5cUIpfyKebPJHQ
         Abhir+NOa+WSQtBWz6DBxhGyRKz+Gu9+3Ts0RAdfSGnY96gOn+tPPEf1VRFayd9kb4yO
         8+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WcFSQhyzT5+TpPTmaqxANm1q7R7Sdxzaz+lcQw14DuE=;
        b=tNFdRfjuaLjjog76aD5m8aa/PyfZbBOInkh5evPYxTqjepCu/iQVVnITbwISXAh0oH
         uyQ5dUQLpRfy7SVsPI2eZylsMvLOcA15P1Tbb3Vr/etd3bn+vrkefVoh1w9NTi8lwdiL
         XyWzklKTbTthoU9Eg+ye4c3pohrA8UlWVtWM/RF491mYh5hXrziP0+FsEvDoM+wPr29j
         C2Z0kR4mtPS/HCM0oQdCvM8k6Wj6rfcEDBgfpqcqI5KdcMrGfKzGQqK2Ht5JT6RATwDB
         h0QlDhOx+HrHiJ6Gnw8kDmu+d/9fICZz8AqewPlNlYkKIw5aeWXvi87NmqGCiDEJUyII
         aoAQ==
X-Gm-Message-State: APjAAAUWXiB7crs7d1JROiHCVUq8TiIh0PWK4FFfauJeLiNy4DNbGv4f
        K5Rthnm3y8CHDdgFCEVSXcw/3w==
X-Google-Smtp-Source: APXvYqwBbnAdmulUv+EnLgF6a+92aHRslz+sZEZ5FZPeHdhG6J6tgDfsN/VyIdDue6tbbZlvPme4fQ==
X-Received: by 2002:a62:3893:: with SMTP id f141mr6099018pfa.221.1568839597633;
        Wed, 18 Sep 2019 13:46:37 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id z23sm5605135pgi.78.2019.09.18.13.46.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 13:46:36 -0700 (PDT)
Subject: Re: [PATCH] ionic: remove useless return code
To:     Arnd Bergmann <arnd@arndb.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20190918195745.2158829-1-arnd@arndb.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <6cdb1e21-44d9-bba9-1931-78f7109bff2b@pensando.io>
Date:   Wed, 18 Sep 2019 13:46:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190918195745.2158829-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 12:57 PM, Arnd Bergmann wrote:
> The debugfs function was apparently changed from returning an error code
> to a void return, but the return code left in place, causing a warning
> from clang:
>
> drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: error: expression result unused [-Werror,-Wunused-value]
>                              ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
>                                                           ^~~~~~~~~~~
>
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> index 7afc4a365b75..bc03cecf80cc 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> @@ -57,7 +57,7 @@ DEFINE_SHOW_ATTRIBUTE(identity);
>   void ionic_debugfs_add_ident(struct ionic *ionic)
>   {
>   	debugfs_create_file("identity", 0400, ionic->dentry,
> -			    ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
> +			    ionic, &identity_fops);
>   }
>   
>   void ionic_debugfs_add_sizes(struct ionic *ionic)

This has just recently been addressed by Nathan Chancellor 
<natechancellor@gmail.com>

Either way,

Acked-by: Shannon Nelson <snelson@pensando.io>

sln

