Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCAB24C82E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgHTXEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgHTXEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:04:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14777C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:04:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id jp10so185562ejb.0
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZWv2ef7k6xicYFBhBhq2LBPGpnpS+s63cN2mBjpjiNI=;
        b=eWzgmX2pvNKcWGJNRlN9TTF2LD3P6dAFgtc+BZueth53GuZOnwIkZ0BXcWxInA0+33
         jqHD5JOLil6MuTemkZY/f4QJJC5SNBZSPIBn6uKLZ4f2OYsriVSfQGixKbALK8XxejBQ
         p2teZtf/U7HBiYDZQDAVdpS0TfEgO8z5pM4Sf0NfmKmVryOx5iJ43bpDWJztdkXY3gtf
         +xxlSTFnKu9fsU7GPdxxkPAaimvZwAGlB1zX6HLXgeAmi53pFVb2ZbhsTj/NkT4Iqf3t
         OzO4Ze+nHyyd7cNGUc3v2iRCIO6abgppWzurw4Huw3YcD1HJfBM1cwheyXHx6eSvNtj4
         jFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZWv2ef7k6xicYFBhBhq2LBPGpnpS+s63cN2mBjpjiNI=;
        b=qzDfhyy0gQx9dspVUgQBaNxevWLHhTX5Q1irSJAU0LeoBczzEh3nIn5qAzSmkTIhms
         vjMNwSVElUKpsVRjRPFErfoy1f1HSDnqTbTnvJ0FOVwr6W96iAcKDRS9C5QHRpCcQGGl
         SSTEbLEUCsf9z4vqaKsIBd2V6VlZmaQrwfQeyKms/5sRhyVl3zWaekcBtDDeeH0ORCov
         LA5Ka761VNbVWg/08TQo1dV0HH7hVFZ/vOEEjSHLjstWSxhc+2hnCZzQg1D3Wf0xEwOe
         FzWeYS0RfriV5vM/6ZLb5LFRnXMQCzsQr2Tuy4tZHCuRo7gmnEupeH+Nd/DEMEspSiN6
         8ipw==
X-Gm-Message-State: AOAM531uSJTRO1BmgmGswM8VtnK0r5J4V6/SzyTzR1LE5sijMDOuu+TP
        5z3NgKnCGiBbcZfn15+G++E=
X-Google-Smtp-Source: ABdhPJwquHdOCzn7vItb+B51/Xr5+ZfhP9FfslMTeQePNOkNw84moJDnbdrSHBydmbdU7Z3+RVZnAA==
X-Received: by 2002:a17:906:4047:: with SMTP id y7mr177479ejj.21.1597964682549;
        Thu, 20 Aug 2020 16:04:42 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id x21sm2090262edq.84.2020.08.20.16.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 16:04:41 -0700 (PDT)
Date:   Fri, 21 Aug 2020 02:04:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Thompson <dthompson@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com,
        Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20200820230439.5duakpmsg7jysdwq@skbuf>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
 <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 05:30:59PM -0700, Jakub Kicinski wrote:
> On Thu, 30 Jul 2020 18:53:58 -0400 David Thompson wrote:
> > +
> > +	/* Tell networking subsystem to poll GigE driver */
> > +	napi_schedule(&priv->napi);
> 
> _irqoff

Hmm, I wouldn't be so sure about this particular advice. With
PREEMPT_RT, interrupt handlers are force-threaded and run in process
context, therefore with hardirqs enabled. This driver doesn't call
request_irq with IRQF_NO_THREAD, so calling napi_schedule_irqoff would
create a bug that is very, very difficult to find.

Thanks,
-Vladimir
