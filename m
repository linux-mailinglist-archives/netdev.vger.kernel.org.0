Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDB2D3672
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgLHWr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLHWr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:47:56 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DADC061793
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 14:47:16 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id y74so285473oia.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 14:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u5UkKTVdVSQdzgLxe0Sijc9KEJH+Y+fH21l3fscA5vs=;
        b=g139F4IDeHgHKJHGAegseG7moYs36Ptas3/bhdgZbuWODhpJYEC3bRoSoX4mahPpZF
         CTgZYCdywqaiwldwn+JhNBIuhHu3JKvCMCNnhKb+w9xguXJc8d9f5ug6LT2wtrErEqg3
         hUZ6RkorqceD+3Iy5LXW8rV1YEYLsnW7dQfWQxtvDKGIo6Ft4p9y1mPCQ8mYhf2kEpIf
         TmCveENINZk+ANva2SY5iswWbb/8Wnj9cXVMC3OtOcT9mJT+InGKIXbCoWtZNsa8+/2R
         Ts/JqcJXs2j+mU/Hn7ZThyzPChd5si0MgALfey+lJ6Y5iWpMnh29pbOWUXcjM3Z4BU6/
         g+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u5UkKTVdVSQdzgLxe0Sijc9KEJH+Y+fH21l3fscA5vs=;
        b=TclZ1BorrdzrWpwVgKyEVEJMgivSmWwrzc99v9YvHOnxlVh0sA7M5QXBciZzdQ0JIK
         lLpeNeND9zdYrDi1z4UFanCVdxYJQu8ayS+pTucxnODNbgy66YsKVlXT7tTogckZZGJp
         QnAk0LSfxVZVZVN9+wUjaq1lTG1XlQJGt4gaqtnZk6d+dssTd8A8UcVWBVLy7/6sqANp
         htrJ/+Qk6DqUYd4duN7Nkb/0yB6PcLhDbefIL+LxHrpTBdLvnvJj3TzLnxk75aZy6Gs0
         SgpwCieLf7vI/miPynyEqcrO3+vU5iTg2zdpFp1EmR+vYGbmX9ULjSgJUR5Q6nCW5HZ5
         Zy8g==
X-Gm-Message-State: AOAM533YX7I9vIHEtSJvBYfqwWdJlM+bhQMJDIO7l3whjGNaEc2G4v57
        b1TAScbudVGRjK7OKAhU2MY=
X-Google-Smtp-Source: ABdhPJwSB4hWMNVXjX4Ea5vURzGXJi/XgHT08yVWomFi+EIMWtOjHX0E2mjpzO3VnHkPUX0tFwkEJQ==
X-Received: by 2002:a05:6808:9a:: with SMTP id s26mr123604oic.124.1607467636251;
        Tue, 08 Dec 2020 14:47:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id j11sm82418oos.47.2020.12.08.14.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:47:15 -0800 (PST)
Subject: Re: [PATCH 0/7] Introduce vdpa management tool
To:     Jason Wang <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     mst@redhat.com, elic@nvidia.com, netdev@vger.kernel.org,
        =?UTF-8?B?6LCi5rC45ZCJ?= <xieyongji@bytedance.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <831884f7-365d-b974-0bc5-f72729add98f@gmail.com>
Date:   Tue, 8 Dec 2020 15:47:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20 8:53 PM, Jason Wang wrote:
> 1. Where does userspace vdpa tool reside which users can use?
> Ans: vdpa tool can possibly reside in iproute2 [1] as it enables user to
> create vdpa net devices.

iproute2 package is fine with us, but there are some expectations:
syntax, command options and documentation need to be consistent with
other iproute2 commands (this thread suggests it will be but just being
clear), and it needs to re-use code as much as possible (e.g., json
functions). If there is overlap with other tools (devlink, dcb, etc),
you should refactor into common code used by all. Petr Machata has done
this quite a bit for dcb and is a good example to follow.
