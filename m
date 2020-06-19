Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61615200C7A
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbgFSOqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388817AbgFSOqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:46:13 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27CEC0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:46:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so4561940pge.12
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=A0SEVOpcHsuNLyVpfZPRTNP6bN8WLwpJrFGg1Si+7zc=;
        b=hDYBK+hJsTswP+AygfR6OvIsJOwgnE+LcdcWgjBF9CzDe3hFVVAtCDCkErHcOiADYL
         AHu0OWSQR8kChAvNiBY0zFmcKPIDpNw4bn8z4xV9Fja3qdadw3vXaDE4k+fFTfPuwIDL
         dc9/jnOjBWaO1NYjOVvnGoiFtsBBYd5PDo4iHwPOiq5+w2LaFwN9J9JY2m4EbAY27dxa
         DpJq0oSQ9WmOuoRbUYUEg13RJQpt0EspYcWir8FdwXaa9gcMZqa953V81eaYSt8QBijH
         48ezNOcuapVYBaz5Bm/dAlEFskuIL51gNsqEcurnIag8R+ICKObpVkV/atNqiGY/+BP8
         DxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=A0SEVOpcHsuNLyVpfZPRTNP6bN8WLwpJrFGg1Si+7zc=;
        b=KWFCkIow0dZq4kz1BfS1yo5/H2G+90DTXftNEIl4Sp/GNacGXa+WJn3hCI45/p2Tl3
         GBYZoNHb5HCwnB3cZ+bJHWJJnxFhRRMRa+VF7wg95FuPixQrqyaLLkfmyZBvS79SUgiX
         xse0TdqSBsd+WJbtWVytKAJzdzdxfVm1yMu8ZswHzvSE5BCErXpjhgfnQAVodjCBDEXz
         XPLHwM5QiMPBlblcZ/7ESoyyftRBv7A4UEPHgwDQNHCHnAzZn7atiysPSkP8IcXiZjCo
         0DdJx9fIW3qMhZetxBi8UWifY+7anArjogsr//PZusGVQqAGFVxDAXnzmJg5PUdcNCyl
         mHTQ==
X-Gm-Message-State: AOAM531+/FK1ToNsgkFkh23POjHyV13k0fsnj893tvQFu/SjAoz2EYAm
        Fi8fRZCT0QCEB0X1ehjewf9+
X-Google-Smtp-Source: ABdhPJzVlezxuG+CQ9cITtvILzSkjISRO1w39LFc9MyW0u6lJuN2Z7NwBMQ3JY/UrrlMKImkm/3V2w==
X-Received: by 2002:a62:1c5:: with SMTP id 188mr8395366pfb.213.1592577973213;
        Fri, 19 Jun 2020 07:46:13 -0700 (PDT)
Received: from ?IPv6:2409:4072:6e9c:5ed9:4574:ef47:f924:dba6? ([2409:4072:6e9c:5ed9:4574:ef47:f924:dba6])
        by smtp.gmail.com with ESMTPSA id w17sm6742233pff.27.2020.06.19.07.46.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:46:12 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:16:03 +0530
User-Agent: K-9 Mail for Android
In-Reply-To: <20200616184805.k7eowfhdevasqite@e107158-lin.cambridge.arm.com>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org> <20200213091427.13435-2-manivannan.sadhasivam@linaro.org> <20200616184805.k7eowfhdevasqite@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] net: qrtr: Migrate nameservice to kernel from userspace
To:     Qais Yousef <qais.yousef@arm.com>
CC:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Message-ID: <9184F012-1FDC-4F6B-8B3E-5D2B87F5DACA@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=20

On 17 June 2020 12:18:06 AM IST, Qais Yousef <qais=2Eyousef@arm=2Ecom> wro=
te:
>Hi Manivannan, David
>
>On 02/13/20 14:44, Manivannan Sadhasivam wrote:
>
>[=2E=2E=2E]
>
>> +	trace_printk("advertising new server [%d:%x]@[%d:%d]\n",
>> +		     srv->service, srv->instance, srv->node, srv->port);
>
>I can't tell exactly from the discussion whether this is the version
>that got
>merged into 5=2E7 or not, but it does match the commit message=2E
>

This got merged and there was a follow up patch to replace trace_printk() =
with tracepoints got merged as well=2E=20

Thanks,=20
Mani

>This patch introduces several trace_printk() which AFAIK is intended
>for
>debugging only and shouldn't make it into mainline kernels=2E
>
>It causes this big message to be printed to the log too
>
>[    0=2E000000]
>**********************************************************
>[    0=2E000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE =
=20
>**
>[    0=2E000000] **                                                    =
=20
>**
>[    0=2E000000] ** trace_printk() being used=2E Allocating extra memory=
=2E=20
>**
>[    0=2E000000] **                                                    =
=20
>**
>[    0=2E000000] ** This means that this is a DEBUG kernel and it is   =
=20
>**
>[    0=2E000000] ** unsafe for production use=2E                         =
=20
>**
>[    0=2E000000] **                                                    =
=20
>**
>[    0=2E000000] ** If you see this message and you are not debugging  =
=20
>**
>[    0=2E000000] ** the kernel, report this immediately to your vendor!=
=20
>**
>[    0=2E000000] **                                                    =
=20
>**
>[    0=2E000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE =
=20
>**
>[    0=2E000000]
>**********************************************************
>
>Shouldn't this be replaced with one of pr_*() variants instead?
>
>Thanks
>
>--
>Qais Yousef

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
