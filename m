Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD5D0639
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfJIEDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:03:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41248 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIEDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:03:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so702916pfh.8
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 21:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oHQEGD8nDgKnhGDli9YKwCv/KMcRpz9fiI0Kp5fCuIQ=;
        b=qxeeO80X/yXoERoL5rXvT1MmsQgVOPtu0WxNiQ7FLD1CxOTMbfSj0F+iKzpspsD2Hc
         tzCylNaVzUniFY8WKUZjTyLRV2uKW2q1O17YrM1/+CMk6MFGJv3CXzA492cnArOFMjHi
         MNX38V+rFxzpxsDIvzmHtwvqUL4U7FrcM6iH9onHwt3OXjGvRNxRq/k/PD4XVMPrKFKO
         2fFGSVyOWU3nPYJvIEuXd2nhGqQrDk4laZYkPtS5Nz9RecOLL9m8NWEzKclx/lh4GbC3
         ATwYnIbbSaXzMGr4ibUFRfs2os//nqok0HAQn+xo70SZnuKNyOsjzFM06v/sIF62WrVo
         5eZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oHQEGD8nDgKnhGDli9YKwCv/KMcRpz9fiI0Kp5fCuIQ=;
        b=t9eIxGIPiT3X4Q5LdK07/e3DMfAnxzQ/FxOWXv7T+1A/4GC6OhCh++GbPcVjYavfVQ
         /0kikfLT+w6fcyReL37sC/boy6nZxMDlewZSOPXTP48Ilcexd0to9f8txIdZ4HBUT98P
         FuVh/b+2y4U7B0p4uMiUwEtIY9o2BputtklzbBfVOk9NAg4DvGw0rnQDB/vM2vE7cLI5
         gFP9Zpc4F/tAyNF7t4MfZTkKfxoTW7eo36dFI/MtHHTo1l2F905F7fWYW/Xc6mjJo3Uz
         lh0lThTMaJncej9bg7biV7cMUinevVcwNzi5rPYVFymuLJ/+zluEAgON5RN9MPFzDoVM
         x/8Q==
X-Gm-Message-State: APjAAAXMQAbxXk73LlMp009dKjfGFLw0ws1ud9XwVHFg3aZcK7N14nlv
        jmIQ9DxbEaosoJ9wz9HbvMNuAw==
X-Google-Smtp-Source: APXvYqznsfJ1xDF2reCPQGaTkVTrifNnZwoBM4ew8jYwajtmI00tjxNlGZZDYaXNjn+eUh9/tQS6/Q==
X-Received: by 2002:a17:90a:f8f:: with SMTP id 15mr1696944pjz.58.1570593824546;
        Tue, 08 Oct 2019 21:03:44 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id c1sm637687pfb.135.2019.10.08.21.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 21:03:44 -0700 (PDT)
Date:   Tue, 8 Oct 2019 21:03:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] Revert "tun: call dev_get_valid_name() before
 register_netdevice()"
Message-ID: <20191008210332.3d8fcdae@cakuba.netronome.com>
In-Reply-To: <20191008212034.172771-1-edumazet@google.com>
References: <20191008212034.172771-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 14:20:34 -0700, Eric Dumazet wrote:
> This reverts commit 0ad646c81b2182f7fa67ec0c8c825e0ee165696d.
> 
> As noticed by Jakub, this is no longer needed after
> commit 11fc7d5a0a2d ("tun: fix memory leak in error path")
> 
> This no longer exports dev_get_valid_name() for the exclusive
> use of tun driver.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!!
