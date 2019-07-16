Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BCD6AD15
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbfGPQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:46:39 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:40631 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbfGPQqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:46:39 -0400
Received: by mail-io1-f54.google.com with SMTP id h6so40986133iom.7
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 09:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5T82iPRznvTOc/C1sV4GNJoZ2kzux3rIh/ljYQvxmhI=;
        b=gS5mWNWnqw1xIlDiur8UKu2bcDTLh1miYwL+S0j4SZD6uT4qzXMj98G9N1lsm1SOoa
         iPMRB6b/ls2TQe+dkf4Z9ffzaRnLWff8DOJy4ZfD5nYR0nhwTkw+gom8DYso0byQFDlF
         bsZ30iUIJs+e9zSfucfZXRKSJdqhP5GHyHBD1G/c2TCz2qSboAatOxBAPnAjUns58xNa
         1aaacyUdfNQMsGqq9/gf3hsU+QUy8wvn2VYJxVWhcrdZxj3Vzfikht/jyX2him/8vfAz
         2Kz4e4EFODzf84g/tpddrf1UMg55Fvq1s5yGqA1CenwYU0pUe9IVJECjZmI59AaxqOVX
         VhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5T82iPRznvTOc/C1sV4GNJoZ2kzux3rIh/ljYQvxmhI=;
        b=l33hY5BZuhhsaj+dhIrmoo8XsBv4f2vy5sDdyGTgr70g7vqDWfYvHEUII+hRdgg+L/
         yNFCdmBgoQVPGdrLmeqreESTreQCS0zm18XAon4T+foD+0mRcVVXRqSe/tGGje8m2q3j
         CI0rjyLfCXrbvpF0tqA+9UAfn3AvIy4IZ0Tzm5lCJh/hbEcisRiuButNNMJsbfB5FdIZ
         Ar+sOFrVItSWFJHAbuUz3UMqpoLxsUuy6pRHLTQTUBVbk6wnPrXgL7JmF++MKuJWus3N
         TIwCdySJYnni2u8Qn0ZcfBhQ+jXCaXyOF03YbeMo343VZLYq2bryOFPTRag6UJePHpVO
         3gDg==
X-Gm-Message-State: APjAAAVJqcPnxZoMwxfB3IF3Ibw+tRb6Fb2NpsPPIQdbkdRBvNxbbX/Z
        phd9HXYpprXzFHCOe+tiIvLatCpc
X-Google-Smtp-Source: APXvYqxHic8OMsYjjiSdP3CXX3tuqCIrEBjjxnBhMDYBPe1RKLA2mfhCVp9aX6XisBEielYxp7yqaA==
X-Received: by 2002:a02:aa1d:: with SMTP id r29mr10053904jam.127.1563295597717;
        Tue, 16 Jul 2019 09:46:37 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:b953:be69:d590:e93f? ([2601:282:800:fd80:b953:be69:d590:e93f])
        by smtp.googlemail.com with ESMTPSA id n21sm15410884ioh.30.2019.07.16.09.46.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 09:46:36 -0700 (PDT)
Subject: Re: IPv6 L2TP issues related to 93531c67
To:     Paul Donohue <linux-kernel@PaulSD.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20190715161827.GB2622@TopQuark.net>
 <d6db74f5-5add-7500-1b7a-fa62302a455f@gmail.com>
 <20190716135646.GE2622@TopQuark.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <18b3d951-e1c2-d740-89cf-ee5f7f0ee504@gmail.com>
Date:   Tue, 16 Jul 2019 10:46:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190716135646.GE2622@TopQuark.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 7:56 AM, Paul Donohue wrote:
> After establishing an IPsec tunnel to carry the L2TP traffic, the first L2TP packet through the IPsec tunnel permanently breaks the associated L2TP tunnel.  Tearing down the IPsec tunnel does not restore functionality of the L2TP tunnel - I have to tear down and re-create the L2TP tunnel before it will work again.  In my real-world use case, I have two L2TP tunnels running over the same IPsec tunnel, and the first L2TP tunnel to send a packet after IPsec is established gets permanently broken, while the other L2TP tunnel works fine.
> 
> I've attached a modified version of the script which demonstrates this issue.

Thanks. I will take a look at get back to you.
