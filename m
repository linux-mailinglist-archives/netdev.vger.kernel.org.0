Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6C29DC8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfEXSLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:11:22 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:33331 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfEXSLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:11:22 -0400
Received: by mail-ua1-f65.google.com with SMTP id 49so3960657uas.0;
        Fri, 24 May 2019 11:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=iAFRPFMunlzUCCZlbxNxP+5zGwWif9fr85Jlczqr9bo=;
        b=G/X20wG2zPAIppUZ6iP2rEzuz0Vy7uf04fNIXB8mGaLE82RaOihtFtZz+A6EjOm9bt
         f/x5Uk+28I4YyVFwYOZdE0Y+xnM8RBoFckNCFp0tv9SNAGPep8kYeg+Sq+Ouh54tTYaL
         N8mdlNT2hO09TtoIPvEoQS15ZTvHiCd+4CSNJd088jGG46aLClGeG9gqHxRis9nz8e3i
         hke8xuHYwdWDEpQZ5surw1DeGjHi4pSecxoZVq7xYEvMm+3CpNZt4qUK19sKScWMKAaN
         uHvM0h5quZVpKF/3ymNUFRannOvIs3LStHu/hHYHzcrD9//ht0RogD8RlS/UeUt6ACx9
         a62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=iAFRPFMunlzUCCZlbxNxP+5zGwWif9fr85Jlczqr9bo=;
        b=n+L+voqgmhyPQPfqnnjuhY0VOT0YiGQ8xIWtVK/jAroih1GKBGuxAJBj1J/vJJtuo2
         FCtBMqNtPCECc2kLM4BoJbWixfUXHd89acdrAJnsBvl4c0O/5e0ObSBlsjEilf4qTHvm
         Ze9+HNf7nTl4NN+maE6tliY46n0cX9gY2oK/SlDd6GPphiB+btoUesrYMJw0PNncOLqi
         wrAZjzb70sSUVIDA0Df2wID89w48KDTmIuFk8EuvyojGOwQ+y5YWfOG/u7+dwxT2DDtV
         U4ZuD3Lk2ILNgg3zD+2g3J9wuqxQMVrCPg2HsRQD0qUSbI42wR4NDIIqAGZIzJKxUq4U
         xo2A==
X-Gm-Message-State: APjAAAX0alLC1sR/Ntfk4uFpAPnBP70jPeqWJAidfANViSDrikxD2yeL
        1n9VExM6sqMBncm7KBN1HgM=
X-Google-Smtp-Source: APXvYqwedFyCYnCjR4EKz7yOV+4YgtvakM8pkXL/H9HKxdJP6h3FcXOvPFLBGyPylb5esFUl1JVRtg==
X-Received: by 2002:ab0:5607:: with SMTP id y7mr30999072uaa.76.1558721481168;
        Fri, 24 May 2019 11:11:21 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 2sm3245435vke.27.2019.05.24.11.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 11:11:20 -0700 (PDT)
Date:   Fri, 24 May 2019 14:11:19 -0400
Message-ID: <20190524141119.GJ17138@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] net: dsa: add support for mv88e6250
In-Reply-To: <20190524085921.11108-6-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-6-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Fri, 24 May 2019 09:00:31 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> This is a very rough attempt at adding support for the Marvell
> 88E6250. The _info and _ops structures are based on those for 6240 (as
> I have data sheets for both the 6240 and 6250), fixing the things that
> I have determined to be different for the two chips - but some things
> are almost certain to still be wrong.

The idea is that for things that you're not certain about, simply
don't add the corresponding ops. The driver would simply return
-EOPNOTSUPP for the related features (if it doesn't behave like this,
we must fix this.)


Thanks,
Vivien
