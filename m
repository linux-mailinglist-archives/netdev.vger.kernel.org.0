Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E9D282A4B
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 12:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgJDK4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 06:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDK4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 06:56:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8289AC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 03:56:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t10so6449347wrv.1
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LJ6vitTGQmEfNpPFXjyHNdoSD0rpvl0VH5I35uqogrE=;
        b=L6ilqg3V+wsQqm06fyIdmzozwqcyLOlA7r0rhO20nI53UnNKaBS7JyGCox/agamIVT
         M0DVx6SnfB6XZyJICA721nt84cGRHWT6bRxL7tdjrRYKElx5vbfe1iDW2Cr3ytyPsugn
         6QLRPgWfgUiy8TR7oqkEZbUR85GSOH8hBYBdrCLR+ZthRPYcxXOrZBrWDud7tli6QneN
         FEW0P4a5qRiJCJMbFJL85/vqKpqvcmrxUG6WvutWL9qgF8llFFnCbmQ5Im4pwFZGKPua
         38J1YTXanmZvYanDQuvxqND/VcLK4e+HFXcDc7IHkNUH9v6PRi5zdoOc1NCDcZQndzDi
         P5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LJ6vitTGQmEfNpPFXjyHNdoSD0rpvl0VH5I35uqogrE=;
        b=GFdln04iLzpU6PQHkZ3OoKBvw9fFa9+ZBPPVXPLqvXhn2mqaAI2xe0yuUL9zX1CMVC
         w3wjwWG0W2LLU1jKJUQ5fB1E/R4jWAClq/4pEB+54LtwMTX0oDHp3rFWJWQ0N0VhAER7
         d090xn6ExHPJ9kgBC7l+0GfHGWG0Nd1R2jtB4F0puqcK8xBDwekYWV3IObviiJwP0CIo
         rXdCuzRwoAwspedlMu3BzaXAaSH2Pmq9r202EwkN7ouXV4eKSxdxxyWoh0HMFgnQZ+DQ
         q2nb28qtaQ3hhQ3mXMkw+xdJlEa3eR+RhBxefDaNRtzHr9wvCnjk3Z4Aem7dF5jIsE8W
         vIXQ==
X-Gm-Message-State: AOAM530h9kM3zDkLqrj/avYS8SoMSd2O9xMbqD5D7NX75M5HbKCdACz+
        PhRbReqVKzpY/l8U9mhcF+E/IGgvbFQ=
X-Google-Smtp-Source: ABdhPJwYNWeozPTIyIPMJg1MlPYSonmr2sVvJ2IMq6HKF+eB3+q7RpFx2pH8LHXuvY+y9FLmw2sMgA==
X-Received: by 2002:adf:fe86:: with SMTP id l6mr1011649wrr.17.1601808980210;
        Sun, 04 Oct 2020 03:56:20 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id t202sm8638361wmt.14.2020.10.04.03.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 03:56:19 -0700 (PDT)
Date:   Sun, 4 Oct 2020 13:56:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20201004105617.5cclmtmrfrerpg7w@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <87y2lkshhn.fsf@kurt>
 <20200908102956.ked67svjhhkxu4ku@skbuf>
 <87o8llrr0b.fsf@kurt>
 <20201002081527.d635bjrvr6hhdrns@skbuf>
 <20201003075229.gxlndx7eh3vggxl7@skbuf>
 <87zh537idk.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh537idk.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 11:45:27AM +0200, Kurt Kanzenbach wrote:
> Maybe next week.

The merge window opens next week. This means you can still resend as
RFC, but it can only be accepted in net-next after ~2 weeks.

Thanks,
-Vladimir
