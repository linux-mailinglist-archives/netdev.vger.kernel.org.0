Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6EBD0504
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfJIBHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:07:33 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46920 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbfJIBHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:07:32 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so952745qtq.13
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 18:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xi2d8YnbPtNoKTE5MU434pjnJ7aieZH7aFLuNWVyKe4=;
        b=W1kqXHCu22QuOrcxpJGLDjJHqPpsK3drYlpZe3QyjjRTtOxBuZU5VH2Ou9CjN/1UwH
         PqDLnmxlk4A3VTMDpHhUsKlH9S7NvaR1jUx5+AI7dmnWFbfWWCZGV0bzxodMsnrbOGh1
         3QJ2ghwcbtqW1/Gy59MZtzRcc1pfSc8Vm3iqjZuoNBXc2R+katI7mf6LGWsWAul30FI3
         Xryymh8NQVduawo12ynFEO24SrjpLzHSDd4ogF2tH+S9x65UMHSPWNGeVpXZwwO5Oi2t
         RtB7ZJJMo5sw3oShGoEDKnqxCM2hP/tBKrsE81sU8Z8v4bpAD2YjNqdtGK4ExuhkZU08
         nbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xi2d8YnbPtNoKTE5MU434pjnJ7aieZH7aFLuNWVyKe4=;
        b=knv18yeQnWMq2/MjDMi+L4uLnpXbl9vQf+PF94M1k39Mlch+81SEzvMwvt2wffOIaS
         TAK174ZJEkdm7zjIEX2seLRPVJBTM0ZHWGkizWwjMBRKX0MEjGPVVCfGhCgyx/oibdm4
         LobJF1sjThJKEHgS4UxhG8oRiqtFjMtcFAsx2j3a7XYjix8lSbK61z2xZ9gCXu57gBd+
         JG3EhWWTY1bxwxzYBhcGEg5IDSNG3J/Zn1RHm2Ddp+UL7iV3Zgwcl/B9AAw2xdW8Yboq
         ZC4YqlFBHv4UFWy9FKgP6y/0SGYXzerqulY+KtVHU1/NuwzuzQdVNfqhv7fBWynNRkJF
         4MLw==
X-Gm-Message-State: APjAAAVkxuxOqtVc+Mjsm+ESkMP4h9HH+ZNlr0J2/6mK6JEkkHmoCido
        487PTfccXc1qKjuV1pUKHzh1tg==
X-Google-Smtp-Source: APXvYqw+Jl9QTkYHgPejcZ71bkGLE+/o7ly/iDYvs7q9750j7UKiedQF32/x3n4bY13zKX+dcdBYWA==
X-Received: by 2002:ac8:141a:: with SMTP id k26mr983395qtj.372.1570583251909;
        Tue, 08 Oct 2019 18:07:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s23sm290842qte.72.2019.10.08.18.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 18:07:31 -0700 (PDT)
Date:   Tue, 8 Oct 2019 18:07:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, mlxsw@mellanox.com
Subject: Re: [patch net-next] net: tipc: prepare attrs in
 __tipc_nl_compat_dumpit()
Message-ID: <20191008180719.2189ee8d@cakuba.netronome.com>
In-Reply-To: <20191008110151.6999-1-jiri@resnulli.us>
References: <20191008110151.6999-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 13:01:51 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> __tipc_nl_compat_dumpit() calls tipc_nl_publ_dump() which expects
> the attrs to be available by genl_dumpit_info(cb)->attrs. Add info
> struct and attr parsing in compat dumpit function.
> 
> Reported-by: syzbot+8d37c50ffb0f52941a5e@syzkaller.appspotmail.com
> Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs during dumpit")
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Dropped the empty line between Fixes and the signoff and applied.

Jon, please post a fully formed Acked-by: ... tag, if you could,
otherwise automation doesn't pick it up.
