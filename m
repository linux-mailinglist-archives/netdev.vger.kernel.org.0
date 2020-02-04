Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F65A1518CB
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgBDK1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:27:04 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33307 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgBDK1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:27:04 -0500
Received: by mail-yw1-f66.google.com with SMTP id 192so17125007ywy.0;
        Tue, 04 Feb 2020 02:27:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iiOblPPXkUap1hSjW+vVczvgK9orjq02UMpan/2cwmk=;
        b=bVbwTQXY0FYG0Ho+ddAImk73DbHsaJ42N2TZy+H7+3UGdkVSnZYKT7YavzkYYekRdq
         Yo5P18x3UvZR3w76MTAzv5cG1W8/nUsjLGe6OdSk5h+H4PTN+3JkQDoSXiipeX3q2vsH
         4hhHAJlxpdZ4GnjnC1DqYLECZRRg9NHQZpNhRjnf2qQzikv/T6+/+HSkqZvqFCt6QSmA
         YAXPs6H3ZTOFtlLR309hCq+JhniXHgcZjspFG5TgecpvZ3vBjt53Waf8Xa6VYdR6nfLV
         j3zlLFHt+kbZa+YLjhwW/smmBiN+EKI30UgLAajfW5G+M9QHE1hEDngmTLh+4HVog5qI
         9TXg==
X-Gm-Message-State: APjAAAU3i8V1TxLRIjpTuTjGu232lJjScVVCNWQ2XtCNjjwGaxTLRmWf
        6YAGd0khS1iRqECdT/Hv3h1R7Xb9jsnhfAdaB44=
X-Google-Smtp-Source: APXvYqwsBojweVPH1NIKFh79Z2yMuoe7rLawOuZXEiFEqjUOqC8YxjLGonbjUqh45rVQ9y4gNorrHBcyRwcipvYCRoU=
X-Received: by 2002:a25:8587:: with SMTP id x7mr23609359ybk.325.1580812022096;
 Tue, 04 Feb 2020 02:27:02 -0800 (PST)
MIME-Version: 1.0
References: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
 <1580735882-7429-3-git-send-email-harini.katakam@xilinx.com>
 <20200204.103749.1474392609351299440.davem@davemloft.net> <BN7PR02MB51215810D1240E98E81F6176C9030@BN7PR02MB5121.namprd02.prod.outlook.com>
In-Reply-To: <BN7PR02MB51215810D1240E98E81F6176C9030@BN7PR02MB5121.namprd02.prod.outlook.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 4 Feb 2020 15:56:51 +0530
Message-ID: <CAFcVECKXoG5Cdi2Ef2D13zj7afx4ZVVyTRRm0H84dzEAYFvHnA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: macb: Limit maximum GEM TX length in TSO
To:     David Miller <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Harini Katakam <harinikatakamlinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

<snip>
> > > v2:
> > > Use 0x3FC0 by default
> >
> > You should add a comment above the definition which explains how this value
> > was derived.  It looks magic currently.

I'll add a comment. The value was specified in the errata document that Cadence
provided to us.

Regards,
Harini
