Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5878FFB9A
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfKQUcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 15:32:00 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45159 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfKQUcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 15:32:00 -0500
Received: by mail-pf1-f195.google.com with SMTP id z4so9266896pfn.12
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 12:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ARKfXUePaQHOp4hh4U5g/MfFyWslwXHf4qniueoWrLI=;
        b=SMiajKj5MEQRK+bthUAuuUY3C/Uyx7ZNz5a9l6jz6npumH6Y/MdONidGRGsk5BslXQ
         5JvBs+N5KdoX2HpJADIPU64MZWTjwwJX02CAOa71iCBZ8ygCjJ8ofQ07xtNwXojt+YR+
         /oWuRY+DiDLngJo2Lmu0wezQmuED1W0ScMzNUK5nElLtyodPKuidkt3fb9KEgrclkm8F
         G65MrimYDEXt/pUaZcCVEZ1rKMRKQjs+vnC7toadNKObZTL1mhgkNP6e/F6nSaWNzv3e
         C/jYvTLrNpVJSWI12YNFc5IRptiO9qYfqq2CXXQPR74FdP3RaebfImPC9u1XiVp00Fh9
         gWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARKfXUePaQHOp4hh4U5g/MfFyWslwXHf4qniueoWrLI=;
        b=WWkxm1NYf14HMWP+SQQYMrqF4SPjiEspxTf/3NSoAB8Qu1ApJ+cUhLdelKdLmPqZXR
         4rKTdA5Ed7i+SxeSoT2BML3eCC6w0e9A+Dm28DAgCcxvyY1vVjFlDKkRkLnqa2UnoRkM
         MaptuUJ8wLj7d7+tmC4EH5RPFM9IPaN6hKRywinyBUuZs227mRPrrzOjoQvbJRGwwTOc
         KZKFXaVty74M587tv9W3Ka3NWZgmkA2uRGbJ7ZpKVcaar16aYR040feks/IbSfPl8o6y
         EnNV1sezE1mZp9YbnGpuoEiKU+qKD6Dcq42JmQsVYQsFW7BVZamWnSyp1Hw21dE8n53W
         qf7w==
X-Gm-Message-State: APjAAAW8aBMePGD65eqlLQGRpfTpOHJ24BdXcobippZMzaVTPJkpSj6q
        cwEev1TftRJBj2NoAnyiwYIEmg==
X-Google-Smtp-Source: APXvYqyAhxEsQA2ltPpXOYkNvVCJTNr848s0c7zpcMltnaW0UN1J7gLtp/o7yh7Q43zbbedqp6aW7A==
X-Received: by 2002:a62:1c8:: with SMTP id 191mr30455243pfb.152.1574022718413;
        Sun, 17 Nov 2019 12:31:58 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a28sm19215217pfg.51.2019.11.17.12.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 12:31:58 -0800 (PST)
Date:   Sun, 17 Nov 2019 12:31:55 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2 0/2] Updates to tc-ematch.8 man page
Message-ID: <20191117123155.502a46a6@hermes.lan>
In-Reply-To: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
References: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 13:22:34 -0500
Roman Mashak <mrv@mojatatu.com> wrote:

> Update the list of filters using ematch rules, and document canid()
> ematch rule.
> 
> Roman Mashak (2):
>   man: tc-ematch.8: update list of filter using extended matches
>   man: tc-ematch.8: documented canid() ematch rule
> 
>  man/man8/tc-ematch.8 | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 

Applied both, thanks.
