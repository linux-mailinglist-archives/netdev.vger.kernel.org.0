Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6071B2227C2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgGPPqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:46:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60325 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbgGPPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:46:25 -0400
Received: from mail-vk1-f199.google.com ([209.85.221.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jw65X-0005hl-E0
        for netdev@vger.kernel.org; Thu, 16 Jul 2020 15:46:23 +0000
Received: by mail-vk1-f199.google.com with SMTP id j198so2186381vkc.15
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 08:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49511E8U5NzXj6XxH4TCed0T2TTPIp8dIWRGqxsbGQ8=;
        b=SrKHZJ1IK0hBJbCmU9rBH+sIbG4xblcOPjYtbwNdNMQTVfc3RW2UDsmMAT2X9I9sZR
         BBCG0f1koRNoIy7u68IebJ+zwLOBklN3+HTvO1i52IgO43O/VYmq2/xh2UyKLIbCshLg
         TjzBdCQgEyy1z8vNvHTxRvwXKK5TSf1KHRD5MYEQ9AfJo4JjVpqKuhK+qo2P3qsw+vu0
         0k6K0Qamv8YPVCylz1hk+YkMppGQgouT6K9RrODWRl69coGn+bOjqGBi95/+2vmkqDYN
         kXEuJhT2r82n5nJ1QVkQ8/rv3yw6vnBQoWfvsizuDAM+zGR8pwtggTAePsc6Qc89/D7L
         j5EQ==
X-Gm-Message-State: AOAM532gWYoZ1oz/dcqhTEoscJ/8oH1RDQJe5+2W0iQi9YyAlqegh1q5
        mNWznE5sHY+i4WLhEhgbc3UKPOR/loFL3YQjU6PlMU4Mh9no/+1+gycgrX/hSn7eOPsor+sZ1hj
        zmo6jiOEhs/3/HBxVpOhyPa7lk2WltFAfN0d8ZOe2foUK3gAyWQ==
X-Received: by 2002:ab0:316:: with SMTP id 22mr4021370uat.41.1594914382439;
        Thu, 16 Jul 2020 08:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjBUFlT4V7UrutO5eSdMrKrzPd3+TUuc1pXG56i1MfLoBhtZFvasxN99/Oi07H7IokRV/M1tkLBOlMIoeNZWY=
X-Received: by 2002:ab0:316:: with SMTP id 22mr4021357uat.41.1594914382214;
 Thu, 16 Jul 2020 08:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200714124032.49133-1-paolo.pisati@canonical.com>
 <20200715180144.02b83ed5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMsH0TQLKba_6G5CDpY4pDpr_PWVu0yE_c+LKoa+2fm2f4bjBQ@mail.gmail.com> <20200716083844.709bad58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716083844.709bad58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paolo Pisati <paolo.pisati@canonical.com>
Date:   Thu, 16 Jul 2020 17:46:11 +0200
Message-ID: <CAMsH0TT0yYr0R99aN8sn8nTjWryt0wo+4wHLbQsNuPTruXk8qA@mail.gmail.com>
Subject: Re: [PATCH] selftests: net: ip_defrag: modprobe missing
 nf_defrag_ipv6 support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 5:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> I don't think modprobe fails when code is built in.
>
> $ sudo modprobe pstore
> $ echo $?
> 0
> $ grep CONFIG_PSTORE= /boot/config-5.7.8-200.fc32.x86_64
> CONFIG_PSTORE=y
> $ lsmod | grep pstore
> $

Ah, i didn't know - i'll send a V2 then.
-- 
bye,
p.
