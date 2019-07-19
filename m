Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3056E07B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 07:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfGSFMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 01:12:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45152 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfGSFMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 01:12:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so13895252pgp.12
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 22:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+00RCKs7uJFUvqDqRfhsUWyua6JIOxWLaDtjhLqoys=;
        b=PC8rUFUWySuDpBd/tnYxUCDYzY/yK0ACsvtNFqDZ35GorJMmNC3yBEPtj+shy3QJil
         qtb3Yay/CTnqg8k5h3Sy8itaLth7ALBsM0mTLnZ7+uZhJwwlqTptsDSWZA2uSbz19SRx
         qw6KtSvcWExZxTAesFvxSnKMIKt2BwwqiB2i5eNCzQIstdWDQ5fpBeyDUpzxw1fQ/QTy
         F+7hfhYXvKzi2lqAOjqhgoZGfb5jwhUZCyvxoYA/l1H1r7oVCHxyeiUKnerPT2y76W/H
         YX4P7zkrDfOzB/47ABCprHfqEVu64uXzS6KczUwRVXwlFvNwd1omWI8gEYwAGiBo9xMp
         6wUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+00RCKs7uJFUvqDqRfhsUWyua6JIOxWLaDtjhLqoys=;
        b=ryEI8PJNCL8yi0Tiu6pc3m/pZZoD8O+yGRIktRyB2oCiCF2ROhW6ejWUinrX10aX0h
         IPHaLlNQw9eeKB6FrMjWT625tSMVQuH2bg39kvSQOGw3OO1aQ7GYVT+iNWp01CsZFrZ7
         CfNgV0VOO7qs11UGmR02G3kL7tk0X84az7WM4EYHSp8QdpIIA0FUj0Ipc+7Mzg30yEO2
         Bf34URQQEAqN0cWIhLIjdURyEIStoCvf28GVRF34q4bGugczMMd7K/lah3XMSkIzpjQ3
         Jb6Qe59pzyDSEQkRgxhSHkAkbwGq32vBr3PQ6ccWB9nsLkQqx/zxqdPKKlTP6ihwmVac
         /gSw==
X-Gm-Message-State: APjAAAWyYyF4fgRN5r/zCJzrHI1HHh+vsfXu7v7Pss8JFh4Z44qe08jn
        02F94EjQJSEs/agSEk2esOZblTky
X-Google-Smtp-Source: APXvYqyq7X5K0AIh3UvR/bMTMvto7/GBPi2Cc425zzsL/4rxWa0x6QsKtUx2gv3+c6bJaL5W93aLRg==
X-Received: by 2002:a17:90a:db42:: with SMTP id u2mr55757533pjx.48.1563513155777;
        Thu, 18 Jul 2019 22:12:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p20sm46333693pgj.47.2019.07.18.22.12.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 22:12:35 -0700 (PDT)
Date:   Thu, 18 Jul 2019 22:12:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2 net-next v5 1/5] etf: Add skip_sock_check
Message-ID: <20190718221227.46631096@hermes.lan>
In-Reply-To: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
References: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 12:55:39 -0700
Vedang Patel <vedang.patel@intel.com> wrote:

> -	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s",
> +	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
>  				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
> +	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
> +				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");

These should really be boolean options in JSON, not string values.
