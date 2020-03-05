Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E450C17A5C0
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgCEM4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:56:47 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55821 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgCEM4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:56:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id 6so6200919wmi.5
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HjCIB0cRkswxBHicvx3GUv0HnHsmCo8E8PgbIAIILt8=;
        b=Gt/cWQhhASP5bBzj8TNSd2HNFVxn+yN97a2l6r9ou6WkoZ9ke+th42t11blcXXVp0B
         ghq7GvlWbyevzK+R8YSdaHLsREQV69CgCzV5gnte0XYqag7edAbdx3NksGubzTbhrC6C
         L7WDW2T91Hh7BuiXiHZj3m41Zjzb2ehCS0iFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HjCIB0cRkswxBHicvx3GUv0HnHsmCo8E8PgbIAIILt8=;
        b=dOSDs2db/cOQhg/PK5JFyQ4uv8XYBilMVHFkq/gkIgM0wmFxV2uLX6SY1CdEZF8i/w
         QSz44GBBHd591O28+c6Ajz8xBZPtajDBeF+V+hoa4ZP6uVCGNvsWovfqWvvgEuNFncYq
         JwYwlRpkTKbiwqmgUYojZH3oLbE+9syOnbIKoWLFfZZMoxw9JgnHTvLboDOr0NBAzw2V
         4Fcqj7d+G1QcWsaEGoURnvcFlUCsEvUn2fw0vv1k6/75EobzhjRWXOTuVtANZYuhJcqY
         UlR40fFic2lyo7Z8Cl+WnaiGDAnw+DFzZZi5o2qQ4v75XhgkjOZ3tINpFtjGmCDc39VA
         2tXg==
X-Gm-Message-State: ANhLgQ3i90HM2hdUv6N5nsB8GsHXYIU+8aEC/ZBuf+6N3v8j0R6ub0HP
        NlyJqfAgxAQ2gVdb8DRZFs7Dlg==
X-Google-Smtp-Source: ADFU+vtTdXrgymK5ixyZsrcFBHG6FINonOFExU1Faxcsm81kgoO3Fs/OiO+Ghm8rTSqRlerFLgFhTg==
X-Received: by 2002:a1c:7f87:: with SMTP id a129mr9810661wmd.160.1583413003982;
        Thu, 05 Mar 2020 04:56:43 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id s5sm42900540wru.39.2020.03.05.04.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:56:43 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-12-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 11/12] selftests: bpf: enable UDP sockmap reuseport tests
In-reply-to: <20200304101318.5225-12-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:56:42 +0100
Message-ID: <877dzzyn79.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> Remove the guard that disables UDP tests now that sockmap
> has support for them.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
