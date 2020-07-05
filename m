Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42067214E5E
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGESHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgGESHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:07:35 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11E8C061794;
        Sun,  5 Jul 2020 11:07:34 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id p7so16287384qvl.4;
        Sun, 05 Jul 2020 11:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H3JHNlZEFLYUD0Csnavf1p1KhCwBzghQVVRAfUmCHfc=;
        b=H6GwFjjdzV/JNNoVy+NJc0L7HFdgU98wISB75jZaIzSjVOwmE3wtT4j9R5NohMFyw+
         zRWrm433PmGEbjCjs+PEoJjvxBYGU2m56VeZGL1bQ3MF2exP1mRK2qyLvK+vQ1JawWqK
         RRESpnQmpwHLuw5zmot5mL1nlGxGoXosJMcucOaa1NJNb7BWLMMzNgj+L9hSsZY6NaJz
         lm2lUJqab9DtglpjDjslbxVhEXVfiFX0VaWv6XEktIZ1QGC0BHOGDe8qBqkS5NS+hFsU
         0ja913++ooNVDbbTGKdHrtx+LG0NHg2R1J7yy+2ExWLB3a7Iv/695W81/zal5SHT/BWM
         yqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H3JHNlZEFLYUD0Csnavf1p1KhCwBzghQVVRAfUmCHfc=;
        b=W+sA5ITS7ckVNAH1Wb3+aaQLG7j5laaaVKQpRCVWEL9PqH35+LOz/sQM+2fk5j6F8k
         y8CfSpklwfQEAHtB60w/atReA+Ih85WDh5i89ob0Z/FodKPwEOZhGXdn9/pdhOZAs2TT
         2YwNjZ67OZ4WiBNV+r0Kdh/sI2oVyF8WKlaCzwPfjqE4L/HargUiVQKPaq88fg7TnjTx
         WHJlB0BdB8CLF62gOSFRIoTbLTquG4fN+rniIViqo4oIpV2GN7z0651/jOhSJaLnPqgm
         n4bdnzB9xbXmAxTGsjGHaSRsUPqtnalYn6EckyOL2FPJ9GcPtMpDr0EPbzJEXB1MPd0M
         N8Mg==
X-Gm-Message-State: AOAM533L8GrZoTnFNZciY6W9jdmWLUHWQH6X+K/D89hxWZsl3gdkd/PR
        z9pvSrfuInALqh+kswFG3Cug1og+
X-Google-Smtp-Source: ABdhPJzZNOeOX6368RNLIKJ2eaybZ+PQHeVOz5Dc5WAySBqcAF8K3dFhRtQz1OPiz+DGaAIdB7KYog==
X-Received: by 2002:a05:6214:328:: with SMTP id j8mr29194922qvu.75.1593972453623;
        Sun, 05 Jul 2020 11:07:33 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id t48sm19563548qtb.50.2020.07.05.11.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 11:07:33 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
 <20200624104012.1450880-2-leon@kernel.org>
 <e91ebfe0-87aa-0dc4-7c2c-48004cc761c7@gmail.com>
 <20200705180415.GB207186@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4785306c-f05f-ca63-e8f6-9b6d6b454bd2@gmail.com>
Date:   Sun, 5 Jul 2020 12:07:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705180415.GB207186@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/20 12:04 PM, Leon Romanovsky wrote:
> RDMA_NLDEV_NUM_OPS is not a command, but enum item to help calculate array
> size, exactly like devlink_command in include/uapi/linux/devlink.h.

ok. usually the last field is __FOO_MAX not FOO_NUM.
