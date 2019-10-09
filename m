Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB6AD060D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 05:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfJIDXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 23:23:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41574 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbfJIDXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 23:23:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so337891plr.8
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 20:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BS9rE+yjGRMFVn4iQzDrAVJ4ljOjAMppzSSSShoh3r8=;
        b=ka76H3pK1wh3t8poFTVERdODLqPQy0DZFOpL82vKyE/8Rc/7oJpoF3tkN9a+RkyKX9
         7dvMNbtr8DORdoOwbw9ZV3bZrv3wQDSooNeodMWvTKIy699tVPxFZ8P7AvRKT4vyTEpy
         trCRj2z6GdPDO7rOukhkC2Q9JtPbrDm/GymQUg8h/xLDxlA6ATMm9FJ79/23aunrX6P0
         +wlhzDiPW5CjGKEK3PRlWEef6T3r+xIHOGtkzEFv1n8hMs+X8SOF/o8vmd1mJ1Km69R1
         5b36lLVn06E8QED5FQLDnUr3a900J12jS6Lof+QjXVXpcaw8kvOLd7+H3AFzVD039TTI
         gzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BS9rE+yjGRMFVn4iQzDrAVJ4ljOjAMppzSSSShoh3r8=;
        b=omrblGdYruxYrhPES7oD/PTiZMcyqGnLlHcvISgUMPGYYXmKZLbzmjTZQjDZP9+CAM
         qQjGGoo0F7OuKKa8N6N5jmLu4lLlMOrGdjhs31/iFtyeNGIZuvxysh6go5UcQd+q94lF
         Fm5w9YACexTqthJHYJl+4T1cvy17WwXHPvDKYm4qnldxA4sb+JTWeKPhnj8X4CemrHAo
         K6wzJhmnIeHugFlWzMYrpa7WJ0FWZENWIOc4BwUsFcR5U9LrcGJcSq7oQrYnxHSjeDDJ
         CD9XFp+jooM1NhMtxDVZUbRDeLt0vhEua/yIe9VOGYZbks4BpouQSf/1/MZncPlMC0rm
         VRfA==
X-Gm-Message-State: APjAAAWt2uBM5HNm+aupbzVrkfQ9syg7xRggPK6pNyhECNCLRM31uplc
        t/QJxLn5fMY0rQzvNuM2WXte+A==
X-Google-Smtp-Source: APXvYqy1odyLB04j5pK73M5gB5/CW4HBIMtcVNdZD2SrlZw/E0MGBPr6RGih9G6/8j2LfM5WkuQNAw==
X-Received: by 2002:a17:902:d204:: with SMTP id t4mr903741ply.253.1570591410701;
        Tue, 08 Oct 2019 20:23:30 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e127sm515713pfe.37.2019.10.08.20.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 20:23:30 -0700 (PDT)
Date:   Tue, 8 Oct 2019 20:23:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH V2 iproute2 0/3] Devlink health FMSG fixes and
 enhancements
Message-ID: <20191008202322.747f0c63@hermes.lan>
In-Reply-To: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
References: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Oct 2019 17:35:13 +0300
Tariq Toukan <tariqt@mellanox.com> wrote:

> Hi,
> 
> This patchset by Aya enhances FMSG output and fixes bugs in devlink health.
> 
> Patch 1 adds a helper function wrapping repeating code which determines
>   whether left-hand-side space separator in needed or not. It's not
>   needed after a newline.
> Patch 2 fixes left justification of FMSG output. Prior to this patch
>   the FMSG output had an extra space on the left-hand-side. This patch
>   avoids this by looking at a flag turned on by pr_out_new_line.
> Patch 3 fixes inconsistency between input and output in devlink health
>   show command.
> 
> Series generated against master commit:
> 8c2093e5d20c ip vrf: Add json support for show command
> 
> Thanks,
> Tariq
> 
> V2:
> - Dropped 4th patch, similar one is already accepted:
>   4fb98f08956f devlink: fix segfault on health command
> 
> Aya Levin (3):
>   devlink: Add helper for left justification print
>   devlink: Left justification on FMSG output
>   devlink: Fix inconsistency between command input and output
> 
>  devlink/devlink.c | 62 +++++++++++++++++++++++------------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 

Series applied.
