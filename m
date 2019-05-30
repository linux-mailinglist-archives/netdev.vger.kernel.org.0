Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616FE3013A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfE3RvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:51:03 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42415 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3RvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:51:02 -0400
Received: by mail-pl1-f195.google.com with SMTP id go2so2843988plb.9
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fLnZj75qO8uroZ27x9UjILoLPCbi18YujXciK45P7yg=;
        b=QbMtD4l4+zQl+KXXVGe7G1cq7yYzkDy0mwWmg+M0qkkMrXk3G52rlhADE1tHGpwtq/
         WGLmyyPvB4ZVe/4PHrWHefkjL8aIBu64SjaTpP4BXsQfQtkx/jcJHf70jiY213JK+3b3
         ZdyZ2YKZe75Ul71A8laf/AdyOj757o+aZ6JG+C8Z2XiiBeFP0ykPyxqnG8VU2tsHQa+H
         C/AWJV0UYfE6LLkM2edZDBZu1Vc741pf9oXceLnmdDqZDO8XraVLzLS7v+5XPeqE4wDL
         2RFXBWIRJB0+DLZrbNWFSikJ6Griv+A3TjMScwNlsp8WZW9x90n+eMZMyZDByT6BLCUD
         u/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fLnZj75qO8uroZ27x9UjILoLPCbi18YujXciK45P7yg=;
        b=lf0UfO8GE5FlxhKOAD9rjofOmw5bro243x1K91hSa3we7s5DQlCKg3qkdQtUmVcCYN
         0Br61NrMuxob5/8bxwWbbHyI0UFYw92COWHnRs3dQ1b0jqFwc1z4AWnzaBhUJGRueA3N
         QKHU634nyrRzcWIvL2kb1/7YsttIzm6aD4nHAqK/BMMCY0rOnRcM8FdugToVjtYkwVA2
         5PgIZG84luHTPZI9dw6xKZ/zRu0Qgrz2cD3vpXzWNtkD4ioBp0RpgM5KtNRLa7DX7xk+
         ctYSSaGy7k0u/gMKSmKnE83WBZKae3SscGC6ow/pakJX7dGQSbUNcpZUTb7j+XVKikur
         Bp+g==
X-Gm-Message-State: APjAAAUCtDKnpQ5UgdJ6+qLk9BKEBIBXirSk+RtpiJ7HQelxRgT2qDwA
        Ze1T+deiCJXx11lOFCzs24W061X3GBc=
X-Google-Smtp-Source: APXvYqxN2Il+QuujUBpP3TdycIdV/NTz2rzqepuKaLNYfx3lbBhcNDDI+FcLRxB0ZZ0C6lmGCgXVyQ==
X-Received: by 2002:a17:902:f212:: with SMTP id gn18mr4915501plb.106.1559238662017;
        Thu, 30 May 2019 10:51:02 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z7sm8035604pfr.23.2019.05.30.10.51.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:51:01 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/9] libnetlink: Set NLA_F_NESTED in
 rta_nest
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20190530031746.2040-1-dsahern@kernel.org>
 <20190530031746.2040-2-dsahern@kernel.org>
 <20190530104345.3598be4d@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <22198e57-c573-abe6-16f7-92796daf7025@gmail.com>
Date:   Thu, 30 May 2019 11:50:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530104345.3598be4d@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 11:43 AM, Stephen Hemminger wrote:
> 
> I assume older kernels ignore the attribute?
> 
> Also, how is this opt-in for running iproute2-next on old kernels?
> 

from what I can see older kernel added the flag when generating a nest
(users of nla_nest_start), but did not pay attention to the flag for
messages received from userspace.
