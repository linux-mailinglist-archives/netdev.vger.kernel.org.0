Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E130729D44E
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgJ1VvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgJ1VvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:51:09 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104D7C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:51:09 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id h21so1083303iob.10
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gwnayf2MecvT+5s8JJfNOkhG8pZYF6/aAm6DfyGpa0A=;
        b=WRdCdJCaebH5bgPaIQhOnD53UOJdg70cdtkXZGfIXymymGkUFWXOhcyMvlrv8gk3QH
         XJPrkmgU2fG6GpqJb3EL9lEvK3pJl/M7BaZQspMZ5DvCKKT1FEpn0ypiz4vfCIWHlrMc
         4qXIchkWd86YiODOrIRH4OuRDyb2ZVF3rqW18Gnmishi4EBEHKGqhIVozpl7EUuEGrey
         DPlRlB9bPRlulrnKtTJbb4qTQ9aj9pU1KFYVlYpSuQSjA20bk8jmI6tVCiRIn1hg5ohm
         kIsQmUsQ5lLucng7Hw46mPqaYkDLpMUnX7+rDp4DLgFySQI8sJUHXO8lvMumk0DGCp7G
         c4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gwnayf2MecvT+5s8JJfNOkhG8pZYF6/aAm6DfyGpa0A=;
        b=X22NsyB0V1HhJzO69ktjYjkkYqEBRuOSVQ4ChFadQSX2McLuTQ0Ys13+kJsh5W4kIf
         wBL2EQZrUIEIkontXu/LgApWzl1sAG0KbM/Ls6uYiPwaTseZ8oJJNfGzJnNPG43MM7sf
         YUQwGTTb5qJ8/R21PHd7zl7wo7aQzVaNqbzUtfWy2dRm2J6lFt+QfA+k2U1YcOHQ6Sg6
         Rx3Cki3QQ4DQ8Ub2QoMyxHNpaxfiQQyfAMJ/1qK3qc7aB4oIZZw/bQVLOGbT1AYWJOF5
         ytOSVRZ1jEa4wjC77da03igZghoJOdA/vuAKJoQLeFYVyTxlypuIHMOF9YIK08wJvIO/
         U2nA==
X-Gm-Message-State: AOAM531WaLgEsuTVvBMt+lXV9+LbNvviFQ6aUszFQbugj/oTyzFrsuQC
        dtvTCS9uRz672w6zqpaTtKaoj64NsHC3bfQn
X-Google-Smtp-Source: ABdhPJx7+AEZUMe/EsIWyfYB5EYL402/n/2TUFC/pw6DyMAI8l7Fu1l1s7kGjxT1nPAj+GaH11JRIg==
X-Received: by 2002:a63:7408:: with SMTP id p8mr414749pgc.273.1603906958000;
        Wed, 28 Oct 2020 10:42:38 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id ng7sm47242pjb.14.2020.10.28.10.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 10:42:37 -0700 (PDT)
Subject: Re: WARNING in xfrm_alloc_compat
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        syzbot <syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000021315205b29353aa@google.com>
 <20201028104509.GB8805@gauss3.secunet.de>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <86a1f30b-388f-6760-b59b-349d2d8b0d8c@arista.com>
Date:   Wed, 28 Oct 2020 17:42:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201028104509.GB8805@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 10:45 AM, Steffen Klassert wrote:
> Same here, Dmitry please look into it.

Looking on both, thanks!

> I guess we can just remove the WARN_ON() that
> triggeres here.
Thanks,
          Dmitry
