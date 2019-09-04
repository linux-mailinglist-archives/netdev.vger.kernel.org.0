Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9701EA96D2
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 01:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfIDXDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 19:03:36 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36371 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfIDXDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 19:03:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id f19so320721plr.3;
        Wed, 04 Sep 2019 16:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5+YNQeHmIOGQ4YFqKr6GYXavT2t8Qpss7b++FdwDehE=;
        b=LIRvz3sMipUno0nmuKl2kYng3IGBsvRMAblPMJHyIqd5Q+gKi32G2engUfsriPWhIL
         e695Ckip55thTsHyapBmi6AgTjrkTF2Jp9cv5KaoeQS+xRKBEMWmSbGT0QvNAO8KMEZG
         kPdU4dw299ZAGVpfLZY4+LfHB4m1UsfUYHrx/zxtBXsK6H8rz8O4NlO4cTJAg77h2EGs
         xSA/09jKmfnf7wj6qRK+ldeQS9o2c+EFUVf6VCVaAOU1fnS+4er/zaQrAyh9u8PSEcf3
         lQiByK8DAEp18W/niqygms/dJ1g0zOSHkr3se6sqfP4Ig0hZ4t1+UldVzGg4nAO8QEQj
         G6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5+YNQeHmIOGQ4YFqKr6GYXavT2t8Qpss7b++FdwDehE=;
        b=e2u6s1RfVVCfGhuVul4j9qmd6sNBeqaNwgzYE61811apPdwYjY0dpsw5U0oHzTLE3y
         lD39rklT2OppmIJIhr2xChXoGPe1hD9EZ1EbdY8NAAWypj8CDkuKTQCdwC2Qc25WI3RR
         32zeFb+kht2B2Z/pADxIzHSnO+35KAD4hpOWHZu2Vd+1VGCpR8we4o0HU1e35P+gryyw
         +NRfRjpRbYfo2KNYMPhjOK9lNOL/x4sQ/EfxblKKyPZKvNSKkFvqwBlP+RKW+bQBAzOT
         8/r7go2/+IW7K+r5CVlHQh2obsb+V0a6jSFQ3ik3mey3Ia/3nTWyCiuiZV06l+sSfsQx
         wEMA==
X-Gm-Message-State: APjAAAVz/23QZbb8emyEYYXuaf/5m0LQ6QqOTgnZ0+74IKVX437ps4O5
        343LdC2J/AE5P5qWnE23SHM=
X-Google-Smtp-Source: APXvYqzkk04BhKur9AOltG4WTP61z+CCMCJ7IafF5r3QNrlBys/xUoW0zni9A7kwzpICtst9NYArGg==
X-Received: by 2002:a17:902:5ac3:: with SMTP id g3mr212864plm.25.1567638215212;
        Wed, 04 Sep 2019 16:03:35 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::a2cb])
        by smtp.gmail.com with ESMTPSA id h66sm5290087pjb.0.2019.09.04.16.03.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 16:03:34 -0700 (PDT)
Date:   Wed, 4 Sep 2019 16:03:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next 0/6] selftests/bpf: move sockopt tests under
 test_progs
Message-ID: <20190904230331.ld4zsn4jgldu7l6q@ast-mbp.dhcp.thefacebook.com>
References: <20190904162509.199561-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904162509.199561-1-sdf@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 09:25:03AM -0700, Stanislav Fomichev wrote:
> Now that test_progs is shaping into more generic test framework,
> let's convert sockopt tests to it. This requires adding
> a helper to create and join a cgroup first (test__join_cgroup).
> Since we already hijack stdout/stderr that shouldn't be
> a problem (cgroup helpers log to stderr).
> 
> The rest of the patches just move sockopt tests files under prog_tests/
> and do the required small adjustments.

Looks good. Thank you for working on it.
Could you de-verbose setsockopt test a bit?
#23/32 setsockopt: deny write ctx->retval:OK
#23/33 setsockopt: deny read ctx->retval:OK
#23/34 setsockopt: deny writing to ctx->optval:OK
#23/35 setsockopt: deny writing to ctx->optval_end:OK
#23/36 setsockopt: allow IP_TOS <= 128:OK
#23/37 setsockopt: deny IP_TOS > 128:OK
37 subtests is a bit too much spam.

