Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18F043D735
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ0XKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhJ0XKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 19:10:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D954DC061570;
        Wed, 27 Oct 2021 16:07:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b12so2315866wrh.4;
        Wed, 27 Oct 2021 16:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=shjT1Lwvq5Pacm8Ep0rHg4FBAZ03jqRawXUWiHiX5AA=;
        b=fX3TS9RxmgUQ4rb9iXoV7Ug8bv7uI+xiX/56cAZSrLThLbRor07/5DAXKpBcxd5eW5
         sKleuKmzJfPck/YSQhn3UxocZE9XeIaOn7pItp6FiR7flTZrwpES+9EkTdgwlc1vOwD6
         Fxg9dcBNdp0VFSqNej8GcfaGUdshcEtoxDMGoXr04rLSpb+DoO0fTx909qgPBoA3jRJn
         2bctUo4wD1iNHhkcW2pStwm7fZ9xrO1oDRj3zitoK2u1hgF2LGL4MKrOMJ1XevG4xzRA
         1LvW1d3Mc3nE3rMt6c2B4EajnGhR14A1P4KV1gY+o1S1ELc8z8u6N5nPI2FW+BRDMk8N
         8o/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=shjT1Lwvq5Pacm8Ep0rHg4FBAZ03jqRawXUWiHiX5AA=;
        b=jSTxhgOhOUmNZbk4tF6eWagRiJ9TjdFGZe+SBJPx0JSSsD9hguoVWeT0IQsdLJvAOH
         4Q5V7ZWdJzbteGMCGyW7rJ3hb2OUmb6D/vQcnBfn0u2maNXCUPDeW7DZeW8IdKj9c5pP
         V8mI8lMcMtKQBeqHIsmHWGxMuAcPWS8CfMIj8TpGY1QusxtXPlkgAilGyFRSISG/Omxi
         2rsewo/QRHaN4fOQwhKcQKHXE8UAVIoblUD/G4pDWCcnTojNhsjQgvgIGM5nvWQ7sXub
         vDQnXBLOmHAyEmUdJ7WAS4KBi8bj9PKg84PpNSufdkWTdG7OkA+CywZWBkiYghA41QJd
         1wQw==
X-Gm-Message-State: AOAM533dEK6LuBPHXJHn7zyqn4IBEsAKzVIrICngoHU+Eg5nkPfIlEQR
        QSsbiOghmOY8by50/wTCK7yStkLzyNU=
X-Google-Smtp-Source: ABdhPJyFdw6CQgcYWV0qqu0K2OrcdZSfy6/iB5er1Di/rP0WkDDwVDItvJTzE2WVQJojzq6z7SG9wQ==
X-Received: by 2002:a5d:4845:: with SMTP id n5mr736144wrs.251.1635376077451;
        Wed, 27 Oct 2021 16:07:57 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id a2sm1208727wru.82.2021.10.27.16.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 16:07:56 -0700 (PDT)
Date:   Thu, 28 Oct 2021 01:07:56 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Slade Watkins <slade@sladewatkins.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: Unsubscription Incident
Message-ID: <YXnbzE9bjVS73g7H@localhost>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <YXcGPLau1zvfTIot@unknown>
 <CA+pv=HPK+7JVM2d=C2B6iBY+joW7T9RWrPGDd-VXm09yaWsQYg@mail.gmail.com>
 <1d5ccba0-d607-aabc-6bd1-0e7c754c8379@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d5ccba0-d607-aabc-6bd1-0e7c754c8379@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 12:29:34PM -0700, Randy Dunlap wrote:
> Then you should try <postmaster@vger.kernel.org> for assistance.

Hm, are you that isn't connected to /dev/null?

Last time I wrote to the postmaster (not about present issue), I
didn't get any response at all.

Thanks,
Richard
