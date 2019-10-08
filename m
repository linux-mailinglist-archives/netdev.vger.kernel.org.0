Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CBDCFE7F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfJHQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:04:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45773 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfJHQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:04:11 -0400
Received: by mail-pl1-f193.google.com with SMTP id u12so8635799pls.12
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 09:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7707bc5hQbB0vmkqonBsAG/SQln5WGPDEr1S+qnTFYY=;
        b=GmBegPYWZN4ry58MKKqoofW7G0OG+9oiEnRlyCX+/0ZugDM62EXBVe69HtKMpyiGS1
         55Wu3KMLzKUXFB5YjPAX58HO0Xh+tblwtSQ9Lhg/HPkGSn1jS9Zxlp3dJBlMW8Q8m2Vb
         9i0Or+XcBT3hkG9eZJmyKm+lncXWUS/MX4+Z46xgV/UA8KHuRS9MHNWkTW7JGxdInW+F
         +Q0hpU48+GLtzAv6FWXn4gCAwvP53ZGQ3gKUKTrC+GVUe7iKTb5BZSR8On6ZZ/9UQDx9
         +xF/grHpowTN3Tb/35sH986AJHtbGlzp5N8dzW6FobA7V7g4JBpmQnVKG7IaK2DE6bsi
         egQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7707bc5hQbB0vmkqonBsAG/SQln5WGPDEr1S+qnTFYY=;
        b=pEbYId27HHJXR915eIVBuEp8e+B/qpYyllEwXDg8L6UvydW3PiKh7TVb5/a6cPtLRA
         6z3+6GJSEuIY+g+COezAjEdIni7orPFGIxCHPqYZcNSYdSPzICzx/Og3kJCxmIDVPzRj
         GVHDP92ZRSPq3cFYG9jBsqbC/iDkh1YBMFx4Ila1Jqd5O8ewHku3pS7tHLuY9ANPUBwU
         fClL70+XcnKUG5PjJxCU9nk42eWwdu+65OZxsMN3X/q+s0durqKtEquHE1zzO0RjD/i0
         sDGqoLzkZby+m51apzkCX7tWdIBELwwsnA4yOE1qVDdsTx4vuqLWsBZt/nv0bU35clfW
         y4jg==
X-Gm-Message-State: APjAAAUHmvZriKgtqf3sUJ5KChTcPUJ2m2fAq59DLCWSGIf0yUQnA5ej
        33dGTjDu57dMI47NT+0ULxuACQ==
X-Google-Smtp-Source: APXvYqwZXyAlNiV8Rg03MjVo2ug8tTrxcwU4JfBYthgBAIAzhX+0eZ8ZJpABvVPf0wBLwxNLAgU/eA==
X-Received: by 2002:a17:902:9a44:: with SMTP id x4mr36554849plv.125.1570550649604;
        Tue, 08 Oct 2019 09:04:09 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y8sm19265743pge.21.2019.10.08.09.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 09:04:09 -0700 (PDT)
Date:   Tue, 8 Oct 2019 09:04:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191008090407.7c1a7125@hermes.lan>
In-Reply-To: <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
        <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 15:18:53 +0530
Martin Varghese <martinvarghesenokia@gmail.com> wrote:

> +#if IS_ENABLED(CONFIG_IPV6)
> +	ret = bareudp_sock_add(bareudp, true);
> +#endif
> +	ret = bareudp_sock_add(bareudp, false);
> +
if ipv6 returns error it will get overriden by the ipv4 value
