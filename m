Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D027B5C9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbfG3WkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:40:06 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:37857 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfG3WkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:40:06 -0400
Received: by mail-qt1-f172.google.com with SMTP id y26so64636051qto.4
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1MqxotuYwNtT/R19ZrEsoojFQevPmP3KN0j4ArDRTmM=;
        b=yT5S90KGzXrmEr9DpCLii0WZNP31NnFqK8iLvpNKP0BIadYcoWvkXH4m8DZ6uTYkwq
         96tD/wwS45C4EdTup6M4L/W1GlnHXyXYAQHRM+BTMnbgXS8HS80r74Lm0/7Mckm4fec2
         TOQ85gmsvCPFc/YWJw/OmFAGEGdN46BXVtOnS5sGX5FXKBhrRPXgZQmswqwi4j0JhE3a
         USHpUdpuzrHy+3gVLE7MZM3MonvfBLDXSHThHQUuryTLRB4iaNFaWIu3ef+Mwb27+7iI
         cpmmfDe3Ag4D6YlruQENfoh99oe/UFnkyAo67jeLB5911dPWivQBXYkWKbIxi043Pns+
         xmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1MqxotuYwNtT/R19ZrEsoojFQevPmP3KN0j4ArDRTmM=;
        b=fKhHh/pwzqdSrM9Re5ib+1967JUg+rteweHFKT0KD0b+dGfPxDk9C8F9dB/ReYlEHU
         GeKdHRWdswuaSs6Mc+xIBqi9KEEt2MBMAGOG3fTflVVdYxkiq2TyhrEyPb8ER/sJIXso
         //xjsQqL7RVXnIWDuBzr25K/x62xE9ynA8ysvX4g+ELD96ym6Hm1yCIU7a7clHaBu/80
         jEUzgITa/SJfpWp2msnu00HkRLn5fuhlkZHkIBBOcryRhcCtggn+Vgf/Y7QrzVtFpjts
         lowRG2bbHcbNgR1OVc0QWgHnQAqs1bKSCQ2tF2ayB8IPC4unOFaC2wZStj0PMi3Scg+u
         Agqw==
X-Gm-Message-State: APjAAAXBtCJAZLdET6dGT6htgQVZuscaWwCYOIvD2E0P9yD9KsijjW6X
        muXH9bQ8X51s5SzTznqcUDRrig==
X-Google-Smtp-Source: APXvYqzhf0/l6wIiGvGMEzdgACR7oMWTtEUFhee2KeT86ILe5+AuWB2n5va+EpJ0du8D3vqc8LwKcA==
X-Received: by 2002:aed:3924:: with SMTP id l33mr79314239qte.214.1564526404966;
        Tue, 30 Jul 2019 15:40:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm27294817qkm.17.2019.07.30.15.40.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 15:40:04 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:39:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change
 namespaces
Message-ID: <20190730153952.73de7f00@cakuba.netronome.com>
In-Reply-To: <20190730085734.31504-2-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
        <20190730085734.31504-2-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 10:57:32 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> All devlink instances are created in init_net and stay there for a
> lifetime. Allow user to be able to move devlink instances into
> namespaces.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

I'm no namespace expert, but seems reasonable, so FWIW:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

If I read things right we will only send the devlink instance
notification to other namespaces when it moves, but not
notifications for sub-objects like ports. Is the expectation 
that the user space dumps the objects it cares about or will
the other notifications be added as needed (or option 3 - I 
misread the code).

I was also wondering it moving the devlink instance during a 
multi-part transaction could be an issue. But AFAIU it should 
be fine - the flashing doesn't release the instance lock, and 
health stuff should complete correctly even if devlink is moved
half way through?
