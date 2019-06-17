Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C4F489AD
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFQRIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:08:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41985 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfFQRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:08:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so11578375qtk.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aZJF2WxJETDdDqs4xOl7auM1FXoTrxtt57vRxOFFuJc=;
        b=pvJO5JBbyAeFlkroQzOmvl4fi0RWwK+6jp121t7h8ADHYgEZh4DEL2J0Uyy+dkifJo
         i8k9YbtiVWRZAJJiQdxcPorAsZBbMkpNeqfR1z1T3fyT7tO5Y5V1tgZfQb1itQmNPIij
         PQCiT+jAX34BpMNlFlkY1fdAPgxHzcdWn7XBt2msWYHZo4nKZ/DPNdyaT4Nsq0svbBCw
         NMMfVmeE/SdihwEIB0WRTRzH1M5gNZbwCm9szNs3FcXziSG2kPWKeFbKIlF50e/06Cal
         ZtOuXsiHD9esueLXF7GvHUqVAfhcLNiYfu5D/tENDnEUcjsRJ6ENQxmiQnWMYtCz3Smq
         BmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aZJF2WxJETDdDqs4xOl7auM1FXoTrxtt57vRxOFFuJc=;
        b=JxEaApmwM+OdM5TbvGWgLt9L8mX3tXDc66AVg0bhVTcv+vpdhmQnB+N6g9DRmrx4Wz
         SaDrC0578CtwPvS12L5Q6zGTAPyQKXeY5kgPkmM/5wezxwRMcvO63lsu57Adz9yweLBJ
         A2VNfN7gcJRsL+SnpV35huIwl6kOLu7VLWmIvvoOzLfsZAaedClDfOeESOIDROS6tEce
         5qezX5YGQtw54QuNHtfDZSIxDMjlRxLgkdnXBp4yQZcm0maEcx2NSqLyM9RuK2kLXDXV
         OWJgiBWqBLYNMUTPSBWcC5Muq4PT5eWFasnDvnayiuG6xAwi6tof1kZspp0M3NdQHww5
         z4Vg==
X-Gm-Message-State: APjAAAVLzzwVPh3NVauCoBPjDE/THo91crSLiMTvPLKEOaZYXjIkwYTz
        wuMhgKCZy22gitB77CvH/wNPJ6s=
X-Google-Smtp-Source: APXvYqzVfBVz/mz45elzIJPVFZ2VPAupQwWHDU6KMCDMUtQeC6KcPUiQVfjcRvKpcWj3g0hR/Ii4uQ==
X-Received: by 2002:ac8:c45:: with SMTP id l5mr78620764qti.63.1560791294629;
        Mon, 17 Jun 2019 10:08:14 -0700 (PDT)
Received: from ubuntu ([104.238.32.106])
        by smtp.gmail.com with ESMTPSA id q29sm6788314qkq.77.2019.06.17.10.08.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Jun 2019 10:08:13 -0700 (PDT)
Date:   Mon, 17 Jun 2019 13:08:05 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next v3] ipv4: Support multipath hashing on inner IP
 pkts for GRE tunnel
Message-ID: <20190617170805.GA5736@ubuntu>
References: <20190613183858.9892-1-ssuryaextr@gmail.com>
 <20190617143932.GA9828@splinter>
 <e56ca29f-8d80-b9ae-112a-4ff55847313d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56ca29f-8d80-b9ae-112a-4ff55847313d@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 09:53:06AM -0600, David Ahern wrote:
> On 6/17/19 8:39 AM, Ido Schimmel wrote:
> > 
> > Do you plan to add IPv6 support? Would be good to have the same features
> > in both stacks.
> 
> we really should be mandating equal support for all new changes like this.
> 
I will add that.
> > 
> > Also, we have tests for these sysctls under
> > tools/testing/selftests/net/forwarding/router_multipath.sh
> > 
> > Can you add a test for this change as well? You'll probably need to
> > create a new file given the topology created by router_multipath.sh does
> > not include tunnels.

I never looked at the selftests scripts, but will attempt.

Stephen.
