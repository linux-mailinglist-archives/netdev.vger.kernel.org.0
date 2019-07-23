Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C017D71C55
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbfGWP6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:58:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35113 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfGWP6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:58:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so19379393pfn.2;
        Tue, 23 Jul 2019 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tJkZzhNAgl02Ceuay5hJdySVP2Wewpu1vXVlEvr2CZo=;
        b=GyQfNWJjbfZoPciLp6OspCsyAWIR9gBK6nLqU9lixzQKSXHAICkFgdI9yeTD3pXEdB
         MWbaOP9voRxQKprb+s3vFrT2RIZ4HxDavdpr36abtcHXmILHey57Wx5YhSj1nZjxjV2C
         CWPPwzK7OqaiElyEXYVJ9UhHPSPgAKibsrJabSXsrivME3GzTL2sJ3/KLaKvUHuRcKRC
         pGw/r1ezBK92sodSabak2mPW2Aw8uJ90GwBGXPdaoVwvPLCZXp4EwxfIN4JzIRKdLZDm
         8WogXq+yHMUMrFor1KL6RToUUTO+mz95dB16ipBPu9VBmx6uqSHFzVpbrfm15RCdv61D
         wAYQ==
X-Gm-Message-State: APjAAAVj2KCd94CI0y689O4uHQCYbA04M0xtbEoFeYG40k1WhmYbXq9i
        QZPCBrGEoel1eXWcze0UxQBixXh+9vo=
X-Google-Smtp-Source: APXvYqz7i0MQZONSk4vINYCfL9rtvoQ80o+1riCzW1MFUejFNTv8omh44XOg9j/CF0Q6YCWX0VewCA==
X-Received: by 2002:a17:90a:d80b:: with SMTP id a11mr79117802pjv.53.1563897480328;
        Tue, 23 Jul 2019 08:58:00 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f15sm50666084pje.17.2019.07.23.08.57.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 08:57:59 -0700 (PDT)
Subject: Re: [PATCH net 2/2] lib/dim: Fix -Wunused-const-variable warnings
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190723072248.6844-1-leon@kernel.org>
 <20190723072248.6844-3-leon@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <86297343-e539-5d34-239a-4c94769f2379@acm.org>
Date:   Tue, 23 Jul 2019 08:57:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190723072248.6844-3-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 12:22 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> DIM causes to the following warnings during kernel compilation
> which indicates that tx_profile and rx_profile are supposed to
> be declared in *.c and not in *.h files.

Thanks Leon for this fix.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
