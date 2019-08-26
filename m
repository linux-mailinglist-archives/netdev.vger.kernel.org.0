Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41E49D606
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733268AbfHZSxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:53:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35952 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfHZSx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 14:53:29 -0400
Received: by mail-qk1-f195.google.com with SMTP id d23so14966875qko.3
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 11:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=M0nFRbwfK/64CvWDt6Lou4CPoKP9MyxgliyZ669Ljow=;
        b=mqZFfXpDRhQDkRyfuTYIRhHftitop2qNhYSc41KLmYdi/c7sz+8j/+33xLim68xU2k
         EbKQ5yw+f6m8bKiuWkpRm8ECdJ5SkRqTO8/NYOJMWfv7b8SibPbV7dXJbulDr9FvWGzm
         IttK6tpEEDaE9fnHJ+DbbQORmQA+iuwbZxSDGP55nSAJIziTwPjaGcWssWAzLgAzYjwR
         pZxB0jRy55wdyxLayX1ciEeQfiYHCDierQc4aGn4pX5aNG5z8NtenUDcyEaFMyQAzyJU
         RqWsYhVIq006IaCGCKApzIO+HLh9wjKEvqCXDKbH/0Mee8ogRhFlidteQCtYWNo9gCae
         tJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=M0nFRbwfK/64CvWDt6Lou4CPoKP9MyxgliyZ669Ljow=;
        b=aHdxKNcKH6Afr884cl6JQD/nHJBb9PRoOq+Txv0T+CMla9IDQSlMRvgG1cRpguH0gi
         2wAmO7EIx3CztWN7I9Ff1IOtxC80RCplROMyDnYqtp2UrDcFxrYL483uOEijTxhVSDLA
         Kxjt6FYjYHPDvVr3izfTuy2LPqTAm/lE/cxjqL4NuoRkkE9RWZSxY4lHXHPSDbwQ8dR7
         t9oYAfWG/k7aUvWUKjwEIhu++XyaSE0zd+iFfOq2FOQ7A7xCikrrOkYKv47ALakzGVJR
         kjE8HGlW99gyz2mVuDf+Z1mdCRYcNwLVo4LpiIiG3AnZHxtd/O1rSeTx8lUJg/G8paRo
         qvRg==
X-Gm-Message-State: APjAAAWcEuhEIKYjiKvWGfw/uxvDIOcuLXEwglf/q16k4zTAR/UzNnRn
        C+6AZ44FR9SGjfzmR8NpPbg=
X-Google-Smtp-Source: APXvYqyyk8lR/vuZ2e43D5fTrsdsp6fN0Hh3tsaJe79Yn44gaPbY3LE1wiuldhafeDXmxgXvHUaP+w==
X-Received: by 2002:a37:a40f:: with SMTP id n15mr16821435qke.19.1566845608699;
        Mon, 26 Aug 2019 11:53:28 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f77sm184089qke.24.2019.08.26.11.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 11:53:28 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:53:27 -0400
Message-ID: <20190826145327.GB16288@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC] net: dsa: mv88e6xxx: fully support SERDES on Topaz
 family
In-Reply-To: <20190826203614.6f9f6a8d@nic.cz>
References: <20190826134418.GB29480@t480s.localdomain>
 <20190826175920.21043-1-marek.behun@nic.cz> <20190826200315.0e080172@nic.cz>
 <20190826142809.GC9628@t480s.localdomain> <20190826203614.6f9f6a8d@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 20:36:14 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> > Ask yourself what is the single task achieved by this function, and name this
> > operation accordingly. It seems to change the CMODE to be writable, only
> > supported by certain switch models right? So in addition to port_get_cmode
> > and port_set_cmode, you can add port_set_cmode_writable, and call it right
> > before or after port_set_cmode in mv88e6xxx_port_setup_mac.
> 
> Andrew's complaint was also about this function being called every time
> cmode is to be changed. The cmode does need to be made writable only
> once. In this sense it does make sense to put into into
> mv88e6xxx_setup_port.

mv88e6xxx_port_setup_mac is called by mv88e6xxx_setup_port as expected and also
.phylink_mac_config. I don't think they are called that often and both deal
with configuration, so I'd prefer to keep this consistent and group the two
operations together in mv88e6xxx_port_setup_mac, if that's good for Andrew too.


Thanks,

	Vivien
