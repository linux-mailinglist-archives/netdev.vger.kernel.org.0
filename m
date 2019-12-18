Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7781F124A92
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfLRPCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:02:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44085 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRPCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:02:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so2623937wrm.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 07:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=blXtr+em+3S6ZxBybSMKzqKVW2qNVrHiESxiu52Em9Y=;
        b=SFxJqUL42stNk1p/Hi24opcnee8JZFJ9DBqqDAm3+1GrkcJriD5FPsXUkZnO3zk/Ct
         2Lbbb9QxEXStLp7Itzb3RWa1WM4dpmyYudA2tS6yNWVVnLmBi2zxzX8bx42cLj5Z7nja
         OQTWi95i6MSBaYFmzW8JFZAUTBw3T0xMDHg2GQdBRjeEV+cB+JQQu+Ybqc/PJCKi60P4
         o46mmIBbcDdMW4MZC7fjukJ0r9KoPAD1g3iJYgBISYAoHvKLR4MGvE0S6Gdy4d0oF5DF
         gptgiSV6uyrYzoFyY97fYUtVCtfnLFSlCbgzhpPc80b0a/3LYtfde8KnthJ9DJgLPpw6
         TzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=blXtr+em+3S6ZxBybSMKzqKVW2qNVrHiESxiu52Em9Y=;
        b=hOA/P3AOgTZQ5T8rWvkIOB6VXif3c/twqedEUM5LnIkpleqPhJwRPcBvZRRkEbGIfV
         0/br/6lahC5Hr1n/ZfJX69r8X1jVyo/qv+DZIpBonrkyE2gN5yr/6vVCnXQTJVuZZ0EZ
         Z24NUvu4GYwUhOgyfOaTersGoyaAfk2cpPwJ9tDfP0B38gO8QiVtlybleR8n52KEqeRK
         SmaRIgVAoVsUvGgVex2da0/Wlar9yvK23KwzbF/7K/28pRNaYc2wkPV3hIthQqmn8r8M
         oN3G+LaCiymyQNYHGohugYPX9J8MzqwWVzKcgrm9+h5bPp3YaZjei6+jzyCMduwpGY1Z
         sd5Q==
X-Gm-Message-State: APjAAAWoKvoEyIjfsoHvePa7qoPQeKVKSpvnoyAsIfS//QHxjnAAT25M
        slglbgomamRTurxjIXXXDVFJJS2RgH8=
X-Google-Smtp-Source: APXvYqxWeicwVLruUQOXoutDbmf7PdSgQE3XzVPFRVUqBgMyL9gR9l9g2p1GboEQsLBLhEb0VHmCLA==
X-Received: by 2002:adf:dfc9:: with SMTP id q9mr3598837wrn.219.1576681326480;
        Wed, 18 Dec 2019 07:02:06 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id y7sm6974790wmd.1.2019.12.18.07.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 07:02:06 -0800 (PST)
Date:   Wed, 18 Dec 2019 16:02:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next mlxsw v2 04/10] net: sch_ets: Add a new Qdisc
Message-ID: <20191218150205.GD2209@nanopsycho>
References: <cover.1576679650.git.petrm@mellanox.com>
 <0c126a45dcf8ec23c25c98b2ce5a9a1599ea3a85.1576679651.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c126a45dcf8ec23c25c98b2ce5a9a1599ea3a85.1576679651.git.petrm@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 18, 2019 at 03:55:13PM CET, petrm@mellanox.com wrote:
>Introduces a new Qdisc, which is based on 802.1Q-2014 wording. It is
>PRIO-like in how it is configured, meaning one needs to specify how many
>bands there are, how many are strict and how many are dwrr, quanta for the
>latter, and priomap.
>
>The new Qdisc operates like the PRIO / DRR combo would when configured as
>per the standard. The strict classes, if any, are tried for traffic first.
>When there's no traffic in any of the strict queues, the ETS ones (if any)
>are treated in the same way as in DRR.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
