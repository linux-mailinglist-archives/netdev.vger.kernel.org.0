Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90574A0E9A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 02:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfH2AT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 20:19:26 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:37661 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfH2AT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 20:19:26 -0400
Received: by mail-ed1-f44.google.com with SMTP id f22so1993053edt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 17:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FReuv9xFMVyvTNZfWrNQAOSzgNlbJG2Wu8muxrtJB5s=;
        b=MTHp9BVd8Hlh5eMYeb5tusA1fszZvok2TPfm9whZyojE+0HEctZCne9g38mMzy2cvW
         1DuhcDnWbXAQ/nJUyyQb+q77MPp+cbKQuPE4bWcYwCE5w2BLxoymWolkUq5E96eRD++7
         s9n9+CSNUTU7nhlALXmqARusbmIP+BNu0Sdg+WZm1Tk90soai1J+3d6fZv+k5hrtHyjd
         ugXc+z+TAP8+EkGjDSQL+nOejvAMtHCxPP6ieawjWD7pRkm1EABklQRAN0PWWCLlEF/O
         Jk8n3M7MAr8odNEyXNMEjk97exvx+xU70PEqjfNYsyN6n3+6GZNSvVCdQAmilx8QPbBm
         OOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FReuv9xFMVyvTNZfWrNQAOSzgNlbJG2Wu8muxrtJB5s=;
        b=WDZqXRrH7SU+c30CdKTZXmgjObiIttZbt8/t+iH0xw5WHIPxS3N5yvaAefmqNJINVV
         oDWuwFWEY9f8uUJCF/4SZAnL2piEFCKgJlCoqb2XB1gTI/fkpeFg0GpyiAPcUgQ7uwJ7
         /t5S1yeWjyvB7x/AZr82ZRwd26/vvmenk2zSuWHZaso+RWN8AA1fIYB+VfWmvIZ/SDJg
         Al1A8ZpkZZCWMf+ScJzNmY5rbBzMBnbJd2oXqM7W+HNosmR+zqQZsIkpOikN3BcIyVXk
         eamdELwK51OFQ5p9/iNnwttB8SOber/poLevIFUz2eehfsP887eOUrU4MNo/NqeMR2oE
         yY/Q==
X-Gm-Message-State: APjAAAXFqFyUE0GGRhFZwvPFmXiY47vNjaOVhMIdeSvOfMAjutBe7UDl
        ZQkgq/qcz5pJ+8tK40d6ug9QUQ==
X-Google-Smtp-Source: APXvYqzO1/s6/joXl2BcoKM7Xnz/sEt4pskNOn2AhVI2yobBPmRt2GyQv7mpgP18WWYGLkGJ3cRMvw==
X-Received: by 2002:a17:906:2ac3:: with SMTP id m3mr5753894eje.212.1567037964516;
        Wed, 28 Aug 2019 17:19:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id fk15sm124951ejb.42.2019.08.28.17.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 17:19:24 -0700 (PDT)
Date:   Wed, 28 Aug 2019 17:19:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next v2 0/8] Mellanox, mlx5 updates
 2019-08-22
Message-ID: <20190828171903.03cb0452@cakuba.netronome.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 18:57:39 +0000, Saeed Mahameed wrote:
> This series provides some misc updates to mlx5 driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> 
> v2: 
>  - Change statistics counter name to dev_internal_queue_oob as
>    suggested by Jakub.
>  - Fixed an issue with IP-in-IP TSO patch, found by regression testing.


Thanks! LGTM now
