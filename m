Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4E1073FC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKVOTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 09:19:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33858 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVOTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 09:19:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so204614ljc.1;
        Fri, 22 Nov 2019 06:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZdfqT5USip205fqNg13nNjS/xx7aXV4fOlmEFVcEaEk=;
        b=Tbz8PVFmGZyBp/1fnrRdM0A+GxLnXx4D7kEx+1K2H/uqvWGmqsvYPlGFTD49YjoNif
         BUNOv94klTia19XnOLt4NeiE/xJbEdlOx/WMW7w9Qi9elV6Lv/neFKP4oLMPuyeSvPVI
         VY7Fm4LGd5Z/ripfUPlAyG6QyfGVVTltM+NMe/gtO/D6guaQ7n4ke1sYg882UCj3gaI9
         kCdmMW9i1GQspLOjbxjZXDOVp9Me1phIXoHZKGk0yfcwGyizcjDcEdDxRM9lnXQRxm2e
         AbJsEIAQDXiv1YxmN8kJUFJ+72eGiht3dAIB+SWvI1sbgIaT2wVXysT4w6ZpJ1SZfC+s
         d2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZdfqT5USip205fqNg13nNjS/xx7aXV4fOlmEFVcEaEk=;
        b=TVU/uvHCZC95NbdPIkeYJsDcvo8dMi4qFsN+zO8qf+L6qiDl4w490VxspCARpIezig
         SYSAR09UXiAoVHd06oiM5i2Sx1VHDqzNS+i1EA3FzFvUWcedCa0I/BnIrQUoTzqAJpLr
         4SaC2cVnwg/GN9DaJia2KQtp8SBddfBDiC9LM46/J1BzAiwEniz4eiLu4Oi88fqJxPqM
         KDTCj3JhbGuUtsHnA3OcYnCSQf5UEaUIYyAuMCgYy975wDr7nen1v99QXLfNeg26BTGt
         INyicYYfAd3sCk7TJrujVymIQ56qaws01iO0SmCuEAlewt8I/JSMCzbaTDoDt5JBdmdu
         gDLw==
X-Gm-Message-State: APjAAAX0g1XO/BEa/4MtKSvXdT0ciBCd/sZyg9lCZc0TTUSBOQ7C+aMq
        EHmJzy4CxKIZw4kSKr2yjePnh5n+vj0rxbf9fTS95/LtinI=
X-Google-Smtp-Source: APXvYqwEBn5Un/3sIp9IZnPIh+d4sPKGu2MGBq26LuVDvj2FUlvkyv72tBoa1muaAjHz1ClrKSL4ybx0EQ6qsPeN4WQ=
X-Received: by 2002:a2e:9606:: with SMTP id v6mr708384ljh.223.1574432367277;
 Fri, 22 Nov 2019 06:19:27 -0800 (PST)
MIME-Version: 1.0
References: <20191108152013.13418-1-ramonreisfontes@gmail.com>
 <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
 <CAK8U23amVqf-6YoiPoyk5_za3dhVb4FJmBDvmA2xv2sD43DhQA@mail.gmail.com> <7d43bbc0dfeb040d3e0468155858c4cbe50c0de2.camel@sipsolutions.net>
In-Reply-To: <7d43bbc0dfeb040d3e0468155858c4cbe50c0de2.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Fri, 22 Nov 2019 11:19:15 -0300
Message-ID: <CAK8U23aL7UDgko4Z2EkQ9r4muBTjNOCq-Erb9h2TFRnxdOmtWg@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: set the maximum EIRP output power for 5GHz
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Right, so the commit log should say that it should be incremented to
> allow regdb to work, rather than worry about ETSI specifics?
>
> Or maybe this limit should just be removed entirely?

Hmm.. not sure. Perhaps we should add only one more information:

ETSI has been set the maximum EIRP output power to 36 dBm (4000 mW)
Source: https://www.etsi.org/deliver/etsi_en/302500_302599/302502/01.02.01_60/en_302502v010201p.pdf

+ The new maximum EIRP output power also allows regdb to work
correctly when txpower is greater than 20 dBm.

Since there is no standard defining greater txpower, in my opinion we
should keep the maximum value. What do you think?

Do I need to submit a new patch?
