Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344C415153E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 06:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgBDFIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 00:08:41 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38780 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBDFIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 00:08:40 -0500
Received: by mail-ed1-f66.google.com with SMTP id p23so18521778edr.5;
        Mon, 03 Feb 2020 21:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=EOehpKBxDkbplUHN6oDL4a2sNVmEAPe8+ZU2b8kq5Yo=;
        b=cb9WOLeP5FuhT+WSH3fZo7yVOwmSEkUU+WUl0U+QAZNVT3Z5XdGG+Bd6i4+15QVQos
         E1lxfeu9mYXTdM8di/7y7IzCkRSwWcbGlmkU5B57vKNY7rYJRdfQTL7jpOxSov1/AzUG
         aUALIieobGYIv0aR/43Y7cOtQo9YNpz419S82WUwc3iavuqjJ1THo6LEDu8TLPxed/tK
         eOvueH10iOAzGT/oRG3xghvhuUk8zxaCcYPv9tODbWbFBSa44My+sCNqOWHfyRtR3n+0
         ynME1U2PkW4lasqOr2twbjtpzw8uCR45YwuGChUtFE2uswwipeaNNByJkdgfur6dITqR
         N9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=EOehpKBxDkbplUHN6oDL4a2sNVmEAPe8+ZU2b8kq5Yo=;
        b=JGPT7yBMNfRTRqUxc/0ezvqp3n8kLV6G0W75zpaDeRrVlY7EpZcU7hveezveYO+HZI
         CkQ6maoIEcMb0C7XmRAWCIn/UjdcEFFKnW4p8bFgE92ZkfqBA7QcqR37q3/soO3ZICf7
         2xydmnl27Md1ehZ8j4Aby032zJ2x7tFpBi7mEhfk4dkc+dTFT8Q4BL+p/rAPzFRGAkQS
         ASgXdrthWEZTpKCi2NUP40h5bjsB7oBZFfrbmgOSrnOVxipFuAcbieR+WwNFpgCfyO/W
         Nz5UJePyPqlVIig+P5fISzXHQynrKsAn46956CvjJitw/1dqeL5LcUa+7MLHzB9DPV7I
         a/Qg==
X-Gm-Message-State: APjAAAUIAoYNAQLF4pTHuJCM8VkNgO4HLSNPT0Nf0BDsV9JOXmHdjaTw
        ftgj3WqqaxgiE0qQtnVI9JQ=
X-Google-Smtp-Source: APXvYqxMOWCMu+l63Kvc5ncOkddOLlTa4A+kMAU7qeSxUkXNiXg8pvV1fEfQ++nMb34HBVbIN0bXLw==
X-Received: by 2002:a17:906:7d6:: with SMTP id m22mr24019635ejc.335.1580792918983;
        Mon, 03 Feb 2020 21:08:38 -0800 (PST)
Received: from felia ([2001:16b8:2daa:dc00:2c0a:8928:125e:2b0f])
        by smtp.gmail.com with ESMTPSA id j17sm1132429ejo.1.2020.02.03.21.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 21:08:38 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Tue, 4 Feb 2020 06:08:37 +0100 (CET)
X-X-Sender: lukas@felia
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
cc:     Joe Perches <joe@perches.com>, Jakub Kicinski <kuba@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
In-Reply-To: <CAHp75VdaaOW0ktt4eo4NsLFu2QT1K1mHK8DZeycOPhbvcMq4wQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2002040550540.3062@felia>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com> <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net> <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com> <ce81e9b1ac6ede9f7a16823175192ef69613ec07.camel@perches.com>
 <CAHp75VdaaOW0ktt4eo4NsLFu2QT1K1mHK8DZeycOPhbvcMq4wQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, 3 Feb 2020, Andy Shevchenko wrote:

> On Mon, Feb 3, 2020 at 1:08 PM Joe Perches <joe@perches.com> wrote:
> > On Mon, 2020-02-03 at 12:13 +0200, Andy Shevchenko wrote:
> > > On Sun, Feb 2, 2020 at 10:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> ...
> 
> > > I'm not sure it's ready. I think parse-maintainers.pl will change few
> > > lines here.
> >
> > parse-maintainers would change a _lot_ of the MAINTAINERS file
> > by reordering section letters.
> 
> I think it's quite easy to find out if it had changed the record in question.
>

I checked it and it does change a bit. My patch adds to a list of file 
entries sorted by "relevance" (not alphabetically) two further minor (by 
relevance) entries, i.e., Kconfig and Makefile, to the end of that list.

The other reorderings would have already applied to the original state; 
rather than trying to "fix" this locally for this one patch here, I would 
prefer to understand why the discussion on splitting the MAINTAINERS file,
summarized at https://lwn.net/Articles/730509/, got stuck and how I can 
contribute to that. If that bigger change would happen, we could 
automatically clean up all the entries when the things are splitted, 
rather than sending reordering patches to the maintainers that then spend 
time on trying to merge that all back together.

Lukas

