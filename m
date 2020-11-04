Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004F22A6CF4
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgKDSi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 13:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgKDSi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 13:38:28 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C8CC0613D3;
        Wed,  4 Nov 2020 10:38:27 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id a10so6294017edt.12;
        Wed, 04 Nov 2020 10:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=30wZSZc9sXl/juZ/56c5P7dnhMVP2TqsMHYf3jvD9fE=;
        b=Ecj3Kk0RD9BJu58osFSsfiQbN5RzQ5JO9uHzcW+g9UcDN9/JZ1wZ2+LN9UC2+jmlmv
         cwJa8lbHRisUUGl5SQP7DTdi5on63TBQC/ZtSeb7T186Cuw0jmjr3NQDxf3+eCvh6m7h
         ttYaJmiJ8+NpWvy6m7LWH+zGXhy8qrw1sQ1mn//Z5Y8G5f4/FgiAaDduCnVWQPthrKdq
         gLFTX87LgRTd23PwZK/Af+yenv3dcxgpI6Qa/1y6pmiovftZkPvGD/IgSV+rSF0kiuTq
         D5jbBIpLZeM4j0V50htKr17VNrygaUm7guwonYN5qgn8raivAD8bpOBQD2nwjswyPKNP
         SX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30wZSZc9sXl/juZ/56c5P7dnhMVP2TqsMHYf3jvD9fE=;
        b=cw/OfzcezCFeozGbYpAuQi6NXyMYpTeng53g5EZEfh+sLGE4cu6BO3e1dLyActS5oT
         LoA6zvArcp6kzQWGcCTTPNPtsYeebLrAl+Q6azUe5xPah7UEIMdUlzU+AMZqLwCzYH4S
         YnEuc6eyJf4K4ZiC8+2K1id3ULOoIxFMCBTRf596CxJ3F7y6gQgKcGrQM8BDMlgj0pR7
         325XkcxPfDCjtM/N3FrWKR55fpZOWpDzjMMywyH0CsoTT8o5B/xBycuc2A2E/72/am65
         qSfJxppe9m9Qugu16u5FZcV5pnF1ZBdmIHrTCl0qyi2T60354Hpjm7mqSFaXkdvoGq8G
         bfCw==
X-Gm-Message-State: AOAM5334dRv4V7lnQQQmekhzkTPsjNA+sczMHGRjISFomuvWP38ouIzA
        qpvqKyWgx4usv/1r/wSuXm4iFOhS5WHixSodbQqe1pSZW1FFw5Si
X-Google-Smtp-Source: ABdhPJw0gkoTswQErn12hKkd7L26k20qxLfkFDDEUmeZSwT0r+lbTZ6PDqOayt4QCcwrHNIdb7m+BsqLxrxc0bq0i+E=
X-Received: by 2002:a50:9e05:: with SMTP id z5mr26201772ede.231.1604515106492;
 Wed, 04 Nov 2020 10:38:26 -0800 (PST)
MIME-Version: 1.0
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com> <20201104140030.6853-10-mika.westerberg@linux.intel.com>
In-Reply-To: <20201104140030.6853-10-mika.westerberg@linux.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Wed, 4 Nov 2020 20:38:10 +0200
Message-ID: <CA+CmpXvcTDXZV=NFXHUL6fhyj+=CMSCoCWkwjNOitwRJAi5C1g@mail.gmail.com>
Subject: Re: [PATCH 09/10] thunderbolt: Add DMA traffic test driver
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 4:00 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> +#define DMA_TEST_DATA_PATTERN          0x0123456789abcdefLL

Have you considered making it configurable? For mem test, for example, there is
a reason to try different patterns. Not sure if it's relevant here.
