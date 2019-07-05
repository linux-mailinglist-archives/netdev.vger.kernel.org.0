Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE8A60944
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfGEP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:27:15 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38519 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfGEP1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:27:15 -0400
Received: by mail-io1-f66.google.com with SMTP id j6so19920038ioa.5
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=X4prCoXhdxUgUpU/MzEnjk3EaHYjR3W9KuopoQW7Ozs=;
        b=lfTepz19eQ5uu+IoIpGKiILc2WmbLYm0tNy0yeofOW9CpmnkzZHx2OfDyUH3KcNb/B
         SQhewQo9RvJJ21wLJaaIvnLwa9rptXu5WNi3PRomD5EvnuDL8SeIvndpDUQ0wve7kzVK
         cBnpYOViJ6jTPqMxTWJVEyf3XqlH+ee9w9ysa4T7zb7Peo2OLFiaefvAlaloHYGIoLmy
         DOr+H6XD4BF7fKYR22H7ffa24nBHBSLQfNAAbFH3lUb7diX2q+Zik15HTMnqIt8fP0/1
         o+z2mNN6lfXHumf9v3lTLTMUWIjlZ3ABeTcmEBDKf4GmcApyxtyfVXPwdLlCQ71KMmzE
         hSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=X4prCoXhdxUgUpU/MzEnjk3EaHYjR3W9KuopoQW7Ozs=;
        b=sEnYIcsWcQjopKLuxfc1pEoBTB6LF9pqrVbJMh20+T6hHKHpfMuMGTF+xKRVJcreV3
         8/xGDiQQaiPAcbu8u9t/xrKSL2gils6xto9X6TrVjsW2quh1SYGSHzSn9oyKBYO2We/Z
         IuUfSZEtHJeYfzeL7yNbgcerAt4E1jBzmHrKtGnGhTlTFAI67BGACHA/pLGvPrPqX16r
         W9kh8QwHMg+QehfUjmOs2aDApRzGxF6Y+cJb5BNEgc93iOOBHMVeQ9mRpu/3n3RuHWrH
         DAjrAx3gEO30PBRFtfkf1XGVVhcJlvHC9bfgx2lARLnY8EWE1Cl9VNtPT9pOGMpyM9Hk
         Z3kA==
X-Gm-Message-State: APjAAAXjneAchZGPBzZeiJcx3Y82BsJeReV81QUcgquUD+aEzAuZ8Z1T
        FVR6G9X0TxfYsbQUREkRWO5yaQ==
X-Google-Smtp-Source: APXvYqzp11a80fs0GhFSc6TIr7rueB6dBWrEOFT9pX4krFfwVGocixtfE70i3RahzQ+UYaBUH5M0dA==
X-Received: by 2002:a6b:fb02:: with SMTP id h2mr3154610iog.289.1562340434933;
        Fri, 05 Jul 2019 08:27:14 -0700 (PDT)
Received: from sevai ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id a8sm6976243ioh.29.2019.07.05.08.27.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:27:14 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        willemdebruijn.kernel@gmail.com, dcaratti@redhat.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next v6 5/5] selftests: tc-tests: actions: add MPLS tests
References: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
        <1562249802-24937-6-git-send-email-john.hurley@netronome.com>
Date:   Fri, 05 Jul 2019 11:27:13 -0400
In-Reply-To: <1562249802-24937-6-git-send-email-john.hurley@netronome.com>
        (John Hurley's message of "Thu, 4 Jul 2019 15:16:42 +0100")
Message-ID: <851rz4o626.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hurley <john.hurley@netronome.com> writes:

> Add a new series of selftests to verify the functionality of act_mpls in
> TC.
>
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  tools/testing/selftests/tc-testing/config          |   1 +
>  .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
>  2 files changed, 813 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
>

[...]

Thanks for contributing tdc test cases. It would make sense to add tests
for max values and exceeding max allowed values, e.g. for mpls labels,
ttl and such, as we already do for other actions.
