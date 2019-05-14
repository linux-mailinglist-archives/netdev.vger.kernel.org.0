Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C881CBF8
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfENPed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:34:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40744 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfENPed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:34:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id h11so3248967wmb.5
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 08:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8GrnAA+dMbE3aqWsuexkoodhKBT8YIQCDPCVk4/0ONU=;
        b=mxpDeIqF9oblm7t/CqCQS3iaci+rDNb+fCjWiuicTriIcOZQcPD0IyCrCEqOCeec9t
         cMnKUjJsxqOqDohjMqIMM/uvWQ3egDNb2QWfDs3kLDf51DbqziQeAoTAU9qoKBAMBDVa
         wzrQsBxqj0Y4qdCVtVKSGTJBRN/NEP2GuWYSyKzKn9q041UYj5GpD6ixPsSb8fqEMzTf
         EfbJWrWDy/cfM/b6F5jlIuPLBJT3Bny5MloNQ2fzejPXTtIdAU54UswgLT3dMBbIpUWq
         o/KOqKejJL1i23BN8sEQpV055ZCzoGY8teHTwKl5viCF/bzRr94aWgnMK9vE4fcIxpKQ
         SnKg==
X-Gm-Message-State: APjAAAWvvVa/eMRuBayofH59w6XFhxFq1rf/XVTHjuPb3l2W5nqXK202
        UeOVjB1X/k/SZ5Yv4J+/uTpYRCKYt28=
X-Google-Smtp-Source: APXvYqzOyfjfuVw1aAFsWiF9tA0emSNhG599UJWPqNbEpMVozMuZdTdjulYB4nCzy79n6qV3UvxkPA==
X-Received: by 2002:a1c:9c02:: with SMTP id f2mr6399273wme.8.1557848071813;
        Tue, 14 May 2019 08:34:31 -0700 (PDT)
Received: from linux.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id d72sm1644080wmd.12.2019.05.14.08.34.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 08:34:31 -0700 (PDT)
Date:   Tue, 14 May 2019 17:34:29 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, paulus@samba.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] ppp: deflate: Fix possible crash in deflate_init
Message-ID: <20190514153428.GA11430@linux.home>
References: <20190514074300.42588-1-yuehaibing@huawei.com>
 <20190514145532.21932-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514145532.21932-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 10:55:32PM +0800, YueHaibing wrote:
> If ppp_deflate fails to register in deflate_init,
> module initialization failed out, however
> ppp_deflate_draft may has been regiestred and not
> unregistered before return.
> 
Thanks!

Acked-by: Guillaume Nault <gnault@redhat.com>
