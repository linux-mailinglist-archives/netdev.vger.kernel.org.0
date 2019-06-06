Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABFA36E20
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfFFIHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:07:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39177 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfFFIHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 04:07:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so1356651wrt.6
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 01:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nkM06bDq133bwOp9A4NzeljCR7oDWwRewDKExI0j82s=;
        b=DrcmuchCI1XgD1jDPXnIq0VHkZZsN6NYgAUEdxYPymrQFl8+n/lT7MXoEwddwmNmh9
         hwxdq69UksSDkK7KeASWRjhFxah+BcTLh319erzH8CSLkk5LCJzZlSSWAxOpb1dGoBlR
         LCtNEFX0AZY1ivS3FkWg8w1xtu478xdsmFRZfRNR1NKZQW7AFUuOt0hvckUYYPsk9/u+
         pNvtksgBlXyeh6f97lWU7wIzDBJapIQTk9RRrgIQ0MqTUl0H2J+/H2OGANc1Hzd+sdOt
         weoLhTN9ULQ8itgiZmdY1Zm7RSMMIk83aV+PJpXswbix7g2HpyU9148sScoB6GC4DM7Y
         j5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nkM06bDq133bwOp9A4NzeljCR7oDWwRewDKExI0j82s=;
        b=ub6rjALNaWgGspXbXVIjZ+cukmaVSNDf/QXzRte4uMJ4dyhIuDvAFilnscpdtWaiPr
         YEA1AHRCJ1wdsJhgwhzcHUdNdo7p+PukjshsCm2ad0ZkWxWgNgWTWW0q9F2D2dAMSydI
         +xWbbxgO+C48sSw87oPTHjGEvFMePKw3wZm031YjuChygLvcGwswnvlOSd14/bZCp4PY
         s8F+b7GLJLbw/wUnrUhBziNUBeg8UC++Go2Ezvr8ruE9CAdqn4GHgbhk1pod3pZ97ymG
         VASwtNQRT5snsMpb01W4EwFLdENTpuZuUYjrgHNyzv9O1EytiRSQnAnXplP+paa8nxt4
         oPCQ==
X-Gm-Message-State: APjAAAW28O/OjDxa59nRFRaMHppBpgndcuABYYpvv0/opdZKtqZA5kw2
        M63RMruopo7E8Ccq0HfGK+I=
X-Google-Smtp-Source: APXvYqyBbqo3+jHfARUbjmfCC881rk5PESFX546yA1rKgAXWLHN98nRJsshINov0cQKPIfrtKaXrUA==
X-Received: by 2002:adf:fdc2:: with SMTP id i2mr11454538wrs.146.1559808420915;
        Thu, 06 Jun 2019 01:07:00 -0700 (PDT)
Received: from zhanggen-UX430UQ ([108.61.173.19])
        by smtp.gmail.com with ESMTPSA id d17sm1110956wrx.9.2019.06.06.01.06.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 01:07:00 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:06:54 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Marcus Meissner <meissner@suse.de>
Cc:     wmealing@redhat.com, netdev@vger.kernel.org
Subject: Re: likely invalid CVE assignment for commit
 95baa60a0da80a0143e3ddd4d3725758b4513825
Message-ID: <20190606080654.GA8119@zhanggen-UX430UQ>
References: <20190605092029.GB19508@suse.de>
 <20190606075507.GA32166@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606075507.GA32166@suse.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 09:55:07AM +0200, Marcus Meissner wrote:
> Hi,
> 
> Dave does not like private-only emails, so again for netdev list:
> 
> On Wed, Jun 05, 2019 at 11:20:29AM +0200, Marcus Meissner wrote:
> > Hi Gen Zhang,
> > 
> > looking at https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=95baa60a0da80a0143e3ddd4d3725758b4513825
> > 
> > 	ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()
> > 	In function ip6_ra_control(), the pointer new_ra is allocated a memory
> > 	space via kmalloc(). And it is used in the following codes. However,
> > 	when there is a memory allocation error, kmalloc() fails. Thus null
> > 	pointer dereference may happen. And it will cause the kernel to crash.
> > 	Therefore, we should check the return value and handle the error.
> > 
> > There seems to be no case in current GIT where new_ra is being dereferenced even if it
> > is NULL (kfree(NULL) will work fine).
> > 
> > Was this just an assumption based on insufficient code review, or was there a real
> > crash observed and how?
> 
> The reporter had replied privately that he was only doing a code audit.
Thanks again for your concerns of this patch.

It is not exactly that. This comes from a static analysis research 
prototype. And I think it is different from 'only doing code audit'.

Thanks
Gen
> 
> We (Redhat and SUSE) wonder if this fix is needed at all.
> 
> Ciao, Marcus
