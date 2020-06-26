Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42D20ABA6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgFZFAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgFZFAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 01:00:35 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E96C08C5C1;
        Thu, 25 Jun 2020 22:00:35 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c139so7721977qkg.12;
        Thu, 25 Jun 2020 22:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZVo5w/ZKX78dj3eulXXhuEpFvG8FT3AZePc5ir676VM=;
        b=a8fhX7PosmYTxVaj0Ju89ay9QciM6cW5OE1/9ImtD6BZoZxxGsBRStdIn6F1FkXOcK
         8VnUs2G3P2RI/+d3FmC4EJ3ff9dJtjQf1P3t0BW1jT7mnKQJ0tXOvbKtG2QrN8TssJj4
         ofKfxKEJbjjCS5jZehb+AqHTkqWfnP5usSELUdHIy5iLpjsl5g+V1Yaqs2k6s6wiI1wB
         dggzLIG+n2uJTFKBzVShc6icj9C8Pf1QwfP7ByETEg9yTeL9b/D6UXRBJtS3mz3m/+7E
         rXXZt80XX1srDFySmxAFZrbGtAVF8PF7Nw0Lf4VbcURHeuLIi+Hr5nU/efrybpIaRMXu
         utbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVo5w/ZKX78dj3eulXXhuEpFvG8FT3AZePc5ir676VM=;
        b=iiTQIluChB7YbIvcvTezw7QlgRd1So02jUDYGJW7yCqW0tGN5fvGcrLJYircbWZPeo
         liodcH05/Rmnd1cI8iMOlQLwxb3Xiq6tA5VLiQ41hnfW5YJuRyltCe/qWu40GIiYeqnK
         EtSGgO2Ry/jcq3wTuJecWS5gh6aqUVZchMXcX91I8ghKGsThu+Ff3cMvwbJGBIKuMWTW
         D+m9P1y/wrVhfBTzFC6bpNydFbeOJezmDcTxsjK6tbAvjxRQYHsfb5bX8+s9qBXJdmkG
         Ujb1V9boaKN9rae0f5dkvulriJOhu9EKC/ABaCxLx7fv/1CoLGUqjQQYNW+NOpjqNMYJ
         BJzg==
X-Gm-Message-State: AOAM530eUQhd3ZNbPP5RastNdyBsWGvaJ2EqXubV62EKCgAQHiPvwnqf
        mLowT6ThNe0/RxvKIkyUSXkFFlE1
X-Google-Smtp-Source: ABdhPJxAQHcCPSfIPekWCKhMnVzAtA7pXypis8Q7OfpcnQCbZP7x5fqnf0vzgmXk9JCiY5oaEBtzSg==
X-Received: by 2002:a05:620a:1223:: with SMTP id v3mr999636qkj.468.1593147634295;
        Thu, 25 Jun 2020 22:00:34 -0700 (PDT)
Received: from ?IPv6:2600:6c55:4b80:150f:edd7:a07c:7610:ce94? ([2600:6c55:4b80:150f:edd7:a07c:7610:ce94])
        by smtp.googlemail.com with ESMTPSA id c189sm7990902qkb.8.2020.06.25.22.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 22:00:33 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
 <20200624104012.1450880-2-leon@kernel.org> <20200625081554.GB1446285@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3de842b7-37cb-b487-6e79-2685c24aba5a@gmail.com>
Date:   Thu, 25 Jun 2020 22:00:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625081554.GB1446285@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/20 1:15 AM, Leon Romanovsky wrote:
> On Wed, Jun 24, 2020 at 01:40:09PM +0300, Leon Romanovsky wrote:
>> From: Maor Gottlieb <maorg@mellanox.com>
>>
>> Update rdma_netlink.h file upto kernel commit ba1f4991cc55
>> ("RDMA: Add support to dump resource tracker in RAW format")
> 
> David,
> 
> The SHA was changed because of the rebase on top of our testing branch.
> 65959522f806 RDMA: Add support to dump resource tracker in RAW format
> 
> Do you want me to resend the series?
> 

no need just for that; I can fix before applying.
