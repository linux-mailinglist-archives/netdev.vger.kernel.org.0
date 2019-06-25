Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEAF559C5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFYVPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:15:41 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:42642 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfFYVPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:15:41 -0400
Received: by mail-oi1-f172.google.com with SMTP id s184so236905oie.9;
        Tue, 25 Jun 2019 14:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=POe5bHHgDtpbzxjrt786jjHCDMPXcxIA0J28KYsCu0s=;
        b=GfAGRDZMJEVt0vziHhF+DOhuQSZeWce0tOETFnQD7itDpmSABGeFK8hG9p6RtSiZjX
         33nhGfqIOrOyRJKHRQfWT2I/4UlXHSnDrfayprmovsr07cXOu6r5Y8YL6j81dhKT4LVV
         r11VvMQllIdXQN1TOy4xa3m/UVMPHMd2x4qwAkiigUWTJhnsvt9k/qzxeCnVmg/TTQ0N
         eWrQu3H7p+xDM367XVFPCBcWcDWxVTezn8jhR/nceuBb+JY5ZyKeU4LL4iAzsLVW2gg0
         vKK1QQX+MWLzxxUaaVldPXroIGZtZjt8PZsq6XlsvEj0oGeUDluP4bURJrs/XPwjU4iV
         rAaw==
X-Gm-Message-State: APjAAAVk9mNG7T9K0P09qIGE8vDLacMBOWqneBXAGuQTH6M0MlcZjOQi
        MejAXn9n66PbAgfYpcjP6bU=
X-Google-Smtp-Source: APXvYqz3nkS0AXOsaNBdxZ0gPHNW4GqJHlYVpJmHJAWC4CFmio46zkQDNjLK8A5O7x2z7Zj7dNZ/zg==
X-Received: by 2002:aca:ac4d:: with SMTP id v74mr14785594oie.66.1561497340395;
        Tue, 25 Jun 2019 14:15:40 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id a62sm6073975oii.43.2019.06.25.14.15.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:15:39 -0700 (PDT)
Subject: Re: [for-next V2 09/10] RDMA/nldev: Added configuration of RDMA
 dynamic interrupt moderation to netlink
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-10-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f621af3b-37a3-eb97-368a-3201fa49f338@grimberg.me>
Date:   Tue, 25 Jun 2019 14:15:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-10-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 1:57 PM, Saeed Mahameed wrote:
> From: Yamin Friedman <yaminf@mellanox.com>
> 
> Added parameter in ib_device for enabling dynamic interrupt moderation so
> that it can be configured in userspace using rdma tool.
> 
> In order to set dim for an ib device the command is:
> rdma dev set [DEV] dim [on|off]
> Please set on/off.

Is "dim" what you want to expose to the user? maybe
"adaptive-moderation" is more friendly?
