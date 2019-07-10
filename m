Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32BB63E9D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 02:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfGJAaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 20:30:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43587 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfGJAaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 20:30:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so235497plb.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 17:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VxNPpq0Jd+NyuJ3TlIauKG25row3edFwTshrSz9iWA0=;
        b=i4WIQByJZgWnY4Y3mZMlK0RpkPJf6NMBayHurtupkmr6oreto3gfGkiFSr903qTgeV
         Zxd5q0m6Ey9w0WbIY52yeVhKZ9NMDkCrmC8gZEq6slwzi0MQR3Wp8Rr/pmMo+HojxZSn
         VuiYkm4o8AOGRoHQwMgNBrE0ZW+dhKqD8YzugweDvHBYn0JrgVfaxCCBM1uPCn7ePwFh
         4w93r2OhrY1tjxJ5geEGCfqpPexeugN/lKA8H1eLj2DQi2nfwWwpClR/ecIjND9hh4n1
         askWAAPfXwu3NB33DP8fh/GdGomcV1kVHODraBH6mX6RF7XUI8BINTnNxaad0vUFvRKh
         gA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VxNPpq0Jd+NyuJ3TlIauKG25row3edFwTshrSz9iWA0=;
        b=J8vOmm/uqtpbgmbsdJcxDhxPNQwewmD/WLRboFyev9fEPn1LFTa4jzWIzLxYvfucEA
         QzZmCnlm7Wm4btziQTpx4jUcI3QHl74r9n47aDweiAbISCuZg3TB3LJQrVqQfE6b3MvV
         Hk6U9yFv1m2L2RhessQAvsUutajQXf2BgV1zdMawg96o8nJDxKtC628n2p7tWC4YgKfZ
         tZBp8pa4j0mblaGayfcrm0v+OsKcI7LMYSKkME/sFLi205Vg1Rc3j9vKvfOE4CnvbNC/
         C0j+Bt9frOuNemWI36sDeE7kkRTGGS2vAA1dS/Hq8OhQ5PTYTq/uHwkoW36SqtJgGNqo
         sU0w==
X-Gm-Message-State: APjAAAX56gajm4VCXQAA5F6xqwSu+s5xLaHsVPlxIUsNlOvQ6DU3D7qz
        kyQtfUW8d+RRuDGxynQ8n/OXfg==
X-Google-Smtp-Source: APXvYqwe5zIrJnW6ZtjBcN05GBE1gj/71XFlymyXH7RaIKHK/GrmOKbvKB+McnHYOB0BLWyYCcXQng==
X-Received: by 2002:a17:902:ab83:: with SMTP id f3mr35511222plr.122.1562718605184;
        Tue, 09 Jul 2019 17:30:05 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d2sm244969pfn.29.2019.07.09.17.30.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 17:30:05 -0700 (PDT)
Date:   Tue, 9 Jul 2019 17:29:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2] ip-route: fix json formatting for metrics
Message-ID: <20190709172958.4a1b910e@hermes.lan>
In-Reply-To: <f1535e547aa6da8216ca2a0da7c06b645a132929.1562578533.git.aclaudi@redhat.com>
References: <f1535e547aa6da8216ca2a0da7c06b645a132929.1562578533.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Jul 2019 11:36:42 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> Setting metrics for routes currently lead to non-parsable
> json output. For example:
> 
> $ ip link add type dummy
> $ ip route add 192.168.2.0 dev dummy0 metric 100 mtu 1000 rto_min 3
> $ ip -j route | jq
> parse error: ':' not as part of an object at line 1, column 319
> 
> Fixing this opening a json object in the metrics array and using
> print_string() instead of fprintf().
> 
> This is the output for the above commands applying this patch:
> 
> $ ip -j route | jq
> [
>   {
>     "dst": "192.168.2.0",
>     "dev": "dummy0",
>     "scope": "link",
>     "metric": 100,
>     "flags": [],
>     "metrics": [
>       {
>         "mtu": 1000,
>         "rto_min": 3
>       }
>     ]
>   }
> ]
> 
> Fixes: 663c3cb23103f ("iproute: implement JSON and color output")
> Fixes: 968272e791710 ("iproute: refactor metrics print")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---

Applied, thanks
