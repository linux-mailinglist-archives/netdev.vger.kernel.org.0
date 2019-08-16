Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EA29040B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfHPOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:36:00 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:43502 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfHPOgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 10:36:00 -0400
Received: by mail-wr1-f41.google.com with SMTP id y8so1748561wrn.10
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 07:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fZl4upPo0jcyESONP7Te6hf7D+lRgiZf13vZuiJH7y4=;
        b=iHHkuZ/iLH/TSkn4kUxE+/EmSlfdLnQYl58oz6pdhYCUlvX99XT0lYs5QTuxLMDqbY
         f+g2sVnLGXIbYQcK9kl99osi/1GlrPp9Prak4+u+XUwJ6/b8XhlK7FmMbBIEv2yJ++BJ
         oI6sZg4C71Zzx/7cYfqyQMiBqvts29M9DUU7WvbnZ3e7NsjglnAfvPPAaU1ZMoAXheKr
         3yqyfz49tP3j4rPTybRU/5uEe+nQ0y0dhf4BepEt540OuHk+xRLVMqTauyRPls+1EDcM
         0ftTTTn0BUPXxpldJZlpIvRUs6FioOt2pDwEYG1XMgS2U98lThi0qVIcUDqADXxDMFnk
         4vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fZl4upPo0jcyESONP7Te6hf7D+lRgiZf13vZuiJH7y4=;
        b=p2Xqb8tzy6nDzhwSDsjxLvXLGybO4sIvdg7qC9pOA7HxiPhPmklChz4TEohg33sxER
         pa0AolQnK7rfSRbtT6WYvmWzSf2nDSRFcF1nTTSyXyCCU1PVf5qety8evwEHVpW+4DKg
         G8QhaOKyoUWr0iU0ZZwSZgN01jZX21FwZ8j3H87y4krxmb5ia8nhxDaV39nh4mdM9D5Y
         mYVNHXvXu6ZpbQIPIQSHmBEiMRElUNugvD8cZEJiFUka8VywSqvRipjCy/m9J1/xw8qq
         DUYOg+uxpYAJ9iGdv0/uAwBNmJWg0BUmfe3j2jJY8qtu0a+HZOGbgK2mN95KLNh/DcYx
         9YhQ==
X-Gm-Message-State: APjAAAWN3hH1O54/6VVhx+C3cyRPwJC1KEAtuoia0WBCESCL3EiOwhZd
        lLLxS+0eGXXr8hJcEmhXNM07SQ==
X-Google-Smtp-Source: APXvYqzsBu+mabN5KpqBDXKY6QZZMd2ePKsQQGpyK2tN2sEHcMNA9I+VbU+8hJvig5CXd6knO4mtoA==
X-Received: by 2002:a5d:4403:: with SMTP id z3mr11848142wrq.29.1565966158397;
        Fri, 16 Aug 2019 07:35:58 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.47])
        by smtp.gmail.com with ESMTPSA id g2sm9083357wru.27.2019.08.16.07.35.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 07:35:57 -0700 (PDT)
Subject: Re: linux-next: Fixes tag needs some work in the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20190816234613.351ddf07@canb.auug.org.au>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <144b1f43-cd36-9920-fc46-87d98b131e2e@netronome.com>
Date:   Fri, 16 Aug 2019 15:35:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816234613.351ddf07@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-16 23:46 UTC+1000 ~ Stephen Rothwell <sfr@canb.auug.org.au>
> Hi all,
> 
> In commit
> 
>   ed4a3983cd3e ("tools: bpftool: fix argument for p_err() in BTF do_dump()")
> 
> Fixes tag
> 
>   Fixes: c93cc69004dt ("bpftool: add ability to dump BTF types")
> 
> has these problem(s):
> 
>   - missing space between the SHA1 and the subject
> 
> This is dues to the trailing 't' on the SHA1 :-(
> 
>   - SHA1 should be at least 12 digits long
>     Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
>     or later) just making sure it is not set (or set to "auto").
> 

Hi Stephen,

I made that typo, please accept my apologies :(.

The correct tag should be:

  Fixes: c93cc69004df ("bpftool: add ability to dump BTF types")

Regards,
Quentin
