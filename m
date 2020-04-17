Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3561AE42A
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgDQSAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:00:04 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36019 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730033AbgDQSAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 14:00:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id o185so934540pgo.3;
        Fri, 17 Apr 2020 11:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IjZCkEIb+6WDJxMusK/HPrzk4lilNygCHu7ICADzBDI=;
        b=IGH6++I9jAMejicRypWgjx4pPu3K5W7q4CxqscWb9f4ondGixa4MKwA+aAnJySEkXl
         TOi7QIcRD/3wi3M8IQHp4koL0fOo2xAkJ9S/V9FHA5zEr050kumUuERoL0LBrBH6LSFd
         itNCbKuRzhGOSbrOWjoFI+Ign1CPpTcSDJxno1yWSsCikHKiNLmNIuoUdPV4p91TqO9x
         qBL5Emf1OwLoJOCrICj0VCGHcCgEk1eXYMvELwD4c3HFK9RFCCoJ74sW3FLNHB+f2SO0
         GdZ99UsBXz3xqOv300006/JpqtIXS3LLzS5qBMZE+ZLso6x4ssvI3kNHgk08Try99nSI
         FIPw==
X-Gm-Message-State: AGi0PuabiS7KAiRL5tTXTQTkGgemExhKpCtYT2lyLnI6HXnPaoK9bBQW
        98R3UqaH+DN0FYUwFjKhtyw=
X-Google-Smtp-Source: APiQypLFQjbQ+Jct1/RepT1qj19XCtjzpBzkT5ETgeSBpzgVKxqlNXHZmUGIMT21Q9DTRRm+/Bkcrg==
X-Received: by 2002:a62:1415:: with SMTP id 21mr4395722pfu.134.1587146403237;
        Fri, 17 Apr 2020 11:00:03 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id c3sm6178665pjc.43.2020.04.17.11.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 11:00:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 256B94028E; Fri, 17 Apr 2020 18:00:01 +0000 (UTC)
Date:   Fri, 17 Apr 2020 18:00:01 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pass kernel pointers to the sysctl ->proc_handler method
Message-ID: <20200417180001.GW11244@42.do-not-panic.com>
References: <20200417064146.1086644-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417064146.1086644-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 08:41:40AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series changes the sysctl ->proc_handler methods to take kernel
> pointers.  This simplifies some of the pointer handling in the methods
> (which could probably be further simplified now), and gets rid of the
> set_fs address space overrides used by bpf.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
