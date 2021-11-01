Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A03442151
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 21:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhKAUHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 16:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhKAUHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 16:07:14 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A0C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 13:04:40 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id s3so14113311ybs.9
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 13:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mHv9s5DM1W3YckRTdBoFbvhxxm2NC068rmfXQbJ08As=;
        b=OwfofiM4MbGXceAx5+FLUI6faJApS/kFmFBd++XArDlBdlEXIahpb3YSqjLQ5hzIJO
         /LHnYAPQ/XPocIbxWB8PWF556GXhfZo6kSUG3EB1LOAY4AErFSzOGwV6FmLmDCX6tZLR
         qHZCXeMLaBljB17EvnlFLJUn/dZ6HCH8fv4wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mHv9s5DM1W3YckRTdBoFbvhxxm2NC068rmfXQbJ08As=;
        b=pVBu2iQC+ctOe1F9IYBgIPGdPw7EpkMbzyArum3JRGPUsSd7j6HvzgOui867yktreb
         2MdTQZcVPBGspbDE8PRORdD0JEVz/ObjiQv5hgwLf296hEJwmEzLC3zaiQiUozb2BJ1c
         EAqbQXzyaHvIR//vklBIyXMK7RqUZ6ywRTwhm+5YRQ5ELNKR/vH0YBp39sP4lMVE0irI
         3l0UwI/ehww3s2GuGQOdcj5ALni5+lWx/yODlbbuMvqn21YxtUuYwOzwhu+CCxuuaxtv
         ipM4Kqdt+8WDsYd+/BlWPQF29mDhSH2jEDPCqZxdeJ7GstujDi+xUdKQAA8r1JAimH+a
         8YsA==
X-Gm-Message-State: AOAM531F4Ks4dpIIq2OQf/Qbq0WcIXJnr+qFi7lhsZM734hwsyFGqcdo
        LX45nsakOBpJI22RG3ZcSKsb1CB8nJXTjMTYZJNlzA==
X-Google-Smtp-Source: ABdhPJxQfp5QPmyJWaWytNwIIZmwbtRiMkHSHTaLlaH1Etjs72Ov0P8f0z1PRyJe+Afs2n/vkcftvreyYZffNFa+3sQ=
X-Received: by 2002:a25:6e0a:: with SMTP id j10mr33333469ybc.361.1635797079249;
 Mon, 01 Nov 2021 13:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211030231254.2477599-1-kuba@kernel.org> <YX5Efghyxu5g8kzY@unreal>
In-Reply-To: <YX5Efghyxu5g8kzY@unreal>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Mon, 1 Nov 2021 13:04:03 -0700
Message-ID: <CAKOOJTze6-3OgNsoJYb5GuDOQAnYJfGkbsas58ek64g+eEn3iw@mail.gmail.com>
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 12:23 AM Leon Romanovsky <leon@kernel.org> wrote:

> The average driver author doesn't know locking well and won't be able to
> use devlink reference counting correctly.

I think this problem largely only exists to the extent that locking
and lifecycle requirements are poorly documented. :P

Regards,
Edwin Peer
