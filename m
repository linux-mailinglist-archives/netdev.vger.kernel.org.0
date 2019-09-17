Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82458B58B1
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfIQXkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:40:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38420 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfIQXkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:40:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so2854083pgi.5
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 16:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+Hy1zYT45CoUKVQY5bAeFzJ87DLdn4Gay+OsZiEpRs4=;
        b=mtru1eNwIQSV3dlGNRC28k+zRHRvu+HdIye1SYOiL3AVNziG45WSOwh1/iCHUjO+D6
         G1+DUZGcTRXZBvz6yYvqOOUKCVq3eCmd5EAZewQcmDxIqtXWldmjXNiDonDkVRd0gPde
         j1DhMOMcorIfaaLKn8Uh8kCM7aC1nMDl6vYe9nQWaUqZbLEdwW6St+y6sAXRb4Y/joc7
         lmOJjvyAhWO7F0mspD7WwEjz51fWbbDFutUH6+XSsGNpgP+YQ5QYdRfJt+aqhWFnXxz6
         sS1Ym2+P4ezW9Cy4aEgtZC25ZQ5xN515be3xrChpDsDHwXCIBm7LiUtn0dz9fNwYxxEx
         6gHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+Hy1zYT45CoUKVQY5bAeFzJ87DLdn4Gay+OsZiEpRs4=;
        b=C9Bt3d/io8nu0vsEZYaLIyepD2DtgHGgNPoOItVnKqH8vHIwR1NPFkocT33nuH4JRU
         fwAFje3BSh8QZOSN2/U/cLPF1nALxZexFhN/7I9ag3QeFe88Bhncm5i3bYzXFzs97VEK
         lsj6I3IpdvkRCEyyxpWPczQDFEFpy0xjJ2tUu0yD+Cttuta+/UwSlmtuzXWV6gJgml+x
         d8ULB1B8zy12tuTLYDJBQ7kXpiHS2iqhnEG1ucr7Nhtl+aH7erY30VidLlU8zgDdKIBJ
         OxIMohZi0JectNe/jKOzW3xZsUWo3AK0y8vjbG7pL6QbrkQe6S7Pp3v4RVfSL/JWWkJE
         dJdA==
X-Gm-Message-State: APjAAAV+K0EI0EH8RnMTHB11+C7LVdXvsVwD9NR2uhVDM090T7TIOrGU
        cfqnt9nWM7B+qhXxarGN4uLneQ==
X-Google-Smtp-Source: APXvYqxhMR7uBI/khZV54DZoj3pvTNTGeFw/f1zb5YFRj3Fq2qEQxNa+fCNNC/6DQtF4q9oDvPNl0Q==
X-Received: by 2002:aa7:8189:: with SMTP id g9mr1024631pfi.78.1568763616104;
        Tue, 17 Sep 2019 16:40:16 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id s21sm243905pjr.24.2019.09.17.16.40.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 16:40:15 -0700 (PDT)
Subject: Re: [PATCH] ionic: Remove unnecessary ternary operator in
 ionic_debugfs_add_ident
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190917232616.125261-1-natechancellor@gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <53a991df-fe1e-29b2-4af5-c1702e5dc626@pensando.io>
Date:   Tue, 17 Sep 2019 16:40:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190917232616.125261-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/17/19 4:26 PM, Nathan Chancellor wrote:
> clang warns:
>
> ../drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: warning:
> expression result unused [-Wunused-value]
>                              ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
>                                                           ^~~~~~~~~~~
> 1 warning generated.
>
> The return value of debugfs_create_file does not need to be checked [1]
> and the function returns void so get rid of the ternary operator, it is
> unnecessary.
>
> [1]: https://lore.kernel.org/linux-mm/20150815160730.GB25186@kroah.com/
>
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Link: https://github.com/ClangBuiltLinux/linux/issues/658
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Shannon Nelson <snelson@pensando.io>

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

