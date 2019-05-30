Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406F23057D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfE3Xip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:38:45 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:47023 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3Xip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:38:45 -0400
Received: by mail-qt1-f195.google.com with SMTP id z19so9180211qtz.13;
        Thu, 30 May 2019 16:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=5X/584UTOkZIc7AIR0uJonbB6BiCWcvUimDyCNA4RxA=;
        b=JJUssT7nBag72322WE2d0+jNktW5Z+FQwBmCl4HoDm1JG9uVzkXEMXG89Wd5PLuGaS
         +9MYvLz01IcuoF58TR0OKYkHtPAXuMX3R99AQJkh1JYEJXREpCL5nVz4KBUKY32rrD67
         JNwBccELwU4TulM2Q6cl+HW9B8QMGSD+/CMgjik3xUjiJyudNQUAwbpqWXTuxhGCNlxa
         pEdBiJeXeF/F7bmGQ57RacPAUOKsAHq6waFPAcJx+nqY1pdu+sruYH8wNshGgVjb4tsy
         GWf60rBAqDgqCDh1fyoa4m7mNHAz5M8yjg05EjPbYm4xtLroKLHj/A/N2jxCe7wb7Xwb
         U3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=5X/584UTOkZIc7AIR0uJonbB6BiCWcvUimDyCNA4RxA=;
        b=PzDtt39WlmvW11qQFMYiurGfquFnvXdMsvilGzM3j63IZ9Vfx0JBWh6K7nXa69/t1Y
         MBw6UnbsX4HJc5cekn82giRw38YFR0GfXCDectfzLVWez+WIDZIDoS0+tQ3DhYuFNTRP
         Sv4TazNnG0UXgVDhnnOdcqMTfz5Mm0lTToxrqxohs4HAA4wkRhud88CE2xmfjFIDADxV
         c1/mb7jSrFftDGBN9M1rcHhhaDJ3NsXyfPzBi9xLJUiXghIAwT0QggxDoaP++3HS0Xe0
         qL5FSgW8NjXyJkKSQaGiITzN427cTeClYOj+vSYj08dOr7oOvD6G8zf3lhcCeeiNSbCH
         syxw==
X-Gm-Message-State: APjAAAVgFXaHDhSizmijWIQ58utXccljlwP/sK6bCT32pYh89ZKE5f1T
        w91st/TaOv4qsXCalgQFHDQ=
X-Google-Smtp-Source: APXvYqx3NsSP/MEAvJKr3Rb/9fsVU47jHzIC5le4sr44QVPvXFFSfzQmktFjGWg9YUtj2ejNABpqDA==
X-Received: by 2002:ac8:2617:: with SMTP id u23mr5904352qtu.141.1559259524249;
        Thu, 30 May 2019 16:38:44 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t80sm2001750qka.87.2019.05.30.16.38.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 16:38:43 -0700 (PDT)
Date:   Thu, 30 May 2019 19:38:42 -0400
Message-ID: <20190530193842.GB20549@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        linville@redhat.com, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: copy reglen to userspace
In-Reply-To: <20190530.112630.476132829981439143.davem@davemloft.net>
References: <20190529.221744.1136074795446305909.davem@davemloft.net>
 <20190530064848.GA27401@unicorn.suse.cz>
 <20190530082722.GB27401@unicorn.suse.cz>
 <20190530.112630.476132829981439143.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal, David,

On Thu, 30 May 2019 11:26:30 -0700 (PDT), David Miller <davem@davemloft.net> wrote:
> From: Michal Kubecek <mkubecek@suse.cz>
> Date: Thu, 30 May 2019 10:27:22 +0200
> 
> > I believe this should be handled by ethtool_get_regs(), either by
> > returning an error or by only copying data up to original regs.len
> > passed by userspace. The former seems more correct but broken userspace
> > software would suddenly start to fail where it "used to work". The
> > latter would be closer to current behaviour but it would mean that
> > broken userspace software might nerver notice there is something wrong.
> 
> I therefore think we need to meticulously fixup all of these adjustments
> of regs.len before adjusting the copy call here in generic ethtool.

Indeed there are cases where userspace may allocate a smaller buffer
(even though there's no way for the kernel to ensure the size that
was really allocated, but well...).

The kernel must still allocates a buffer of size ops->get_regs_len()
and pass it to the driver. It's OK if the kernel driver messes with
regs->len, since it's an open structure. Software may actually make
use of it. However the kernel must use the original regs->len passed
by userspace (up to ops->get_regs_len()) when copying the data.

I'm sending a new patch right away.


Thanks,
Vivien
