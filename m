Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5E6A425D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 07:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfHaFKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 01:10:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39949 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfHaFKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 01:10:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so4543378pgj.7
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 22:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ReUJTmBeqIj7S70KCNlTQYzqvVnsZSDUqfcL0RX20LU=;
        b=PGdr5vuxrxENXCGSWCG9kxENkL9C6bFVWI1Zutupjw6pDxIj21xfzsmCb1YTPKvS5l
         WSDb1d4A+73QLXOysqoJKUjxQ8BY4NnmVe6vBcD9v+dcpluOtb779/IUL+IwGKT3z0H7
         I2u/6f8+zMewsbRTsevZ7qizJx+k4my2sV5oONhjKCw7yVXexL2FKoYXK27f658gkpAm
         C18L2qWbn52G7qYURw+uXFimaVSsbMyNgjCJBdjgGk8m/jF+8EioqeS0/nKIu0wgemWp
         43uWC0NKshvalyGU8nPOzFdRbuITz+VLlRyq32OV/oJdRi/oFzlUpbRfrnm/uJLgcxsA
         wz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ReUJTmBeqIj7S70KCNlTQYzqvVnsZSDUqfcL0RX20LU=;
        b=cpNCEKTE2kssXmiMhQbOss4ujdI5DDKFz6fdPOPWKrLmhCeTD1lh6yZHh5UJJMFoZi
         Yoy3+At/IgvJdhcaIEpheEX/hMTPw9/MFnBNA8poVEn3D6ha1mbs7FnUdubhvQQzg1mJ
         6YPYwO8XLHmzWgMdOu7E26+gy9cGPDCQIaHe/eUm+m5xARdMWAffqKFYLiSQdGHiRBmv
         +0akcbrDQ0s1It8iJqrslE0V1dywehF7pWJFzvrj5BvguUuQMazWJREvoGarEbwrOlvr
         JP1akhqC/kVRQ7pzqCsjIRAdSEJl62rMdZ1lKaeSlFOPqbmr9+SeORtRr9T9akgffkYX
         7mmw==
X-Gm-Message-State: APjAAAX74jBxJE9eS/BfqQbHf4GLxXonNB20Am6tldm15WhSt+9IkvhV
        l+czWabqYIL/g5RCv53o9hxBUw==
X-Google-Smtp-Source: APXvYqzjdjU9DiC5m9nmUSPHQuN3lKcMiMkeJxBdUllNEO/vTm2lquN418Ek06F9fmBfU8uaAQZpvA==
X-Received: by 2002:a63:ec13:: with SMTP id j19mr15606229pgh.369.1567228243339;
        Fri, 30 Aug 2019 22:10:43 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y128sm6784778pgy.41.2019.08.30.22.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 22:10:43 -0700 (PDT)
Date:   Fri, 30 Aug 2019 22:10:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <mkalderon@marvell.com>, <aelior@marvell.com>
Subject: Re: [PATCH net-next 0/4] qed*: Enhancements.
Message-ID: <20190830221019.0c5fc5f7@cakuba.netronome.com>
In-Reply-To: <20190830074206.8836-1-skalluru@marvell.com>
References: <20190830074206.8836-1-skalluru@marvell.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 00:42:02 -0700, Sudarsana Reddy Kalluru wrote:
> The patch series adds couple of enhancements to qed/qede drivers.
>   - Support for dumping the config id attributes via ethtool -w/W.
>   - Support for dumping the GRC data of required memory regions using
>     ethtool -w/W interfaces.
> 
> Patch (1) adds driver APIs for reading the config id attributes.
> Patch (2) adds ethtool support for dumping the config id attributes.
> Patch (3) adds support for configuring the GRC dump config flags.
> Patch (4) adds ethtool support for dumping the grc dump.

I don't see anything too objectionable here, but without knowing what
GRC stands for etc. examples of what's actually exchanged here, it's
a little hard to judge..
