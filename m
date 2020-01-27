Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC714ACAE
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 00:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgA0Xm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 18:42:27 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36447 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA0Xm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 18:42:27 -0500
Received: by mail-pj1-f65.google.com with SMTP id gv17so178225pjb.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 15:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4jR3NEZ7x+Jvx3U2TQ49TKGsznRacov85tgmCkWAaLs=;
        b=KEEfsaPzSnHMeqMLqqLF/rKhOnk1MsLgBr28dnqCs8OF9PTkJ+kGeggRfhXfPW8AdM
         5ignS2E0kGnVhslgsBP8y2I9j5uYqsgB/RjhpdR6fqQN3cHxjGgEp3OwCIYullOj2y5g
         x1loPleyzV88AC/BVEIpNRNXMByZ94VY3QKAjX6PPGnMgCchseaNbLqYu9raH41h6jxu
         qxpD3/1hqBM5jHPTxqKIHNdcOObFQsr7HrQo6E8lr2n1h2riX6kKDEq+FcaDAZLdUIYd
         BGbZf2NJM0rhl/BD/e5neNmcLeRSrbC4bnz9hgkuxwxL4j2O4bk1WtwRxabeG082RSm9
         ZDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4jR3NEZ7x+Jvx3U2TQ49TKGsznRacov85tgmCkWAaLs=;
        b=G2MOquT32NsnZivfRAN5V2azibKsWy1e3ERDIfhUQ1RW46vhR6m5EyMGzTdbLK/emM
         MgTsC5e7mZ3soZHKSIEY/uBmvAnj2tqUJNey5XwuD5OfYozz2gF9fY+Tt+romGaUpPmI
         BaJuV3T4v8bbN5kAYApm14b1K3Ukwe2owCLvG3oXzwXM9BMa6OGSTr+4Im+IdKuDQmhe
         LwP35wQOUSGw0MzdPgG5SXabvz7AfLM3na0FiD9n3+b23BeJaHMxqf7zWMjO22ZKACvF
         NaUF7z1ubruXzHTJCG2SyjSHQ1GHl+e85eCZT/JeO6PGJsu3aMZj5h3QPzShH4y3ZbRc
         jCrA==
X-Gm-Message-State: APjAAAUXN6kLdPckoWI6EK1HAW9S7AXqMJvZQI1qpuhxkSNMD/N6WfJH
        jEEpRWW76UQr3RxdVgjcnhHXIA==
X-Google-Smtp-Source: APXvYqz6tLIUsXV5Wb/Oi6Sc3Ql3UOYy6wK2oscK/U9I/+KHFO2ncIizEywoPt17c47xcms2lkjbpA==
X-Received: by 2002:a17:90a:3aaf:: with SMTP id b44mr1344980pjc.9.1580168546572;
        Mon, 27 Jan 2020 15:42:26 -0800 (PST)
Received: from yoga (pat_11.qualcomm.com. [192.35.156.11])
        by smtp.gmail.com with ESMTPSA id p18sm325420pjo.3.2020.01.27.15.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 15:42:26 -0800 (PST)
Date:   Mon, 27 Jan 2020 15:42:23 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 0/2] ath10k: Enable QDSS clock on sm8150
Message-ID: <20200127234223.GA202699@yoga>
References: <20191223054855.3020665-1-bjorn.andersson@linaro.org>
 <20200127184037.3BFB620CC7@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127184037.3BFB620CC7@mail.kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 27 Jan 10:40 PST 2020, Stephen Boyd wrote:

> Quoting Bjorn Andersson (2019-12-22 21:48:53)
> > On SM8150 the WiFi firmware depends on the QDSS clock ticking, or the system
> > will reset due to an NoC error. So this adds an optional clock to the ath10k
> > binding and makes sure it's enabled while the WiFi firmware needs it.
> 
> Hopefully this isn't a requirement in production firmware? Seems
> wasteful to keep the debug clk enabled in the field when nobody is
> debugging anything.
> 

I'm confused about this as well, but I'm told that it was fixed
post-8150.

Regards,
Bjorn
