Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFB9284D1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbfEWRWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:22:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38905 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731075AbfEWRWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:22:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id p26so1735464qkj.5
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=orxdKAeTGhuAr1KDO8ykLR98bbgYAJIpSNP1r+lkby0=;
        b=WEs/d6KtWvrlJjFQF/qVdOAuiTFDkVjcMe9Jr+Bo13d3u6b2rKL0IUfVUiLLrTfhu5
         3pfopmvEV7PwRaRpZWsgSHP61NlEllNVYhTHqTI0h1sR6jhAN27mYEg+Iujh2/OyKkCJ
         3IFFohQcNkbMEp3WpVPwXCz1J6/Q8RbYVqszYjaCyrQoU1xTDcj3E8nYF8RpP1sysX8U
         Rt04u++W4dJlHJQMkCLLJKd1nV2RpuHGo+AdMwCgZBLiuXYLv5VAhiBzfDMVVVMnCOZp
         A4DD591zXyIOcUFtUqYb3ni3UsuVcFr/RgXlhUSKW91KF6RkbGf+wWcXWO898sjfkMFS
         i2lA==
X-Gm-Message-State: APjAAAVteVJ1zQHZfR2zDSyMVDS3BQA5xngzT0BNLPAanIZe8bIy6gP9
        G0KlDW/j1UZSDpJLiWZZNk0u3g==
X-Google-Smtp-Source: APXvYqykamv1Wqqs833PdyLZedOafUeo+CHIJkq0yhHSr/u9oMeUTX6fQlKnQFFG/JvpWeUzz3qZdw==
X-Received: by 2002:a05:620a:1084:: with SMTP id g4mr75399078qkk.228.1558632157708;
        Thu, 23 May 2019 10:22:37 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id x30sm18102171qtx.35.2019.05.23.10.22.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 10:22:36 -0700 (PDT)
Date:   Thu, 23 May 2019 13:22:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com
Subject: Re: [PATCH V2 0/4] Prevent vhost kthread from hogging CPU
Message-ID: <20190523132228-mutt-send-email-mst@kernel.org>
References: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
 <20190518.132712.1971625204431294331.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518.132712.1971625204431294331.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 01:27:12PM -0700, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Fri, 17 May 2019 00:29:48 -0400
> 
> > Hi:
> > 
> > This series try to prevent a guest triggerable CPU hogging through
> > vhost kthread. This is done by introducing and checking the weight
> > after each requrest. The patch has been tested with reproducer of
> > vsock and virtio-net. Only compile test is done for vhost-scsi.
> > 
> > Please review.
> > 
> > This addresses CVE-2019-3900.
> > 
> > Changs from V1:
> > - fix user-ater-free in vosck patch
> 
> I am assuming that not only will mst review this, it will also go via
> his tree rather than mine.
> 
> Thanks.

Will do.

