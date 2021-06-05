Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4F439C98B
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 17:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFEPmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 11:42:46 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:35817 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEPmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 11:42:45 -0400
Received: by mail-pg1-f179.google.com with SMTP id o9so7442348pgd.2;
        Sat, 05 Jun 2021 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CJLwxqJYmi0g/h++WPd8gI3xw27yxKIJtF47wIAAO08=;
        b=VeOz0WLYok+qb9iqfoAx7ZhLU2GhP96Kh3xE+38TDrPn51/DyrgJt7XtREDLCQ9ncH
         KUbzHDHF1N4Hl/MVysjnWkSh9rUuE+Zcqq8quYFycgTHByIwtRbZdTFliMMjSMhi3EQV
         n3wlijZ3z0MZQua8n3B9cYPi17g/2/stjY3X4G+NXZeSwGQMcaCcPOlMR8Ondg95PgQf
         Tij7VCFWJLbo7QpOguRC8zKEutjwnoMss639s1G+dmwk6w5dEAWf+AXvzl/aAIIyhpIx
         c5UN12l+3tuQxP5jSP8LBbIlP23UxjGFs9nDBf+GICB4Mni3uExBKlOUg/VAJFKvxkdF
         Kw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CJLwxqJYmi0g/h++WPd8gI3xw27yxKIJtF47wIAAO08=;
        b=MDAFunzwPKOvPkV0ObRQjRuV+j5W2JT+N6jQLa2lciApx50HArIU92/rl+8/OTJoxs
         pdmt69tgBk/LzoYPw3UjQ7ED0dpVcfXLqHzgf45MN9uUil3yvf1iVxKtFu8a6JuTT5Lv
         EH873Iv75PfuCyvmnZ9eOAsqCahqtx3mH2u6MnrY0EMBXrgpiyDjFW2MmkUg7sbB7svS
         4rcArpTz4bGrlrX2MJmeKJIxL7eQ6fZUxCFbdQgzPlURfqCU41X7v+h0GzJGtrbv45HR
         RQd8vtC4ECLszW+J3jlJruLawfTMN3J7ATG6nib4UHD4uP8jDBfPuuqKzRc6EGZu3Nqb
         dw2w==
X-Gm-Message-State: AOAM530pUhl4nhTzuGU3B2uSH0cdKolKLIc98mT6JZ+Q7S7p0E9G/7SW
        4j+idJQkhUvGeYG71Zd7hws=
X-Google-Smtp-Source: ABdhPJwDjIi0awVjkNxWEnRPQy6M0+gDkYL19GmZQpk9rKweHCbKsYPn7+Br/EoI+yxuZ3fKryGnsw==
X-Received: by 2002:a62:92cc:0:b029:2ec:9b7b:6c3b with SMTP id o195-20020a6292cc0000b02902ec9b7b6c3bmr6372479pfd.3.1622907597465;
        Sat, 05 Jun 2021 08:39:57 -0700 (PDT)
Received: from localhost ([2601:645:c000:35:7a92:9cff:fe28:9fde])
        by smtp.gmail.com with ESMTPSA id z15sm5016972pgu.71.2021.06.05.08.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 08:39:57 -0700 (PDT)
Date:   Sat, 5 Jun 2021 08:53:30 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
Message-ID: <20210605155330.GB10328@localhost>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603132237.GC6216@hoboy.vegasvil.org>
 <a60de68c-ca2e-05e9-2770-a4d3ecb589ae@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a60de68c-ca2e-05e9-2770-a4d3ecb589ae@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 06:37:19PM +0800, huangguangbin (A) wrote:
> > Need mutex or spinlock to protest against concurrent access.
> > 
> Ok, thank you. Is it better to add mutex or spinlock in the public place, like ptp_clock_adjtime()?
> Then there's no need to add mutex or spinlock in all the drives.

No, that is a terrible idea.  The class layer has no idea about the
hardware implementation.  Only the driver knows that.

Thanks,
Richard
