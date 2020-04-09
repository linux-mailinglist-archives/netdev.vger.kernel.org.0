Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92AA1A3617
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgDIOlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 10:41:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40458 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbgDIOlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 10:41:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id y25so47960qtv.7
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=chYrNioo211Z9oyfcwlgWKEXgzg8Bnd9vqq9X7HSI2k=;
        b=ItcAkm3z0lcxPtJGRnqJAqKVNl58PrZCKjxV4shp9OrFhYD+aWYM2AW5sZ18na5yJd
         AQIxszGzS0TSy7fh0aaVi2ZP0C1aRigIY7uG7UqF7IDn7K8s+qdxAMcf9Kd6+/nwG4Tz
         uVkbCCqnRfEC0E8HWxJ3E/stzu6AgFpIeN+hX9wvMBMxABnMQYXA2Dkk0aZmzEBFFxEE
         T0X/I/C5WxuVmuuwFZ7TjS2aANKdNFFlbkPR7C1CtV1wjuVEFs9Ny1BwPaP3bLv7oeW1
         d4bw1trb13QLDshWXx7QQt2kehtMw3AW3RxcaEx1HFzup4U/1EYQERgUcg6nxp1L7heT
         t//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=chYrNioo211Z9oyfcwlgWKEXgzg8Bnd9vqq9X7HSI2k=;
        b=LE/mUhAh7ncufATf3/Ksps1nFT3pijiYyxLBSTG2V7XD1Nf78+9KvBr+HTKp6bbhC/
         yY0NZ1zNCSPqckOh5pjfGQNo3HiWkBBZr+qUWXG2D9yoJRuqsXRuDGO9xhc3D89kyRPU
         +C3cSQfWCyi2THsYI1K6wEb8D3t1bEmmZvLaJVRczZSGb0NEL6rOxZWOdqJswMAuRRaK
         1GGA0jFhiEIMqJAb1lEPK7Fw0rr6++ObFWQkWgF2tAQQ1PDNMQrv8/qX3eBHpdhWYG0k
         JNZDfRWrNao+BeOF1MKYpKWX3WPHEX3eiP+aUVZTUcO28EAV12k9VlHRPQfy/mVnweAz
         NhDg==
X-Gm-Message-State: AGi0PuaDGFLpaDSGQX9Uh4ROap4MPW5bg2QRfZzjqp2gnL2/rc8B2jb6
        yzNn7GEmLDlrR0YAEi36R+rtF4hj
X-Google-Smtp-Source: APiQypIVdiVUVpRJ0d8EOsziUcw5OyjLnw1IH22oXpgeIEc8qD7cK7eyWOBx0TqfT7gOzuLfkpbRvw==
X-Received: by 2002:ac8:2921:: with SMTP id y30mr12197726qty.161.1586443270397;
        Thu, 09 Apr 2020 07:41:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c4f9:1259:efe:b674? ([2601:282:803:7700:c4f9:1259:efe:b674])
        by smtp.googlemail.com with ESMTPSA id f7sm18445949qtq.33.2020.04.09.07.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 07:41:09 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/3] Support pedit of ip6 traffic_class
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <cover.1585954968.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a1bacf1-e5db-f34f-44eb-740ae664fc8d@gmail.com>
Date:   Thu, 9 Apr 2020 08:41:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <cover.1585954968.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/20 5:05 PM, Petr Machata wrote:
> The pedit action supports tos (and its synonyms, such as dsfield) for IPv4,
> but not the corresponding IPv6 field, traffic_class. Patch #1 of this
> series adds this IPv6 support. Patch #2 then adds two related examples to
> man page, and patch #3 removes from the man page a claim that the extended
> notation is only available for IPv4.
> 
applied to iproute2-next. Thanks

