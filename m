Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEC6BF6BB
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfIZQaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:30:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43069 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfIZQaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:30:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id f21so1266638plj.10
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 09:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=iUBOjyHfuR7bXfhhUiHsxfKRvIQzrO86xTAr8Ifre0Q=;
        b=y3h5OT0UmQqXJi0n0rBvqkcTo+13EdxQBhESuHKUhhUdt4HIIcVQewbszw7316Jbj3
         B26hOzlkXv8XsgeN5pGs7wsfUu35kRVDjdfbd80Cz2QkLIg0M3MsvsJVJdd9QD5RXeiy
         6UEhQ9sxyZ6zQojKZM8g8YSAiU0HmfS6EeGLmm2G3M5zDUXby8glVotg/+s3ve95UAlT
         DAQ0U/ntgxEnEPfGxe+68Qz99D7tUdj8cjDtGb+44i81+8OKBcckxrd+3wvZeL0MsCVS
         GUydrXVlNXeNeT9yD3EB7dKB2lMU1zF3uY6+lKZ9hv2ld2NLoMT31L6wdQwnvoc03z5L
         JHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iUBOjyHfuR7bXfhhUiHsxfKRvIQzrO86xTAr8Ifre0Q=;
        b=Cfj5JyLVbrjjXtrPaPuaqeqSZQSqYANIlNOFCAkP+64llWkS63PcvUWxPiv/Rt8263
         2EGYlZnBSiwlxEZ5MubAhFT/8q+TKkVd1OdUYOB6jNelk8533K58v2NmUQ/Edls7m/2X
         TVHqEZQgSLW928zS7rnAfOlLpwyQslZe27uK3CXqXwiWemuZGBepqheVZU9qmD840gL6
         x45yFfG/pGi98RuFLuNF7lXU5HrGaIpi8anGTpTjK4lUa0Gp6qugJLuCOTalZm62mgMy
         kPS4shFa/5jzzKzAs3MiGylvZxf1DJKltpeGj0abqQeEUQ3QKopmQnnEYLPLJwkoyZhW
         7jXw==
X-Gm-Message-State: APjAAAVJ4sn8uFMXwXZzGKA7BfU07upzliqSuVF3mExwdJgdSuPRFaDv
        vdnwn1PgNcigaYQQzm2LAqMPjg==
X-Google-Smtp-Source: APXvYqzWSovEndvhpUlPPG2KWsLiHc/5J0wB0jU8KW7kk3lkOzlRWdHFYbFHIpUg2H8EkpfjsR5P5g==
X-Received: by 2002:a17:902:8a88:: with SMTP id p8mr4822043plo.152.1569515400373;
        Thu, 26 Sep 2019 09:30:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e127sm3547209pfe.37.2019.09.26.09.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 09:29:59 -0700 (PDT)
Subject: Re: [PATCH 1/3] docs: fix some broken references
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        corbet@lwn.net
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pensando Drivers <drivers@pensando.io>,
        Steve French <sfrench@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-riscv@lists.infradead.org
References: <b87385b2ac6ce6c75df82062fce2976149bbaa6b.1569330078.git.mchehab+samsung@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <81dc41d5-606a-7638-1d11-4fe53e9c2a7f@pensando.io>
Date:   Thu, 26 Sep 2019 09:29:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b87385b2ac6ce6c75df82062fce2976149bbaa6b.1569330078.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 6:01 AM, Mauro Carvalho Chehab wrote:
> There are a number of documentation files that got moved or
> renamed. update their references.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

>   drivers/net/ethernet/pensando/ionic/ionic_if.h            | 4 ++--

Acked-by: Shannon Nelson <snelson@pensando.io>

