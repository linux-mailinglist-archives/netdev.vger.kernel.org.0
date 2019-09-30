Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C64C26E5
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfI3UmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:42:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46877 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbfI3UmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:42:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so7978710pgm.13
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Uu0agYVAKET8nu+P1nIjt8lWXRmOgLvErTQ5yMGA3EE=;
        b=PSfWsginjMxSDqZU4bsJEeFPAALEMWdbdSqj6pCeh/CT+5fWcvIMe9nyA7P47AugFX
         651MPb9cCP2Gvr+T2ShU9AecZijUlrGHRAok9ayQLDVOjX3982D5Tz4EJmOTtHb0Pgzl
         iw/ccdi6DlP/2x5jh8Ku6V7AyBYr7stl/R0EvcT0mkSEmgBZ2DkJby+6AO3zDHnpuKaS
         uyPwe0BZMM/B9v8jW3SAXA8UaWiqLkAtLXpnIUjgfMu0iMOzOXQv05Q2QR9OB2u687WS
         HedEJ1zhcymlwh3S5+hpEDqeNXusQSiH9eXxsdqSb7OC3G0GmiKTppBV/uRdfuC4WGmG
         8xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Uu0agYVAKET8nu+P1nIjt8lWXRmOgLvErTQ5yMGA3EE=;
        b=q3jft27GpKo5CmSTRXchEwsNJtdeeoW83VvuNZX2zsdZIReYcWjvvkV4PUPUTJ1yuG
         0a5H/DJLhdjOQU6xOaUWxaCNSpoMEUJEw+L0h07xcy09TVcLPhfe6mj23chZP8bOt2na
         Q4aWFfHiUEcFtlnuwyygWkOwcgGvKNCwN3mAukpEW40OKD7/lkfvD+rSgLhiGhQl7M6o
         uqkFjLjaXVLVWO9OIkoYmH4Klh9SGE0skxVN5wQttWy8em9SLJfDrvNAtP92PIQu1+Ii
         n2vR/A4kCl8auQTKTorKp66qppkNtwPvQEOZqW5o5l/0hsDcZrHzCzlCgY4WNF+Ot+js
         gtJw==
X-Gm-Message-State: APjAAAX2NA8AtSSSdabdkNUjOcaRRPPwfSoBy2UP40JH0ghgbh2VEHLB
        htdp00HljtId+IFBhi6jwCGe1TxgjJdfUA==
X-Google-Smtp-Source: APXvYqyFLRkxX0OqLFK0sQLnvzhI8JaRC2m5GP3Y2Y2onLl0OGRnyhhqOI/APyaIJBxdb63LPr/awA==
X-Received: by 2002:a63:5c26:: with SMTP id q38mr18359814pgb.63.1569876142343;
        Mon, 30 Sep 2019 13:42:22 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id a8sm15423874pfa.182.2019.09.30.13.42.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 13:42:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] ionic: simplify returns in devlink info
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190930180158.36101-1-snelson@pensando.io>
 <20190930.133355.1745119367909644800.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3511be4d-2af1-e26b-2de2-9b6bc8fcbd0e@pensando.io>
Date:   Mon, 30 Sep 2019 13:42:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190930.133355.1745119367909644800.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/19 1:33 PM, David Miller wrote:
> You must always submit a patch series with a proper "[PATCH net-next
> 0/5]" header posting, explaining what the series is doing at a high
> level, how it is doing it, and why it is doing it this way.
>
> Please resubmit this series properly.
>
> Thank you.

Yep, sorry, will report.
sln

