Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0793564A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 07:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFEFoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 01:44:07 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40728 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFEFoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 01:44:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id r18so3942363edo.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 22:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=srvvTMEF7VeOZbqpJYOkX9xtsBYqtvkVmQdohK0b0YM=;
        b=lJ74uPzDKGhJvHRjsvN7l/re3bVGpd9C6IflLkmXDVLBIhTpAczXB37oV4qXrT6eDH
         FpcFzOWbEyd/SL/P/534V3wAuIWmvGd6onLtqnRt28m0wVqamSa8+uxPr2UkqD00Ke8t
         kpmwBi01Yw5ze3BhuRUFTGOXkSzz5DOWH9ckBRe5j62Kxk/67+OC5OtvznJHoXP+mh2S
         z+d+xbzFZ9cB/ooCxDylQ/tXV0nXfyCacqKJliVLXIW99POFW2XMHJ7MOt6CZe8xDxLg
         BuNQC/iZRR33+MzmgarJBCrdgkpWs3ec4YHuPLy4q88mP4BCY2GS/om1A7OsNMDCVl/q
         ld6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=srvvTMEF7VeOZbqpJYOkX9xtsBYqtvkVmQdohK0b0YM=;
        b=BZLGDkeP/1ia2Z6/jtNMfFd6qkDSR9mmJkB8BcukDjiRlCiInG0qn3t43WzS8iVNmM
         oQ922PTSQjrE7DN42e6Hmo7vb4plFNY++iJXsmVKOBbA9MY92SafcTZcjkJo45evrw7C
         DENw4e9Yazu8Q3n5zm9iGS6wZK2HrTQ16XHwAz2su4VQcf45qqwL6x6XAehj6Eidc6xn
         ba5CPqEQ6k32kEzEGQH59zaHKjgYIi/CJxxqjczqkbYyDOAEr884Y/FbBPKqEUvn8BAp
         1tUB/aLX8C4PNFkUlQagXipEJQqjd/ZFkWvMjG5LhKsP1GAkTUvKkR/g8OeGFBpAypQi
         YSjw==
X-Gm-Message-State: APjAAAVjDpKqYBD+GE5Au/iAWEnpI0ctO9kQp0Ni8uegN4fE/DMHh3/J
        BZCxOyl+3/yvXzpPe9XW9As=
X-Google-Smtp-Source: APXvYqxnFonArExmHSbIjRSJhIH7/ANxWdxYNLq7la0URHgNlncp9rQaKfgZQSucT4shbW8+irdGCA==
X-Received: by 2002:a50:ca06:: with SMTP id d6mr1340320edi.16.1559713445211;
        Tue, 04 Jun 2019 22:44:05 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id a6sm3422343eda.57.2019.06.04.22.44.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 22:44:04 -0700 (PDT)
Date:   Tue, 4 Jun 2019 22:44:02 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        zenczykowski@gmail.com, Lorenzo Colitti <lorenzo@google.com>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsa@cumulusnetworks.com>,
        Thomas Haller <thaller@redhat.com>,
        Yaro Slav <yaro330@gmail.com>
Subject: Re: [PATCH net] Revert "fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied"
Message-ID: <20190605054402.GA39560@archlinux-epyc>
References: <20190605042714.28532-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605042714.28532-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 12:27:14PM +0800, Hangbin Liu wrote:
> This reverts commit e9919a24d3022f72bcadc407e73a6ef17093a849.
> 
> Nathan reported the new behaviour breaks Android, as Android just add
> new rules and delete old ones.
> 
> If we return 0 without adding dup rules, Android will remove the new
> added rules and causing system to soft-reboot.
> 
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Fixes: e9919a24d302 ("fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>

I verified a revert on my OP6 when I initially ran into this issue.

Thanks for this. I would recommend that Yaro and Maciej also be given
reported by credit as I am not the only one to bring this up :)

Cheers,
Nathan
