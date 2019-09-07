Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4647BAC967
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406227AbfIGVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:25:13 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38531 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfIGVZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:25:13 -0400
Received: by mail-qk1-f194.google.com with SMTP id x5so9153745qkh.5
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 14:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=k/r/3Wc5zKfPZVy79jPe/V6Vw47UuqIaPQYnA2sd5mg=;
        b=Gm8M6JoQyoG2ltm07yWGuLQkcc2yvZdKi3HcXo3aLzb0lSS/CLH1aVxVI3z2nvG16z
         FY7Wi1t4DcwCqguMuN+mbzUzAXJeK89/hqPOkcRDUxZyZpDnKQfPURAA37Wey1g8sZhF
         msTxfCN1KNUkEK+psApo9BzkfOXhDLBUJgltcYfOI8K/47XUu4+7zre9NGCQhuLdL0Lg
         BQWv+yNiCyFDRlEZ/r7GfjSJjLd3Ae2UKmrBmrlim/ApX2EsXLWRl7y0hQpvXRCj8CkZ
         Cwxm9gbG9OCHqA5Tp4NGYSuF+tkH9gyNh7cXXQKmr/4n9cmrP4b+ISvzKqWFELqM2Nzj
         L5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=k/r/3Wc5zKfPZVy79jPe/V6Vw47UuqIaPQYnA2sd5mg=;
        b=Bprnjiz7VSM6o/VBO7jbiHD+Lpl244EEeXIWFiuhf5bWhvbp6tDLkux1zNxqIS8OMe
         ViCDaQnX3azh1Y1AKhQlE8Jq9yedyPnE6HLzTY1QIEWFi2a2duZv/8p9QxBBFeqqx5Qi
         QYCa4bo2ngVabR+rfkJw2Cyy9Y2En7oha1MjrHXGrGR81rYcagJ8zyOtNxRloieR1ejv
         JbpNUAuUYOasDLWbE0PyRbfjD13M6s2B5Ze985ZVIOs6/8H63lR3kwUZLRaGYKEFE56b
         YxiNQOnAfdm1Ct2B+DAHs+LmQ5FVxaOUi+SPTEbGBw0LUwMLiuFxnfDvisNNNcb308AL
         oB/A==
X-Gm-Message-State: APjAAAX+0Ov7cjgKPoAZDOhqBinyDDl68k3NAhFRKT7+avlrfijx8HLp
        NF6mdDfdQj9GgIbQmqwpAz8=
X-Google-Smtp-Source: APXvYqwSsyqX0RMX0GMCIQfTIAcpB1QFMUjU+33um6kCnNYEy/E8ly6iV2x/O38Nyj/FZtNLiHcuUw==
X-Received: by 2002:a37:b303:: with SMTP id c3mr15661921qkf.253.1567891512083;
        Sat, 07 Sep 2019 14:25:12 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p10sm4056127qkg.32.2019.09.07.14.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 14:25:11 -0700 (PDT)
Date:   Sat, 7 Sep 2019 17:25:10 -0400
Message-ID: <20190907172510.GB27514@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add RXNFC support
In-Reply-To: <20190907203256.GA18741@lunn.ch>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
 <20190907200049.25273-4-vivien.didelot@gmail.com>
 <20190907203256.GA18741@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, 7 Sep 2019 22:32:56 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > +	policy = devm_kzalloc(chip->dev, sizeof(*policy), GFP_KERNEL);
> > +	if (!policy)
> > +		return -ENOMEM;
> 
> I think this might be the first time we have done dynamic memory
> allocation in the mv88e6xxx driver. It might even be a first for a DSA
> driver?
> 
> I'm not saying it is wrong, but maybe we should discuss it. 
> 
> I assume you are doing this because the ATU entry itself is not
> sufficient?
> 
> How much memory is involved here, worst case? I assume one struct
> mv88e6xxx_policy per ATU entry? Which you think is too much to
> allocate as part of chip? I guess most users will never use this
> feature, so for most users it would be wasted memory. So i do see the
> point for dynamically allocating it.

A layer 2 policy is not limited to the ATU. It can also be based on a VTU
entry, on the port's Etype, or frame's Etype. We can have 0, 1 or literally
thousands of policies programmed by the user. The ethtool API does not
store the entries and requires the driver to dump them on get operations,
hence the allocation for simplicity. But we may accomodate the DSA layer in
the future if there are more RXNFC users than just bcm_sf2 and mv88e6xxx.


Thanks,

	Vivien
