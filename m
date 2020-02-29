Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F911174596
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 08:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgB2H6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 02:58:07 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56236 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2H6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 02:58:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so5834621wmj.5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 23:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HzZ2Y2pm5PAEWlftw4cbKa1B9fAVv3XxEB+sUScIyQU=;
        b=J3ec1D4Dh8s6WwTbDVxjMrCpttT5gcDb3AczxjNcLjyB9nYLFgNxRSbLCyp7NC+SjS
         Re0J2C5+rDaGle4epklzU3BO4vYfpEDUrpjIGanDswHVIs9kgtnUGq8R8mOqAuEVqkm0
         lsycoNh/ZZNxuiBFI2efrld0DNnWfoH6UZ/3Zhj5bls8twEDV7IpiWm/j7Snj0enPERg
         b1eBAtZYQU+33zY4Umm0rXEZAJqUS4XVvuk4362r+EMDJaKyJmSwj1IHZfh4nEI9HYEh
         1fDcuR3tOk57vgrrs9AGZM6tlsGH7VCOuubGQtBtZFOwFYn0fF/lqBIXuE7F1OlivcxA
         t+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HzZ2Y2pm5PAEWlftw4cbKa1B9fAVv3XxEB+sUScIyQU=;
        b=P+yKRwBpJ6p7e2FMAbl7IndxLZEPL32vX/h2PSaFSo4WmOSXy5MZjLob2IOpTWOGO6
         aOfG6cwV19ascH0dSAWPLPXL/L3S70A6XmIVX8ccemNwJ31WdO2vgLo/rX6+BM0Qoopj
         5Z4eiz1bzPoGb99NR8I7u1zPRQF9CJnpONb25sARkUJDYuPpeookRcxR66u0vQ26lHrV
         4SZwq1/VqMNtHSVKRdvmPRJumXtIvc1M2l4Nat19QYXxCV+o2HAVq1DeoPgFKIOtvKAc
         FXszEzwFeI2juTuZ1Ko6K2TD3uSpaHPTHxhKRFagyvJSs7PJ4RfV8YW/qRuc9f0z/rgt
         xSIg==
X-Gm-Message-State: APjAAAWedObQPj575CHvzJdC0EUqZaPkT/w2KGXlLKqLJ6sQsieljPPu
        ucZsrItbiywZDFQWXR+dF7sNyQ==
X-Google-Smtp-Source: APXvYqzqdPE6cWTVf4TU7uVvi13E2ChyBt2wLYWvgsiLNwFlXpUu+4JQlLjblRNYhJe6noEjSQH/ZQ==
X-Received: by 2002:a1c:df45:: with SMTP id w66mr8863382wmg.171.1582963085760;
        Fri, 28 Feb 2020 23:58:05 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id o15sm16577930wra.83.2020.02.28.23.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 23:58:04 -0800 (PST)
Date:   Sat, 29 Feb 2020 08:58:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 2/3] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200229075802.GO26061@nanopsycho>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-3-vadym.kochan@plvision.eu>
 <20200227110507.GE26061@nanopsycho>
 <20200228165429.GB8409@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228165429.GB8409@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 28, 2020 at 05:54:32PM CET, vadym.kochan@plvision.eu wrote:
>Hi Jiri,
>
>On Thu, Feb 27, 2020 at 12:05:07PM +0100, Jiri Pirko wrote:
>> Tue, Feb 25, 2020 at 05:30:55PM CET, vadym.kochan@plvision.eu wrote:
>> >Add PCI interface driver for Prestera Switch ASICs family devices, which
>> >provides:
>> >
>
>[SNIP]
>
>> >+
>> >+module_init(mvsw_pr_pci_init);
>> >+module_exit(mvsw_pr_pci_exit);
>> >+
>> >+MODULE_AUTHOR("Marvell Semi.");
>> 
>> Again, wrong author.
>> 
>
>PLVision developing the driver for Marvell and upstreaming it on behalf
>of Marvell. This is a long term cooperation that aim to expose Marvell
>devices to the Linux community.

Okay. If you grep the code, most of the time, the MODULE_AUTHOR is a
person. That was my point:
/*
 * Author(s), use "Name <email>" or just "Name", for multiple
 * authors use multiple MODULE_AUTHOR() statements/lines.
 */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

But I see that for example "Intel" uses the company name too. So I guess
it is fine.


>
>[SNIP]
>
>Regards,
>Vadym Kochan
